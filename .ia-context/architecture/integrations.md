# Arquitectura — Integraciones y Dependencias Externas

## Sistema de inventarios (externo)
El módulo de existencias consulta una base de datos separada llamada `inventarios` / `db_inventario_pfp`.

**Conexión:**
- DSN ODBC: `"inventarios"`
- Usuario: `sa` (administrador SQL Server — hardcoded)
- Contraseña: vacía (hardcoded)
- Nombre BD: `db_inventario_pfp`

**Qué consume del sistema de inventarios:**
- Existencias de productos por bodega (lectura)
- Lista de productos con `es_servicio=0` (repuestos)
- Lista de bodegas
- Registro de insumos usados en órdenes (`ordenes_servicio_integracion`)

**Impacto en la recreación:**
- El nuevo sistema debe definir si inventarios es parte del mismo sistema o una API externa
- Si es externo: implementar una capa de integración (API REST, microservicio)
- Si es interno: unificar en la misma base de datos

## Sistema de facturación (externo)
La facturación es un módulo externo al sistema VFP actual. El sistema solo conoce el resultado:
- `tbl_orden_servicio.numero > 0` → número de factura asignado
- `tbl_orden_servicio.fecha_facturacion SET` → fecha en que se facturó

**No hay código VFP de facturación visible en este sistema.**

## Crystal Reports v9
Herramienta de reportes propietaria de SAP.
- Archivos `.rpt` guardados en `_screen.cReportes` (ruta configurable al inicio)
- 10 archivos .rpt en total
- **No tiene API moderna / no es portable directamente**

## Control OLAP ContourCubeLite
Control OLE propietario para análisis multidimensional.
- Usado en `frm_consulta_servicios`
- Conexión ADO directa al SQL Server
- **No tiene equivalente directo en tecnologías web**

## Registro de Windows (Registry)
El framework CodeMine usa el registro de Windows para:
- Almacenar preferencias de la aplicación
- Guardar configuración de ambiente
- Ruta: `Software\PFP\Facturacion\1.0`
- En nuevo sistema: reemplazar con configuración en BD o archivo de configuración

## Framework CodeMine
Librería VFP de terceros (`common50/codemine`) que provee:
- Clase base `appApplication` (ciclo de vida de la app)
- Sistema de `goStateManager` (gestión de estado de formularios)
- Sistema de privilegios/seguridad
- Gestión de formularios modales y no modales
- Sistema de navegación (Primero/Anterior/Siguiente/Último)
- Integración con el menú del sistema

**En el nuevo sistema:** Reemplazar con el framework frontend elegido (React, Vue, Angular, etc.)

## ODBC
La conexión se hace vía DSN ODBC del sistema operativo:
- DSN Name: `"inventarios"`
- Tipo: SQL Server
- **En nuevo sistema:** Connection string directa o ORM, sin dependencia de DSN del SO
