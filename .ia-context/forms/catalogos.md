# Formularios — Catálogos

## frm_marcas_vehiculos
**Tipo:** CRUD con detalle padre-hijo
**Tablas:** `marcas` (padre) + `linea_vehiculos` (hijo)

| Tabla | Campos |
|-------|--------|
| marcas | id_marca (PK), marca, id_empresa (FK) |
| linea_vehiculos | id_linea (PK), linea, id_marca (FK) |

**Regla:** Al eliminar una marca, se eliminan en cascada sus líneas.
**En OS y vehículos:** Al cambiar la marca, el combo de líneas se recarga con `requery()`.

---

## frm_tipos_vehiculos
**Tipo:** CRUD simple
**Tabla:** `tipos_vehiculos`

| Campo | Tipo |
|-------|------|
| id_tipo | int PK |
| tipo | varchar (nombre del estilo/tipo) |

---

## frm_colores_vehiculos
**Tipo:** CRUD simple en grilla
**Tabla:** `colores`

| Campo | Tipo |
|-------|------|
| id_color | int PK |
| color | varchar (nombre del color) |
| id_empresa | int FK |

---

## frm_colores_vehiculos2
**Tipo:** Modal — versión que se abre inline desde frm_vehiculos
**Misma tabla** que frm_colores_vehiculos.
**Caso de uso:** El usuario está registrando un vehículo y el color no existe — puede agregar uno nuevo sin perder el contexto del vehículo.

---

## frm_vendedores
**Tipo:** CRUD
**Tabla:** `vendedores`

| Campo | Tipo | Notas |
|-------|------|-------|
| id_empleado | int PK | |
| nombre | varchar(100) | |
| porc_comision | decimal(5,2) | Porcentaje de comisión del vendedor |
| status | varchar(1) | 'A'=Activo, 'B'=Baja |

**Nota:** Esta tabla sirve como tanto "vendedor" (recibe_orden en OS) como "mecánico" (id_empleado en detalle_servicios).

---

## frm_bancos
**Tipo:** CRUD simple
**Tabla:** `bancos`

| Campo | Tipo |
|-------|------|
| id_banco | int PK |
| nombre | varchar |

---

## frm_casas_credito
**Tipo:** CRUD simple
**Tabla:** `casas_credito`

| Campo | Tipo |
|-------|------|
| id_casa | int PK |
| nombre | varchar |

---

## frm_mantenimiento_servicios_comisiones
**Tipo:** CRUD
**Tabla:** `productos_comisiones`

| Campo | Tipo | Notas |
|-------|------|-------|
| id_producto | int | FK tbl_productos (es_servicio=1) — **debería llamarse id_servicio (INC-001)** |
| tipo_comision | int | 1=Valor fijo, 2=Porcentaje |
| valor_comision | decimal(18,2) | Monto fijo cuando tipo_comision=1 |
| porcentaje_comision | decimal(5,2) | Porcentaje cuando tipo_comision=2 |

### SQL directo
```sql
-- Carga combo de servicios disponibles:
SQLCONNECT("inventarios","sa","")
SELECT Id_producto, descripcion
FROM tbl_productos
WHERE id_empresa = ?nempresa
  AND es_servicio = 1
```

**Importante:** El SP/query carga servicios desde SQL Server directamente (no desde VFP local).
