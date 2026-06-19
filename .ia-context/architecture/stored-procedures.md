# Arquitectura — Stored Procedures y SQL Directo

## Patrón de comunicación VFP → SQL Server
El sistema VFP **NO genera XML** desde los formularios.
La comunicación es vía `SQLEXEC()` con SQL inline o `exec sp_nombre ?parametro`.
Los SPs de SQL Server que usan XML son internos al SP (no los llama el VFP con XML).

Conexión: `SQLCONNECT("inventarios","sa","")` — hardcoded en 8 formularios (ver SEC-001 en technical-debt.md)

---

## Stored Procedures por módulo

### Clientes
| SP | Parámetros | Descripción |
|----|-----------|-------------|
| `sp_insertacliente` | XML | Inserta o actualiza cliente |
| `sp_buscar_cliente` | — | Lista clientes con `estado=1` → campos: NIT, FacturarA, correo |
| `sp_eliminacliente` | `@IdCliente int` | Elimina cliente |
| `sp_lista_cliente` | — | Lista clientes con IdCliente (3 versiones duplicadas — BUG-003) |
| `sp_vehiculo_cliente` | `@NIT varchar(20)` | Devuelve vehículos de un cliente |

### Vehículos
| SP | Parámetros | Descripción |
|----|-----------|-------------|
| `sp_insertavehiculo` | XML | Inserta vehículo (contiene BUG-001: Puertas→Modelo) |
| `sp_lista_vehiculo` | — | Lista vehículos con join a Línea/Cliente |
| `sp_eliminavehiculo` | `@IdVehiculo int` | Elimina vehículo |
| `sp_buscar_placa` | `@Placa nvarchar(10)` | Verifica si una placa existe → devuelve NumPlaca |

### Catálogos de vehículos
| SP | Parámetros | Descripción |
|----|-----------|-------------|
| `sp_insertamarca` | XML | Inserta o actualiza marca |
| `sp_lista_marca` | — | Lista marcas |
| `rpt_lista_marca` | — | Igual a sp_lista_marca (duplicado) |
| `sp_eliminamarca` | `@IdMarca int` | Elimina marca y cascada a líneas |
| `sp_lista_linea` | `@IdMarcaVehiculo int` | Líneas filtradas por marca |
| `sp_buscar_lineavehiculo` | — | Lista todas las líneas |
| `sp_insertacolor` | XML | Inserta o actualiza color |
| `sp_lista_color` | — | Lista colores |
| `sp_eliminacolor` | `@IdColor int` | Elimina color |
| `sp_insertatipovehiculo` | parámetros directos | Inserta tipo de vehículo |
| `sp_lista_tipovehiculo` | — | Lista tipos |
| `sp_eliminatipovehiculo` | `@IdTipo int` | Elimina tipo |

### Mecánicos
| SP | Parámetros | Descripción |
|----|-----------|-------------|
| `sp_insertamecanico` | XML | Inserta mecánico |
| `sp_lista_mecanico` | — | Lista mecánicos con IdMecanico, Nombre, Comision |
| `sp_eliminamecanico` | `@IdMecanico int` | Elimina mecánico |

### Presupuestos
| SP | Parámetros | Descripción |
|----|-----------|-------------|
| `sp_insertapresupuesto` | XML | Inserta presupuesto |
| `sp_lista_presupuesto` | — | Lista presupuestos con join a Vehículo |

### Órdenes de Servicio
| SP / Función | Parámetros | Descripción |
|----|-----------|-------------|
| `sp_genera_orden_servicio` | empresa, presupuesto, orden | Convierte presupuesto → OS (solo `autorizado=1`) |
| `sp_cambia_descuento_ordenes` | empresa, orden, aplica(0/1) | Resetea/aplica descuento en orden |
| `dbo.total_lineas_orden` | empresa, orden | Función escalar — cuenta líneas en una OS |
| `sp_devuelve_NumOServicio` | fecha_inicial datetime, fecha_final datetime | Cuenta OS en un rango de fechas |

### Inventario / Bodega
| SP | Parámetros | Descripción |
|----|-----------|-------------|
| `sp_insertabodega` | parámetros directos | Inserta bodega |
| `sp_lista_producto` | — | Lista productos (2 versiones duplicadas — BUG-003) |

### Reportes / OLAP
| SP | Parámetros | Descripción |
|----|-----------|-------------|
| `co_ordenes_servicio` | int (hardcoded=1) | Datos para cubo OLAP de órdenes |

---

## SQL Directo (sin SP) por formulario

### frm_anular_ordenes_servicio
```sql
-- Carga combo de órdenes reversibles
SELECT * FROM tbl_orden_servicio
WHERE id_empresa = ?nEmpresa
  AND status = 2
  AND fecha_facturacion IS NULL

-- Revierte el cierre
UPDATE tbl_orden_servicio
SET status = 1
WHERE id_empresa = ?nEmpresa
  AND id_orden = ?cOrden
  AND status = 2
  AND numero = 0
```

### frm_orden_servicios (validación de duplicado)
```sql
SELECT Id_Orden FROM Tbl_Orden_Servicio
WHERE Id_Empresa = ?nEmpresa
  AND Id_Orden = ?nOrden
  AND status = 2
```

### frm_genera_orden_servicio (verificación previa)
```sql
SELECT * FROM tbl_orden_servicio
WHERE id_empresa = ?nempresa
  AND id_orden = ?norden
```

### frm_reporte_servicios (combo de órdenes)
```sql
SELECT Id_Orden, Facturar_a, num_placa
FROM tbl_orden_Servicio
WHERE ID_EMPRESA = ?NEMPRESA
```

### frm_mantenimiento_servicios_comisiones (carga servicios)
```sql
SELECT Id_producto, descripcion
FROM tbl_productos
WHERE id_empresa = ?nempresa
  AND es_servicio = 1
```

### frm_presupuestos_new (obtener ID generado)
```sql
SELECT ISNULL(IDENT_CURRENT('TBL_PRESUPUESTO_SERVICIO'), 0) AS ultimo
```

### frm_consulta_servicios (OLAP, conexión ADO directa)
```
Provider=MSDASQL.1;Data Source=inventarios;Initial Catalog=db_inventario_pfp
EXEC co_ordenes_servicio 1
```
