# Arquitectura — Modelo de Datos

> **ACTUALIZADO 2026-06-18** — Schema real extraído en mayo 2024.
> Ver hallazgos completos en `real-schema-findings.md`.

---

## Schema real (extraído mayo 2024 — db_inventario_pfp)

### Resumen de escala real
- 153 tablas totales (vs 17 documentadas originalmente)
- Módulos reales: taller automotriz, inventario/POS, facturación, CxC/CxP, producción, restaurante, proyectos, gasolinera
- Tablas taller automotriz con datos: 0 registros en producción (la BD es de producción del sistema POS/inventario, los datos del taller son estructurales)
- EF Migrations: 23 entradas (sistema web nuevo ya parcialmente migrado)

---

### Mapeo tabla documentada → tabla real

| Tabla documentada | Tabla real | Diferencias clave |
|---|---|---|
| `tbl_orden_servicio` | `Tbl_Orden_Servicio` | Campos extra: `Observaciones`, `Recibe_Orden`, `Encargado`, `Anticipo`, `Autorizacion`, `Serie`, `tipo` (factura asociada). Sin campo `id_empleado_recibe` ni `numero` separado — `numero` es correlativo de factura directo |
| `tbl_orden_servicio` (detalle servicios) | `Tbl_Orden_Servicio_Detalle` | `Id_Empleado` es `char(4)` (no int). Campos extra: `Descripcion`, `costo`, `Valor_comision`, `Porcentaje_comision` |
| `ordenes_servicio_integracion` | `Tbl_Orden_Servicio_Detalle_Integracion` | Campos extra: `Descripcion`, `Rebaja_Existencias`, `Costo`, `fecha_hora`. `Id_Bodega` es `char(10)` (no int) |
| `tbl_presupuesto_servicio` | `Tbl_presupuesto_servicio` | Campos extra: `fecha_operacion`, `usuario`, `num_placa`, `tarjeta`. Diferencia: `Nit` es `char(15)` (no `varchar(20)`) |
| `tbl_presupuesto_servicio_detalle` | `Tbl_presupuesto_servicio_detalle` | Campo `descripción` tiene tilde (issue de encoding). `autorizado` es `int` (no `bit`) |
| `Cliente` | `Tbl_Proveedores` | La misma tabla sirve para clientes Y proveedores. Campos extra: muchos de crédito/IVA/agente retenedor |
| `Vehiculo` | `Tbl_Vehiculos` | Sin FKs a Marca/Linea/Color — todo son campos de texto (`Marca char(25)`, `Linea char(25)`, `Color char(15)`, `Tipo char(25)`). Sin `id_vehiculo` IDENTITY |
| `Marca` | `Tbl_Marcas` | Solo tiene `Id_Empresa` y `Id_Marca char(10)`. Sin campo de nombre de marca |
| `Linea` | `Tbl_Linea_Vehiculo` | Solo `Id_Empresa`, `Id_Marca char(10)`, `Id_Linea char(10)`. Sin nombre de línea |
| `TipoVehiculo` | `Tbl_Tipo_Vehiculos` | Solo `Id_Empresa` y `Tipo char(25)`. Sin PK numérico |
| `Color` | `Tbl_colores` | Campos: `Id_Empresa`, `Color char(10)`, `uno bit`. Sin nombre largo |
| `Empresa` | `empresas` | Muchos más campos (contabilidad, moneda, restaurante, configuración avanzada). 42 campos en total |
| `Mecanico` | — | No existe tabla Mecanico separada. Los mecánicos son registros en `Tbl_Vendedores` |
| `Empleado/Vendedor` | `Tbl_Vendedores` | `Id_Empleado char(10)` (no int), `Nombre char(80)` |
| `productos_comisiones` | `tbl_productos_comisiones` | Misma estructura, `Id_Producto char(15)` (no int), agrega `Id_Empresa` |
| `tbl_productos` | `Tbl_Productos` | Mucho más completo: 30+ campos (costos, precios A/B/C, inventario, contable, sub-productos, etc.) |
| `Bodega` | `Tbl_bodega` | `Id_Bodega char(10)` (no int) |
| `Series` | `Tbl_Series` | Campos extra: `Numero_Anios`, `Fecha_vencimiento`, `Porcentaje_consumo`. `status` es `int` (no varchar) |
| `Cajas` | `Tbl_Cajas` | Misma estructura simplificada |
| `Cajeros` | `Tbl_Cajeros` | `Id_Cajero char(10)`, `Nombre char(50)` |
| `Bancos` | `Tbl_Bancos` | Misma estructura: `Id_Banco char(2)` |
| `CasasCredito` | `Tbl_Casas_Credito` | `Id_Casa char(2)` |

### Tablas del taller automotriz — DDL real

#### Tbl_Orden_Servicio (0 registros — estructura definida)
| Campo | Tipo | Notas |
|---|---|---|
| Id_Empresa | int PK | |
| Id_Orden | int PK | |
| Num_Placa | char(10) | FK implícita a Tbl_Vehiculos |
| Facturar_a | char(100) | |
| Observaciones | varchar(200) | NO documentado originalmente |
| Recibe_Orden | char(4) | FK a Tbl_Vendedores.Id_Empleado |
| Encargado | char(4) | FK a Tbl_Vendedores.Id_Empleado — NO documentado |
| Tarjeta | char(20) | |
| Fecha | datetime | |
| Status | int | 1=Abierta, 2=Cerrada |
| Nit | char(20) | FK a Tbl_Proveedores |
| Lectura_Actual | int | |
| Proximo_Servicio | int | |
| Fecha_Cierre | datetime NULL | |
| Fecha_Facturacion | datetime NULL | |
| Anticipo | numeric(18,2) | NO documentado — anticipo recibido |
| Autorizacion | char(20) | Datos de la factura emitida |
| Serie | char(5) | Datos de la factura emitida |
| tipo | char(3) | Datos de la factura emitida |
| Numero | numeric(10,0) | 0=sin factura, >0=factura emitida |

#### Tbl_Orden_Servicio_Detalle (servicios/mano de obra)
| Campo | Tipo | Notas |
|---|---|---|
| Id_Empresa | int PK | |
| Id_Orden | int PK | FK a Tbl_Orden_Servicio |
| Linea | int PK | |
| Id_Servicio | char(15) | FK a Tbl_Productos (Es_servicio=1) |
| Descripcion | char(100) | NO documentado — copia del nombre |
| Id_Empleado | char(4) | FK a Tbl_Vendedores — mecánico |
| Fosa | char(3) | |
| Precio | numeric(18,2) | |
| otros | numeric(18,2) | Subtotal insumos asociados |
| Total_Linea | numeric(18,2) | |
| Cantidad | numeric(18,2) | |
| Precio_Descuento | numeric(18,2) | |
| Total_Linea_Descuento | numeric(18,2) | |
| otros_Descuento | numeric(18,2) | |
| costo | numeric(18,5) | NO documentado — costo del servicio |
| Valor_comision | numeric(12,2) | NO documentado — comisión calculada |
| Porcentaje_comision | numeric(12,2) | NO documentado |

#### Tbl_Orden_Servicio_Detalle_Integracion (insumos/repuestos)
| Campo | Tipo | Notas |
|---|---|---|
| Id_Empresa, Id_Orden, Linea, Linea_det | int PK | Linea FK a Detalle |
| Id_Producto | char(15) | FK a Tbl_Productos |
| Descripcion | char(100) | |
| Cantidad | numeric(18,2) | |
| Precio | numeric(18,2) | |
| Id_Bodega | char(10) | FK a Tbl_bodega |
| Se_Cobra | char(1) | 'S'/'N' |
| Total_Linea | numeric(18,2) | |
| Precio_descuento | numeric(18,2) | |
| Total_Linea_descuento | numeric(18,2) | |
| Rebaja_Existencias | int | NO documentado — flag si ya rebajó stock |
| Costo | numeric(18,5) | NO documentado |
| Periodo | char(7) | |
| fecha_hora | datetime NULL | NO documentado — auditoría |

#### Tbl_Orden_Servicio_Detalle_Integracion_eliminadas (auditoría eliminaciones)
Misma estructura que la de integracion + campos: `usuario_elimino varchar(80)`, `fecha_hora_elimino datetime`, `correlativo int IDENTITY`. Tabla de auditoría no documentada.

#### Tbl_Presupuesto_Orden_Servicio (presupuesto "nuevo" — versión principal)
Misma estructura que `Tbl_Orden_Servicio`. Esta es la tabla fuente para `sp_genera_orden_servicio`.

#### tbl_presupuesto_orden_servicio_detalle (detalle de presupuesto "nuevo")
Misma estructura que `Tbl_Orden_Servicio_Detalle` + campo `Autorizado int` para aprobación por ítem.

#### Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion (insumos del presupuesto)
Misma estructura que integracion OS + campo `Autorizado int`.

#### Tbl_presupuesto_servicio (presupuesto "legacy" — versión antigua)
| Campo | Tipo |
|---|---|
| Id_empresa, Id_presupuesto | int PK |
| Nit | char(15) |
| Fecha, fecha_operacion | datetime |
| Observaciones | varchar(100) |
| usuario | char(10) |
| num_placa | varchar(50) |
| tarjeta | varchar(50) |
| status | int |

#### Tbl_presupuesto_servicio_detalle (detalle presupuesto legacy)
| Campo | Tipo |
|---|---|
| Id_empresa, Id_presupuesto | int PK |
| linea | int IDENTITY |
| descripción | varchar(50) — tiene tilde (encoding issue) |
| Valor | numeric(18,2) |
| autorizado | int |

#### Tbl_Vehiculos (0 registros — estructura definida)
| Campo | Tipo | Diferencia documentado |
|---|---|---|
| Id_Empresa | int PK | |
| Num_Placa | char(10) PK | Clave primaria compuesta (sin IDENTITY) |
| Color | char(15) | Texto libre, no FK a Tbl_colores |
| Tipo | char(25) | Texto libre, no FK a Tbl_Tipo_Vehiculos |
| Marca | char(25) | Texto libre, no FK a Tbl_Marcas |
| Linea | char(25) | Texto libre, no FK a Tbl_Linea_Vehiculo |
| Modelo | char(4) | |
| Puertas | char(1) | |
| Cilindros | char(10) | |
| motor | char(15) | |
| Unidad_Medida | char(10) | |
| Presion_Llantas | int | |
| combustible | char(10) | |
| servicio_cada | int | |
| nit | char(20) | FK a Tbl_Proveedores |
| Fecha_Ult_Mov | datetime | |

**Nota importante**: `Tbl_Vehiculos` NO tiene FKs a los catálogos (Marcas, Colores, Tipos, Líneas). Los catálogos existen pero el vehículo guarda texto plano. Esto explica por qué los SPs de búsqueda de marca/linea son independientes.

#### Tbl_Vendedores (mecánicos y empleados)
| Campo | Tipo |
|---|---|
| Id_Empresa | int PK |
| Id_Empleado | char(10) PK |
| Nombre | char(80) |
| porc_comision | numeric(18,2) |
| status | char(1) | 'A'/'B' |

**Nota**: Los mecánicos son `Tbl_Vendedores`. No hay tabla `Mecanico` separada. La referencia en `Tbl_Orden_Servicio_Detalle.Id_Empleado` es `char(4)` (truncado respecto a `char(10)`).

#### Tbl_Productos (servicios e insumos)
| Campo clave | Tipo | Notas |
|---|---|---|
| Id_Empresa | int PK | |
| Id_Producto | char(15) PK | Código alfanumérico (no int IDENTITY) |
| Descripcion | char(100) | |
| Descripcion_Corta | char(100) | |
| Es_servicio | int | 1=servicio/mano obra, 0=producto/insumo |
| Precioa/b/c | numeric(18,2) | Tres niveles de precio |
| Costo_Promedio | numeric(12,5) | |
| Id_Articulo | char(5) | FK a Tbl_articulos (categoría) |
| Id_Depto | char(3) | FK a Tbl_departamentos |
| estado | char(15) | Estado activo/baja |

#### tbl_productos_comisiones
| Campo | Tipo |
|---|---|
| Id_Empresa | int PK |
| Id_Producto | char(15) PK | Código del servicio |
| Tipo_comision | int | 1=valor fijo, 2=porcentaje |
| Valor_comision | numeric(12,2) | |
| Porcentaje_comision | numeric(12,2) | |

#### Tbl_Insumos_Servicios (relación servicio-insumos)
| Campo | Tipo | Notas |
|---|---|---|
| Id_empresa | int PK | |
| Id_producto | char(15) PK | Servicio padre |
| Id_Producto1 | char(15) PK | Insumo asociado |
| Costo | numeric(18,2) | |
| Cantidad | numeric(18,0) | |
Tabla no documentada: define qué insumos se usan automáticamente al agregar un servicio.

---

## Schema documentado (referencia VFP — puede diferir del real)

### Diagrama de relaciones
```
Empresa
  ├── Cliente ──────────────────────── Vehiculo
  │     │                                 ├── Marca
  │     │                                 │     └── Linea
  │     │                                 ├── TipoVehiculo
  │     │                                 └── Color
  │     │
  │     └── Presupuesto (tbl_presupuesto_servicio)
  │               └── DetallePresupuesto (tbl_presupuesto_servicio_detalle)
  │                         ↓ [sp_genera_orden_servicio] (solo autorizado=1)
  │
  ├── OrdenServicio (tbl_orden_servicio)
  │       ├── DetalleServicios
  │       │       ├── → tbl_productos (es_servicio=1)
  │       │       └── → Empleado (mecánico)
  │       └── Integracion (ordenes_servicio_integracion)
  │               ├── → tbl_productos (es_servicio=0)
  │               └── → Bodega
  │                       └── Existencias → tbl_productos
  │
  ├── Series ── Cajas ── Cajeros
  ├── Empleados / Vendedores
  ├── Bancos
  ├── CasasCredito
  └── Bodegas
```

---

## Tablas detalladas

### Empresa
| Campo | Tipo | Restricciones |
|-------|------|--------------|
| id_empresa | int | PK |
| nombre_empresa | varchar(100) | |
| sig_orden_servicio | int | Contador autoincremental de OS |
| sig_numero_presupuesto | int | Contador autoincremental de presupuestos |
| id_bodega_facturacion | int | FK → bodega (bodega por defecto) |
| total_detalle_lineas | int | Límite de líneas por documento |
| periodo | varchar(7) | Período contable activo MM/AAAA |

### Cliente
| Campo | Tipo | Restricciones |
|-------|------|--------------|
| id_cliente | int | PK IDENTITY |
| nit | varchar(20) | UNIQUE, inmutable después de creado |
| nombre | varchar(100) | Razón social |
| facturar_a | varchar(100) | NOT NULL |
| direccion | varchar(200) | |
| municipio | varchar(50) | |
| departamento | varchar(50) | |
| telefono1 | varchar(20) | |
| telefono2 | varchar(20) | |
| correo_electronico | varchar(100) | |
| tipo_precio | varchar(1) | A/B/C |
| identificacion | varchar(20) | Datos financieros |
| tarjeta | varchar(20) | |
| porcentaje_descuento | decimal(5,2) | Solo activo si tarjeta ≠ vacío |
| credito_o_contado | varchar(10) | 'Crédito' o 'Contado' |
| dias_credito | int | |
| estado | int | 1=activo, 0=inactivo |
| fecha_ult_mov | datetime | Solo lectura |
| id_empresa | int | FK → empresa |

### Vehiculo
| Campo | Tipo | Restricciones |
|-------|------|--------------|
| id_vehiculo | int | PK IDENTITY |
| num_placa | varchar(10) | UNIQUE por empresa |
| nit | varchar(20) | FK → cliente |
| id_linea | int | FK → linea |
| id_tipo | int | FK → tipo_vehiculo |
| id_color | int | FK → color, NOT NULL |
| modelo | varchar(4) | Año (ej: 2019) |
| puertas | int | |
| cilindros | int | |
| motor | varchar(25) | |
| motor_de | varchar(10) | Tipo de motor |
| unidad_medida | varchar(10) | 'Millas' o 'Kilometros' |
| presion_llantas | int | PSI |
| servicio_cada | varchar(5) | Intervalo |
| combustible | varchar(10) | 'Gasolina' o 'Diesel' |
| fecha_ult_mov | datetime | Solo lectura |
| id_empresa | int | FK → empresa |

### Marca
| Campo | Tipo |
|-------|------|
| id_marca_vehiculo | int PK |
| marca_vehiculo | nvarchar(100) |
| id_empresa | int FK |

### Linea
| Campo | Tipo |
|-------|------|
| id_linea | int PK |
| linea_vehiculo | nvarchar(50) |
| id_marca_vehiculo | int FK → marca |

### TipoVehiculo
| Campo | Tipo |
|-------|------|
| id_tipo_vehiculo | int PK |
| estilo_vehiculo | nvarchar(50) |

### Color
| Campo | Tipo |
|-------|------|
| id_color | int PK |
| nombre_color | nvarchar(100) |
| id_empresa | int FK |

### tbl_presupuesto_servicio (Presupuesto — versión activa)
| Campo | Tipo | Restricciones |
|-------|------|--------------|
| id_presupuesto | int | PK IDENTITY |
| id_empresa | int | FK → empresa |
| nit | varchar(20) | FK → cliente |
| num_placa | varchar(10) | FK → vehiculo |
| tarjeta | varchar(20) | |
| fecha | datetime | |
| observaciones | varchar(200) | |
| status | int | 1=Abierto, 2=Cerrado |

### tbl_presupuesto_servicio_detalle
| Campo | Tipo | Restricciones |
|-------|------|--------------|
| id_detalle | int | PK IDENTITY |
| id_presupuesto | int | FK → presupuesto |
| descripcion | varchar(250) | |
| valor | decimal(18,2) | |
| autorizado | bit | 0=no, 1=sí |

### tbl_orden_servicio (Orden de Servicio)
| Campo | Tipo | Restricciones |
|-------|------|--------------|
| id_orden | int | PK (asignado desde empresas.sig_orden_servicio) |
| id_empresa | int | FK → empresa |
| nit | varchar(20) | FK → cliente, NOT NULL |
| num_placa | varchar(10) | FK → vehiculo, NOT NULL |
| facturar_a | varchar(100) | |
| fecha | datetime | |
| fecha_cierre | datetime | NULL mientras status=1 |
| id_empleado_recibe | int | FK → empleados, NOT NULL |
| status | int | 1=Abierta, 2=Cerrada |
| tarjeta | varchar(20) | |
| proximo_servicio | int | Lectura/km del próximo servicio |
| lectura_actual | int | Lectura/km al momento del servicio |
| numero | int | 0=no facturada, >0=número de factura |
| fecha_facturacion | datetime | NULL si no facturada |

### detalle_servicios
| Campo | Tipo | Restricciones |
|-------|------|--------------|
| linea | int | Autoincremental por orden |
| id_orden | int | FK → orden |
| id_empresa | int | FK → empresa |
| id_servicio | int | FK → tbl_productos (es_servicio=1) |
| id_empleado | int | FK → empleados (mecánico), NOT NULL |
| fosa | varchar(10) | |
| cantidad | decimal(28,2) | |
| precio | decimal(18,2) | |
| precio_descuento | decimal(18,2) | |
| otros | decimal(18,2) | Subtotal insumos asociados |
| otros_descuento | decimal(18,2) | |
| total_linea | decimal(18,2) | |
| total_linea_descuento | decimal(18,2) | |

### ordenes_servicio_integracion (Insumos)
| Campo | Tipo | Restricciones |
|-------|------|--------------|
| linea_det | int | Autoincremental |
| id_orden | int | FK → orden |
| id_empresa | int | FK → empresa |
| id_producto | int | FK → tbl_productos (es_servicio=0) |
| id_bodega | int | FK → bodega, NOT NULL |
| se_cobra | varchar(1) | 'S' o 'N' |
| cantidad | decimal(28,2) | |
| precio | decimal(18,2) | |
| precio_descuento | decimal(18,2) | |
| total_linea | decimal(18,2) | |
| total_linea_descuento | decimal(18,2) | |
| periodo | varchar(7) | = cPeriodo global (MM/AAAA) |

### tbl_productos (Productos y Servicios)
| Campo | Tipo | Notas |
|-------|------|-------|
| id_producto | int PK | |
| descripcion | varchar | Nombre completo |
| descripcion_corta | varchar | Para búsquedas rápidas |
| es_servicio | bit | 1=mano de obra, 0=repuesto/insumo |
| id_empresa | int FK | |

### Mecanico
| Campo | Tipo | Notas |
|-------|------|-------|
| id_mecanico | int PK | |
| nombre | nvarchar(100) | |
| comision | decimal(5,2) | (ACTUALMENTE int — BUG-002) |
| id_empresa | int FK | |

### productos_comisiones
| Campo | Tipo | Notas |
|-------|------|-------|
| id_servicio | int | FK → tbl_productos (es_servicio=1) — (ACTUALMENTE id_producto — INC-001) |
| tipo_comision | int | 1=Valor fijo, 2=Porcentaje |
| valor_comision | decimal(18,2) | |
| porcentaje_comision | decimal(5,2) | |

### Empleado / Vendedor
| Campo | Tipo |
|-------|------|
| id_empleado | int PK |
| nombre | varchar(100) |
| porc_comision | decimal(5,2) |
| status | varchar(1) | 'A'=Activo, 'B'=Baja |

### Bodega
| Campo | Tipo |
|-------|------|
| id_bodega | int PK |
| nombre_bodega | varchar(100) |
| id_empresa | int FK |

### Series
| Campo | Tipo |
|-------|------|
| id_serie | int PK |
| autorizacion | varchar(20) |
| serie | varchar(10) |
| id_tipo | int |
| del | int | Correlativo inicial |
| al | int | Correlativo final |
| actual | int | Correlativo actual (se incrementa) |
| fecha_ingreso | datetime |
| descripcion | varchar(100) |
| status | varchar(10) | 'Alta' / 'Baja' |
