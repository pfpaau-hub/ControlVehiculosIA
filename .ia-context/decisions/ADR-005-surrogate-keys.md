# ADR-005 — Migración de Llaves Compuestas a Llaves Sustitutas

**Estado:** Propuesto
**Fecha:** 2026-06-18

---

## Contexto

El sistema actual usa llaves primarias **compuestas** en todas las tablas, donde `Id_Empresa` siempre es el primer campo. Ejemplo:

- `Tbl_Orden_Servicio` PK = `(Id_Empresa, Id_Orden)`
- `Tbl_Orden_Servicio_Detalle` PK = `(Id_Empresa, Id_Orden, Linea)`
- `Tbl_Orden_Servicio_Detalle_Integracion` PK = `(Id_Empresa, Id_Orden, Linea, Linea_det)` — 4 campos

Esto causa:
- FKs compuestas que se propagan en cadena (4 campos para referenciar un insumo)
- JOIN complejos en los SPs
- EF Core puede manejarlas pero con configuración verbose
- Dificulta paginación, cache y APIs REST (URLs como `/ordenes/1/1` son ambiguas sin empresa)

## Decisión

Agregar una **llave sustituta** (`Id` IDENTITY) como PK en cada tabla del módulo taller.  
La llave natural compuesta se convierte en **UNIQUE constraint** para preservar la integridad de negocio.  
`Id_Empresa` permanece como columna normal — filtrado vía **EF Core Global Query Filter**.

---

## Patrón aplicado a cada tabla

### Tablas del módulo taller — estado actual vs nuevo

| Tabla | PK actual (compuesta) | Nueva PK | Unique constraint |
|-------|----------------------|----------|-------------------|
| `Tbl_Orden_Servicio` | `(Id_Empresa, Id_Orden)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Orden)` |
| `Tbl_Orden_Servicio_Detalle` | `(Id_Empresa, Id_Orden, Linea)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Orden, Linea)` |
| `Tbl_Orden_Servicio_Detalle_Integracion` | `(Id_Empresa, Id_Orden, Linea, Linea_det)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Orden, Linea, Linea_det)` |
| `Tbl_Orden_Servicio_Detalle_Integracion_eliminadas` | `(Id_Empresa, Id_Orden, Linea, Linea_det, correlativo)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Orden, Linea, Linea_det, correlativo)` |
| `Tbl_Presupuesto_Orden_Servicio` | `(Id_Empresa, Id_Orden)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Orden)` |
| `tbl_presupuesto_orden_servicio_detalle` | `(Id_Empresa, Id_Orden, Linea)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Orden, Linea)` |
| `Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion` | `(Id_Empresa, Id_Orden, Linea, Linea_det)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Orden, Linea, Linea_det)` |
| `Tbl_Proveedores` (clientes) | `(Id_Empresa, Nit)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Nit)` |
| `Tbl_Vehiculos` | `(Id_Empresa, Num_Placa)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Num_Placa)` |
| `Tbl_Marcas` | `(Id_Empresa, Id_Marca)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Marca)` |
| `Tbl_Linea_Vehiculo` | `(Id_Empresa, Id_Marca, Id_Linea)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Marca, Id_Linea)` |
| `Tbl_Tipo_Vehiculos` | `(Id_Empresa, Tipo)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Tipo)` |
| `Tbl_colores` | `(Id_Empresa, Color)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Color)` |
| `Tbl_Vendedores` | `(Id_Empresa, Id_Empleado)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Empleado)` |
| `Tbl_bodega` | `(Id_Empresa, Id_Bodega)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Bodega)` |
| `Tbl_Productos` | `(Id_Empresa, Id_Producto)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Producto)` |
| `tbl_productos_comisiones` | `(Id_Empresa, Id_Producto)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Producto)` |
| `Tbl_Cajas` | `(Id_Empresa, Id_Caja)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Caja)` |
| `Tbl_Cajeros` | `(Id_Empresa, Id_Cajero)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Cajero)` |
| `Tbl_Bancos` | `(Id_Empresa, Id_Banco)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Banco)` |
| `Tbl_Casas_Credito` | `(Id_Empresa, Id_Casa)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Id_Casa)` |
| `Tbl_Series` | `(Id_Empresa, Autorizacion)` | `Id` int IDENTITY | `UNIQUE (Id_Empresa, Autorizacion)` |

---

## Cómo cambian las FKs

### Antes (compuestas en cascada)
```
Tbl_Orden_Servicio_Detalle_Integracion
  FK → Tbl_Orden_Servicio_Detalle  via (Id_Empresa, Id_Orden, Linea)
  FK → Tbl_Orden_Servicio          via (Id_Empresa, Id_Orden)
```

### Después (surrogate, limpio)
```
Tbl_Orden_Servicio_Detalle_Integracion
  FK OrdenServicioDetalleId → Tbl_Orden_Servicio_Detalle.Id
  -- Id_Empresa se mantiene como columna para el Global Query Filter
```

### Jerarquía completa del módulo taller con surrogate keys

```
empresas.Id_Empresa (int, ya tiene PK simple) ← sin cambio
│
├── Tbl_Proveedores.Id (IDENTITY)
│     └── [FK] Tbl_Vehiculos.ProveedorId → Tbl_Proveedores.Id
│           └── [FK] Tbl_Orden_Servicio.VehiculoId → Tbl_Vehiculos.Id
│                 ├── [FK] Tbl_Orden_Servicio_Detalle.OrdenServicioId → OS.Id
│                 │     └── [FK] Tbl_Orden_Servicio_Detalle_Integracion.OrdenDetalleId → OSD.Id
│                 └── referencia plana a Tbl_Presupuesto_Orden_Servicio.Id
│
├── Tbl_Marcas.Id (IDENTITY)
│     └── [FK] Tbl_Linea_Vehiculo.MarcaId → Tbl_Marcas.Id
│
├── Tbl_Productos.Id (IDENTITY)
│     └── [FK] tbl_productos_comisiones.ProductoId → Tbl_Productos.Id
│
└── Tbl_Vendedores.Id (IDENTITY)
      └── referenciado en Tbl_Orden_Servicio_Detalle.EmpleadoId
```

---

## Multi-empresa: Global Query Filter en EF Core

`Id_Empresa` **no se elimina** de ninguna tabla. Se usa como filtro automático vía EF Core.

```csharp
// AppDbContext.cs
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    // Aplicar a TODAS las entidades que tienen Id_Empresa
    modelBuilder.Entity<OrdenServicio>()
        .HasQueryFilter(o => o.IdEmpresa == _empresaContext.IdEmpresa);

    modelBuilder.Entity<Proveedor>()
        .HasQueryFilter(p => p.IdEmpresa == _empresaContext.IdEmpresa);

    // etc. para cada entidad
}

// IEmpresaContext.cs — inyectado desde el JWT
public interface IEmpresaContext
{
    int IdEmpresa { get; }
}
```

Con esto, `db.OrdenesServicio.ToList()` retorna automáticamente solo las de la empresa activa. Sin tener que escribir `WHERE Id_Empresa = @n` en cada query.

---

## Impacto en los SPs existentes

Los SPs actuales referencian los campos compuestos directamente. Al migrar al nuevo sistema:

- **SPs de reportes (`rpt_*`)**: reescribir como queries en Dapper o LINQ, eliminando los JOINs por campos múltiples.
- **`sp_genera_orden_servicio`**: reemplazar por un método de servicio en C# que usa EF Core con las nuevas FKs surrogate.
- **Los SPs del sistema VFP activo** quedan sin cambio mientras corre en paralelo.

---

## Resumen de beneficios

| Aspecto | Antes | Después |
|---------|-------|---------|
| FK más compleja | 4 campos `(Id_Empresa, Id_Orden, Linea, Linea_det)` | 1 campo `OrdenDetalleId int` |
| URL de API | `/ordenes?empresa=1&orden=23` | `/ordenes/47` |
| EF Core navigation | Configuración manual de composite keys | Convencional automático |
| Multi-empresa | Manual en cada query | Global Query Filter automático |
| Migración de datos | Agregar columna `Id IDENTITY` a cada tabla existente | Script de ALTER TABLE |
