# Hallazgos — Schema Real (db_inventario_pfp, mayo 2024)

> Extraído de SQL Server 2019 Express. Análisis realizado 2026-06-18.
> La BD tiene 153 tablas. El sistema documentado esperaba 17.
> Es una BD **multimódulo**: taller automotriz + POS/inventario + facturación + CxC/CxP + producción + restaurante + gasolinera + proyectos.

---

## A. Tablas taller automotriz — estado en producción

Todas las tablas del módulo taller tienen **0 registros** en esta BD. La estructura existe pero los datos de taller se guardan en otra instancia o esta BD corresponde principalmente al módulo de inventario/POS.

Tablas con 0 registros del módulo taller:
- `Tbl_Orden_Servicio`, `Tbl_Orden_Servicio_Detalle`, `Tbl_Orden_Servicio_Detalle_Integracion`
- `Tbl_Presupuesto_Orden_Servicio`, `tbl_presupuesto_orden_servicio_detalle`, `Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion`
- `Tbl_presupuesto_servicio`, `Tbl_presupuesto_servicio_detalle`
- `Tbl_Vehiculos`, `Tbl_Marcas`, `Tbl_Linea_Vehiculo`, `Tbl_Tipo_Vehiculos`, `Tbl_colores`
- `tbl_productos_comisiones`, `Tbl_insumos_servicios`
- `Tbl_Vendedores` (0 registros — mecánicos/empleados)

---

## B. Tablas nuevas descubiertas (clasificadas por módulo)

### Módulo Automotriz — tablas no documentadas
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_Orden_Servicio_Detalle_Integracion_eliminadas` | 0 | Auditoría de insumos eliminados de OS. Campos extra: `usuario_elimino`, `fecha_hora_elimino`, `correlativo` |
| `Tbl_Presupuesto_Orden_Servicio` | 0 | Tabla de presupuesto "nuevo" — es la que usa `sp_genera_orden_servicio` como fuente, no `Tbl_presupuesto_servicio` |
| `tbl_presupuesto_orden_servicio_detalle` | 0 | Detalle del presupuesto nuevo con campo `Autorizado` |
| `Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion` | 0 | Insumos del presupuesto nuevo |
| `Tbl_insumos_servicios` | 0 | Relaciona servicios con sus insumos predeterminados |

**Hallazgo crítico**: El sistema tiene **DOS sistemas de presupuesto** que persisten en la BD:
1. `Tbl_presupuesto_servicio` / `Tbl_presupuesto_servicio_detalle` — versión legacy
2. `Tbl_Presupuesto_Orden_Servicio` / `tbl_presupuesto_orden_servicio_detalle` — versión nueva (la que usa `sp_genera_orden_servicio`)

El SP `sp_genera_orden_servicio` lee de `Tbl_Presupuesto_Orden_Servicio`, NO de `Tbl_presupuesto_servicio`.

### Módulo POS / Facturación
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_Cab_Facturacion` | 0 | Cabecera de facturas POS |
| `Tbl_Det_Facturacion` | 0 | Detalle de facturas POS |
| `Tbl_Det_Facturacion_SProducto` | 0 | Sub-productos en factura |
| `Tbl_Cab_Notas_Credito` | 3 | Notas de crédito |
| `Tbl_Det_Notas_Credito` | 0 | Detalle notas de crédito |
| `Tbl_Anticipos_Pos` | 0 | Anticipos en POS |
| `Tbl_anticipos_pos_aplicacion` | 0 | Aplicaciones de anticipos |
| `anuladas` | 234 | Facturas anuladas (Serie, Tipo, Número, Descripción) |
| `TblFacturaTCProcesamientos` | 0 | Procesamiento de pagos con tarjeta (respuesta del banco) |
| `Tbl_Arqueo_Caja` | 0 | Arqueos de caja |
| `Tbl_Cortes` | 0 | Cortes de caja |
| `Tbl_Series` | 0 | Series de facturación (reemplaza la tabla `Series` documentada) |
| `Tbl_Series_Por_Caja` | 1 | Asignación de series por caja |
| `Tbl_Conf_Empresa` | 4 | Configuración de formas de pago aceptadas |
| `Tbl_Configuracion` | 1 | IP, caja, empresa, tasa de cambio por punto |
| `Tbl_impuesto_carburantes` | 0 | Impuesto especial gasolina |

### Módulo Inventario / Compras
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_cabecera_movimientos` | 18 | Encabezado de movimientos de inventario |
| `Tbl_Detalle_movimientos` | 46 | Detalle de movimientos |
| `Tbl_Detalle_movimientos_sub` | 0 | Sub-detalle de movimientos |
| `Tbl_Tipos_Inv` | 11 | Tipos de movimiento de inventario (compra, venta, ajuste, etc.) |
| `Tbl_existencia` | 21 | Existencias por bodega y periodo |
| `Tbl_inventario_fisico` | 2 | Cabecera de conteo físico |
| `Tbl_inventario_fisico_detalle` | 136 | Detalle de conteo físico |
| `tbl_bk_tbl_inventario_fisico_detalle` | 118 | Backup del conteo físico |
| `Tbl_pedidos` | 2 | Pedidos a proveedores |
| `Tbl_detalle_pedidos` | 2 | Detalle de pedidos |
| `Tbl_recepcion_pedidos` | 5 | Recepciones de pedidos |
| `Tbl_recepcion_pedidos_detalle` | 5 | Detalle de recepciones |
| `Tbl_Cab_generacion_compras` | 3 | Generación de compras desde recepción |
| `Tbl_Detalle_generacion_compra` | 5 | Detalle de generación de compras |
| `Tbl_detalle_compras` | 0 | Detalle de compras aplicadas |
| `Tbl_Cambios_CostPrec` | 125 | Historial de cambios de costo y precio |
| `Tbl_Unidad_Medida` | 66 | Unidades de medida |
| `Tbl_articulos` | 7 | Categorías de artículos (para configuración contable) |
| `Tbl_Linea` | 1 | Líneas de producto (depto + linea) — diferente a `Tbl_Linea_Vehiculo` |
| `Tbl_departamentos` | 1 | Departamentos de producto (para contabilidad) |
| `Tbl_productos_configuracion_contable` | 257 | Configuración contable por producto |
| `Tbl_SProductos` | 1560 | Sub-productos (ingredientes/componentes) |
| `Tbl_producto_conversion` | 0 | Conversión entre productos |
| `Tbl_det_explosion` | 0 | Explosión de producción |
| `Tbl_Prod_Proveedores` | 1 | Código alterno de producto por proveedor |
| `Tbl_importacion` | 4 | Importaciones |
| `Tbl_detalle_importacion` | 0 | Detalle de importaciones |
| `Tbl_Cab_Oferta` | 0 | Ofertas/promociones |
| `Tbl_Det_Oferta` | 0 | Detalle de ofertas |
| `Tbl_tipo_ocompra` | 4 | Tipos de orden de compra |

### Módulo Clientes / CxC
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_Proveedores` | 343 | Tabla unificada clientes + proveedores (campo `Tipo char(1)`) |
| `Tbl_grupo_cliente` | 6 | Grupos de clientes |
| `Tbl_Ente_facturador` | 4 | Entes facturadores (para FEL) |
| `Tbl_cuentas_por_cobrar` | 5 | Cuentas por cobrar |
| `Tbl_Contabiliza_Cuentas_por_cobrar` | 0 | Contabilización de CxC |
| `Tbl_cuentas_por_cobrar_integracion_plantilla` | 0 | Plantillas de CxC |
| `Tbl_cuentas_por_cobrar_retencion_iva` | 0 | Retención IVA en CxC |
| `Tbl_anticipos_clientes` | 6 | Anticipos de clientes |
| `Tbl_anticipos_clientes_forma_cobro` | 5 | Forma de cobro de anticipos |
| `Tbl_detalle_anticipos_clientes` | 1 | Detalle de anticipos |
| `Tbl_contabiliza_anticipos_clientes` | 0 | Contabilización de anticipos |
| `Tbl_Abonos` | 11 | Abonos a facturas |
| `Tbl_Det_Abonos` | 13 | Detalle de abonos |
| `Tbl_contabiliza_abonos` | 0 | Contabilización de abonos |
| `Tbl_cobros` | 0 | Cobros generales |
| `Tbl_det_cobros` | 0 | Detalle de cobros |
| `Tbl_Cliente_plantilla` | 0 | Plantilla de facturación por cliente |
| `tbl_cliente_gasolina` | 0 | Clientes de gasolinera con saldo |
| `Tbl_cotizacion_clientes` | 0 | Cotizaciones a clientes |
| `Tbl_cotizacion_clientes_detalle` | 0 | Detalle de cotizaciones |

### Módulo CxP / Proveedores
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_Cargos` | 6 | Facturas de proveedores (cuentas por pagar) |
| `Tbl_Contabiliza_Cargos` | 24 | Contabilización de facturas de proveedor |
| `Tbl_contrasenas` | 10 | Contraseñas de pago (DTE/SAT Guatemala) |
| `Tbl_Proveedores_ctas` | 1 | Cuentas contables de proveedores |
| `Tbl_configuracion_agente_retenedor_iva` | 9 | Configuración de agentes de retención IVA |

### Módulo Despacho / Entrega
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_solicitud_despacho_cliente` | 0 | Solicitudes de despacho a clientes |
| `tbl_solicitud_Despacho_cliente_detalle` | 0 | Detalle de solicitudes |
| `tbl_cab_entrega_despacho` | 0 | Cabecera de entrega/despacho |
| `tbl_det_entrega_despacho` | 0 | Detalle de entrega |

### Módulo Proyectos / Presupuestos de construcción
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_Mproyecto` | 13 | Macro-proyectos |
| `Tbl_Proyecto` | 16 | Proyectos |
| `Tbl_Rubro_Proyecto` | 405 | Rubros de presupuesto de proyecto |
| `Tbl_SubRubro_Proyecto` | 0 | Sub-rubros |
| `Tbl_Log_Tbl_Proyecto_Estado` | 14 | Log de cambios de estado de proyecto |
| `Tbl_Orden_Compra_Proyecto` | 28 | Órdenes de compra de proyecto |
| `Tbl_Orden_Compra_Proyecto_Detalle` | 179 | Detalle de OC de proyecto |
| `Tbl_Log_Orden_Compra_Proyecto` | 23 | Log de OC de proyecto |
| `Tbl_Division` | 6 | Divisiones de la empresa |
| `Tbl_Rubro_Proyecto` | 405 | |
| `tbl_a` | 1 | Temporal de rubros (tabla sin nombre definitivo) |

### Módulo Producción
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_cabecera_orden_produccion` | 0 | Órdenes de producción |
| `Tbl_detalle_orden_produccion` | 0 | Detalle de orden de producción |
| `Tbl_produccion_diaria` | 0 | Registro de producción diaria |

### Módulo Restaurante
| Tabla | Registros | Descripción |
|---|---|---|
| `Tbl_mesero` | 0 | Meseros |
| `Tbl_comanda` | 0 | Comandas de mesas |
| `Tbl_comanda_detalle` | 0 | Detalle de comandas |
| `Tbl_Orden_Cocina` | 0 | Órdenes a cocina (con estados) |
| `Tbl_Flujo_Orden` | 0 | Flujo de estados de orden de cocina |
| `Tbl_Estado_Orden` | 4 | Catálogo de estados de orden |
| `Recetas` | 1486 | Recetas de productos (sin IDENTITY) |
| `Recetas2` | 1486 | Copia de Recetas |
| `tbl_Recetas` | 1483 | Otra copia con IDENTITY |
| `tbl_xx` | 1462 | Tabla temporal de sub-productos con descripción |
| `Tbl_SProductos` | 1560 | Sub-productos de recetas |
| `TBL_ZONA_CALIDA` | 15 | Zonas de servicio (restaurante) |

### Módulo Gasolinera
| Tabla | Descripción |
|---|---|
| `tbl_cliente_gasolina` | Clientes con saldo de vales |

### Módulo Autenticación / Seguridad (ASP.NET Identity)
| Tabla | Registros | Descripción |
|---|---|---|
| `AspNetUsers` | 4 | Usuarios del sistema web nuevo |
| `AspNetRoles` | 3 | Roles |
| `AspNetUserRoles` | 4 | Asignación usuario-rol |
| `AspNetRoleClaims` | 0 | Claims de roles |
| `AspNetUserClaims` | 0 | Claims de usuarios |
| `AspNetUserLogins` | 0 | Logins externos |
| `AspNetUserTokens` | 0 | Tokens |
| `Tbl_Info_Usuario` | 4 | Datos extendidos del usuario (Nombre, Apellidos, Direccion, User_ID FK→AspNetUsers, Clave_Vencida, Estado) |
| `TblOpcion` | 39 | Opciones de menú del sistema web |
| `TblRolOpcion` | 39 | Asignación opción-rol |
| `SYS_SECURITY` | 0 | Tabla legacy de seguridad (solo un campo ID_MODULO) |

### Tablas de sistema / temporal
| Tabla | Descripción |
|---|---|
| `dtproperties` | Propiedades del diagrama de BD |
| `sysdiagrams` | Diagramas guardados en SSMS |
| `MENPRV`, `PRVMENT`, `provsm` | Importaciones temporales de proveedores (nvarchar/float) |
| `tbl_dt`, `tbl_p`, `tbl_bk_*` | Temporales y backups |
| `tempsprod`, `tempprod` | Temporales de productos |
| `tmp_ventas_mes` | Temporal de ventas mensuales |

---

## C. Diferencias importantes en campos clave

### Cliente → Tbl_Proveedores (HALLAZGO CRÍTICO)
La tabla `Cliente` documentada NO existe. Los clientes **y** proveedores comparten `Tbl_Proveedores`. La misma tabla sirve para ambos (campo `Tipo char(1)`).

Campos presentes en la real que NO estaban documentados:
- `Tipo char(1)` — distingue cliente de proveedor
- `Local_Extranjero`, `Colonia`, `Apto`, `zona`, `ciudad`, `Num_Casa`
- `Tipo_Iva`, `Id_Cuenta_cxp`, `clasificacion`, `Paga_iva`
- `Limite_credito_cliente`, `Es_agente_retenedor_iva`, `Tiene_exencion_iva`
- `Tipo_agente_retenedor_iva`, `Porcentaje_agente_retendor_iva`
- `Id_grupo_cliente`, `Tipo_politica_credito`, `regimen_contribyente`, `beneficiario`

Campos documentados que NO existen en la real:
- `id_cliente` (IDENTITY int) — en la real la PK es (`Id_Empresa`, `Nit`)
- `estado` (activo/inactivo) — no existe en `Tbl_Proveedores`

### Vehículo → Tbl_Vehiculos
- En la real: sin FKs a catálogos — `Color`, `Tipo`, `Marca`, `Linea` son texto libre `char`
- Sin campo `id_vehiculo` IDENTITY — PK es (`Id_Empresa`, `Num_Placa`)
- Sin `motor_de`, `presion_llantas` como int separado (existe como `Presion_Llantas int`)
- Campo `motor_de` no existe en la real

### Tbl_Orden_Servicio vs documentado
- Documentado tenía `id_empleado_recibe` — en la real es `Recibe_Orden char(4)` + `Encargado char(4)` (dos personas)
- La real tiene `Anticipo numeric(18,2)` (anticipo cobrado al inicio)
- La factura no es un `numero` int libre — son 4 campos: `Autorizacion`, `Serie`, `tipo`, `Numero`
- Sin campo `id_empresa` separado de la PK — PK es (`Id_Empresa`, `Id_Orden`)

### Empresa → empresas
La real tiene 42 campos vs 7 documentados. Campos clave no documentados:
- Múltiples cuentas contables (`id_cuenta_efectivo`, `id_cuenta_banco`, `id_cuenta_credito`, etc.)
- `Porcentaje_iva`, `Porcentaje_Iva_Anterior`, `apartirde` — para cálculo de IVA histórico
- `Factura_con char(10)` — módulo con el que factura ('POS', 'CXC', etc.)
- `Usa_orden_despacho`, `Facturacion_multibodega` — features activas
- `Agente_Retenedor_IVA`, `Regimen_Fiscal_isr` — régimen fiscal Guatemala
- `CorrelativoComanda int` — para módulo restaurante
- `Número_Orden_Compra varchar(15)` — correlativo de OC para proyectos

---

## D. Stored Procedures del módulo taller

### SPs/funciones del taller automotriz

| SP/Función | Descripción |
|---|---|
| `co_ordenes_servicio @Id_Empresa int` | OLAP: devuelve OS facturadas con servicios, costos, utilidad, mecánico y marca del vehículo. Usado en cubo de análisis desde ADO. Solo incluye OS con `Tipo<>'' AND numero<>0` |
| `sp_genera_orden_servicio @Id_empresa, @Id_Presupuesto, @Id_orden` | Convierte `Tbl_Presupuesto_Orden_Servicio` → `Tbl_Orden_Servicio`. Copia solo ítems con `autorizado=1`. Usa cursor, tiene transacción explícita. Lee de `Tbl_Presupuesto_Orden_Servicio` (NOT `Tbl_presupuesto_servicio`) |
| `rpt_Orden_servicio @Id_Empresa, @Id_Orden, @tipo char(1)` | Imprime una OS individual. Hace JOIN a vehículo, cliente, servicios e insumos |
| `rpt_ordenes_trabajadas @Id_Empresa, fechas, mecánico` | Reporte de OS trabajadas en rango de fechas, filtrable por mecánico |
| `rpt_reporte_comisiones_mecanicos @Id_empresa, fechas, empleado` | Reporte de comisiones por mecánico. Suma `Valor_comision` y `Porcentaje_comision` de `Tbl_Orden_Servicio_Detalle` |
| `rpt_avisos @id_empresa, fechas` | Avisos de mantenimiento: OS próximas a vencer por `Proximo_Servicio` |
| `rpt_vehiculos @Id_Empresa int` | Lista de vehículos con datos de taller |
| `rpt_marcas @Id_Empresa int` | Lista de marcas |
| `rpt_colores @Id_Empresa int` | Lista de colores |
| `rpt_series @Id_empresa int` | Lista de series de facturación |
| `rpt_presupuesto_new @Id_empresa, @Id_presupuesto` | Imprime presupuesto (versión nueva) |
| `rpt_comisiones_facturacion @Id_empresa, fechas` | Comisiones de facturas (módulo POS, no solo taller) |
| `rpt_costo_ventas_servicios_detallado @Id_Empresa, fechas` | Costo vs venta de servicios (OS) |
| `rpt_costo_ventas_servicios_detallado_producto @Id_Empresa, fechas` | Similar, agrupado por producto |
| `rpt_Integracion_Insumos @Id_Empresa, fechas` | Insumos integrados a OS en el período |
| `rpt_resumen_servicios_facturados @Id_Empresa, fechas` | Resumen de servicios facturados |
| `rpt_detalle_orden_servicio_cliente @Id_empresa, @nit` | OS pendientes de facturar para un cliente (Numero=0 AND serie='' AND tipo='') |
| `rpt_estadistica_ventas @Id_empresa` | Estadística de ventas: cruza OS e insumos con clientes y artículos |
| `sp_lista_vendedores @Id_empresa int` | Lista vendedores/mecánicos |

### SPs del módulo taller NO documentados previamente

Los siguientes SPs estaban en el sistema pero no en la documentación:
- `sp_actualiza_orden` — en realidad actualiza `Tbl_solicitud_despacho_cliente`, no una OS de taller (nombre confuso)
- `co_catalogo_productos` — OLAP de catálogo de productos
- `rpt_productos_no_facturados @Id_empresa` — productos de OS pendientes de facturar

---

## E. Autenticación y seguridad

### Dos sistemas en paralelo

**Sistema legacy VFP**: No usa `AspNetUsers`. La autenticación es via credenciales hardcodeadas o tabla `SYS_SECURITY` (vacía). Conexión: `SQLCONNECT("inventarios","sa","")`.

**Sistema nuevo (ASP.NET Core web)**: Usa ASP.NET Identity completo:
- `AspNetUsers` (4 usuarios activos)
- `AspNetRoles` (3 roles definidos)
- `AspNetUserRoles` (asignación de roles)
- `Tbl_Info_Usuario` — datos adicionales vinculados vía `User_ID FK→AspNetUsers.Id`. Campos: `Nombre`, `Apellidos`, `Direccion`, `Clave_Vencida bit`, `Estado bit`
- `TblOpcion` (39 opciones de menú con `Controlador`, `Accion`, `NombreArchivos`, `ValorRuta`, `MenuIndex`)
- `TblRolOpcion` (39 asignaciones opción-rol)

El sistema de permisos nuevo es **rol-based por opción de menú**, no por campo individual como el sistema VFP.

---

## F. Estado de la migración a Entity Framework

### `__EFMigrationsHistory` — 23 migraciones

El sistema web en ASP.NET Core ya tiene 23 migraciones aplicadas. Esto significa que una parte significativa del nuevo sistema ya está en producción en esta BD.

Las tablas que tienen estructura EF son identificables por:
- Uso de `nvarchar(450)` para PKs (patrón AspNetUsers)
- Tipos `nvarchar(MAX)` en campos de texto libre
- Campos `ConcurrencyStamp`, `NormalizedName` (patrón Identity)
- Tablas: `AspNetUsers`, `AspNetRoles`, `AspNetUserRoles`, `Tbl_Info_Usuario`, `TblOpcion`, `TblRolOpcion`, `Tbl_Conf_Empresa`, `Tbl_Configuracion`, `TblFacturaTCProcesamientos`, `Tbl_Orden_Cocina`, `Tbl_Flujo_Orden`, `Tbl_Estado_Orden`

**Implicación para la migración**: El proyecto web nuevo ya existe y está conectado a esta misma BD. Las migraciones EF conviven con las tablas legacy del sistema VFP. Al diseñar el nuevo sistema de taller, debe usarse EF Migrations y seguir los patrones ya establecidos en esta BD.

---

## G. Observaciones adicionales importantes

### Inconsistencia en tipos de datos entre documentado y real
- `Id_Empleado` en `Tbl_Vendedores` es `char(10)` pero en `Tbl_Orden_Servicio_Detalle` es `char(4)` — truncamiento real
- `Id_Bodega` es `char(10)` en toda la BD real, no `int` como documentado
- `Id_Producto` es `char(15)` en toda la BD real, no `int` como documentado
- Los IDs de vehículo, marca, linea son `char(10)` o texto libre, no numéricos

### Tabla `Tbl_Proveedores` como tabla maestra de personas
La FK en `Tbl_Vehiculos.nit → Tbl_Proveedores.Nit` confirma que los clientes (propietarios de vehículos) son registros en `Tbl_Proveedores`. Lo mismo para `Tbl_Presupuesto_Orden_Servicio.Nit` y `Tbl_Orden_Servicio.Nit`.

### Campo `descripcón` con tilde en `Tbl_presupuesto_servicio_detalle`
El campo se llama `[descripción]` (con tilde) — issue de encoding/collation que puede causar problemas en ORM y código.

### Tablas `Recetas`, `Recetas2`, `tbl_Recetas`, `tbl_xx`
Duplicados de la tabla de sub-productos/ingredientes para restaurante. Las tres existen sin relación de FK entre sí. Solo `tbl_Recetas` tiene IDENTITY. Probablemente resultado de migraciones manuales sucesivas.
