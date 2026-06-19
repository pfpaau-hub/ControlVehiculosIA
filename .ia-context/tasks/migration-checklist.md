# Checklist de Extracción para Migración 100% Completa

Cada ítem tiene el comando exacto para obtenerlo.
Estado: [ ] pendiente / [x] obtenido / [!] no existe en este sistema

---

## BLOQUE 1 — SQL SERVER (ejecutar en el servidor de producción)

### 1.1 Schema completo de tablas
```sql
-- Todas las tablas con columnas, tipos, longitud, nulabilidad y defaults
SELECT
    t.name                          AS tabla,
    c.column_id                     AS orden,
    c.name                          AS columna,
    tp.name                         AS tipo,
    c.max_length,
    c.precision,
    c.scale,
    c.is_nullable,
    c.is_identity,
    c.is_computed,
    OBJECT_DEFINITION(c.default_object_id) AS valor_default
FROM sys.tables t
JOIN sys.columns c  ON t.object_id = c.object_id
JOIN sys.types tp   ON c.user_type_id = tp.user_type_id
ORDER BY t.name, c.column_id
```
- [ ] Resultado guardado en `extracted/sql/01-tablas-columnas.csv`

### 1.2 Primary Keys
```sql
SELECT
    t.name AS tabla,
    kc.name AS constraint_nombre,
    c.name AS columna,
    ic.key_ordinal
FROM sys.tables t
JOIN sys.indexes i          ON t.object_id = i.object_id AND i.is_primary_key = 1
JOIN sys.index_columns ic   ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c          ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.key_constraints kc ON i.object_id = kc.parent_object_id AND i.index_id = kc.unique_index_id
ORDER BY t.name, ic.key_ordinal
```
- [ ] Resultado guardado en `extracted/sql/02-primary-keys.csv`

### 1.3 Foreign Keys y relaciones
```sql
SELECT
    fk.name                                 AS fk_nombre,
    OBJECT_NAME(fk.parent_object_id)        AS tabla_origen,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id)   AS columna_origen,
    OBJECT_NAME(fk.referenced_object_id)    AS tabla_destino,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS columna_destino,
    fk.delete_referential_action_desc,
    fk.update_referential_action_desc
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
ORDER BY tabla_origen
```
- [ ] Resultado guardado en `extracted/sql/03-foreign-keys.csv`

### 1.4 Índices
```sql
SELECT
    t.name      AS tabla,
    i.name      AS indice,
    i.type_desc,
    i.is_unique,
    STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS columnas
FROM sys.tables t
JOIN sys.indexes i          ON t.object_id = i.object_id
JOIN sys.index_columns ic   ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c          ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.is_primary_key = 0
GROUP BY t.name, i.name, i.type_desc, i.is_unique
ORDER BY t.name, i.name
```
- [ ] Resultado guardado en `extracted/sql/04-indices.csv`

### 1.5 Check Constraints
```sql
SELECT
    t.name  AS tabla,
    cc.name AS constraint_nombre,
    cc.definition
FROM sys.tables t
JOIN sys.check_constraints cc ON t.object_id = cc.parent_object_id
ORDER BY t.name
```
- [ ] Resultado guardado en `extracted/sql/05-check-constraints.csv`

### 1.6 Stored Procedures — código completo
```sql
SELECT
    o.name,
    o.type_desc,
    OBJECT_DEFINITION(o.object_id) AS codigo
FROM sys.objects o
WHERE o.type IN ('P', 'FN', 'IF', 'TF')  -- SPs + funciones
ORDER BY o.name
```
- [ ] Resultado guardado en `extracted/sql/06-stored-procedures.sql`

### 1.7 Vistas — código completo
```sql
SELECT
    name,
    OBJECT_DEFINITION(object_id) AS codigo
FROM sys.objects
WHERE type = 'V'
ORDER BY name
```
- [ ] Resultado guardado en `extracted/sql/07-vistas.sql`

### 1.8 Triggers — código completo
```sql
SELECT
    t.name          AS tabla,
    tr.name         AS trigger_nombre,
    tr.is_disabled,
    OBJECT_DEFINITION(tr.object_id) AS codigo
FROM sys.triggers tr
JOIN sys.tables t ON tr.parent_id = t.object_id
ORDER BY t.name, tr.name
```
- [ ] Resultado guardado en `extracted/sql/08-triggers.sql`

### 1.9 Conteo de registros por tabla
```sql
SELECT
    t.name AS tabla,
    p.rows AS registros
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id AND p.index_id IN (0,1)
ORDER BY p.rows DESC
```
- [ ] Resultado guardado en `extracted/sql/09-conteo-registros.csv`

### 1.10 Usuarios y permisos de BD
```sql
SELECT
    dp.name         AS usuario,
    dp.type_desc,
    o.name          AS objeto,
    p.permission_name,
    p.state_desc
FROM sys.database_permissions p
JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
LEFT JOIN sys.objects o ON p.major_id = o.object_id
WHERE dp.name NOT IN ('public','guest','INFORMATION_SCHEMA','sys')
ORDER BY dp.name, o.name
```
- [ ] Resultado guardado en `extracted/sql/10-permisos.csv`

### 1.11 Script DDL completo (método alternativo más rápido)
Desde SQL Server Management Studio:
- Click derecho en la BD → Tasks → Generate Scripts
- Seleccionar: Tables, Views, Stored Procedures, Functions, Triggers, Indexes, Constraints
- Opciones avanzadas: Types of data to script = Schema only
- Guardar como un solo archivo

- [ ] Resultado guardado en `extracted/sql/ddl-completo.sql`

---

## BLOQUE 2 — VISUAL FOXPRO (ejecutar desde el IDE de VFP)

### 2.1 Exportar código de formularios (.SCX → texto)
Abrir VFP Command Window y ejecutar:
```foxpro
* Exportar TODOS los formularios a código fuente legible
LOCAL cPath, aFiles[1], i
cPath = 'C:\ruta\al\proyecto\Source\'

ADIR(aFiles, cPath + '*.scx')
FOR i = 1 TO ALEN(aFiles, 1)
    LOCAL cForm, cOutput
    cForm   = cPath + aFiles[i, 1]
    cOutput = STRTRAN(cForm, '.scx', '.prg')
    * Genera el .prg con todo el código de eventos
    COMPILE FORM (cForm)
    * Exportar a texto
    MODIFY FORM (cForm) NOWAIT
    KEYBOARD '{alt+f}{g}' + cOutput + '{enter}'
ENDFOR
```

Alternativa más confiable — desde VFP Command Window:
```foxpro
* Usar GenForms para exportar a texto
LOCAL cForm
cForm = 'Source\frm_orden_servicios.scx'
GENERATE cForm TYPE 'PRG' TO 'extracted\forms\frm_orden_servicios.prg'
```

O el método manual más seguro:
1. `MODIFY FORM Source\frm_orden_servicios.scx`
2. Menú Form → Generate
3. Guardar como `.prg`
4. Repetir para cada formulario

- [ ] 40 archivos .prg guardados en `extracted/forms/`

### 2.2 Exportar clases de AppMain.vcx
```foxpro
LOCAL oClass
SET CLASSLIB TO Source\AppMain.vcx
* Listar todas las clases
ACLASS(aClasses, 'appApplication')
* Exportar a texto
MODIFY CLASS appApplication OF Source\AppMain.vcx NOWAIT
* Menu: Class → Generate
```
- [ ] `extracted/classes/AppMain.prg`
- [ ] `extracted/classes/AppForms.prg`
- [ ] `extracted/classes/AppTools.prg`

### 2.3 Exportar clases de Data/botones.vcx
```foxpro
MODIFY CLASS * OF Data\botones.vcx
```
- [ ] `extracted/classes/botones.prg`

### 2.4 Exportar código del menú
```foxpro
* El .MPR ya es texto — copiar directamente
COPY FILE Source\APPMENU.MPR TO extracted\menu\APPMENU.prg
```
- [ ] Ya disponible: `Source/APPMENU.MPR` ✅

### 2.5 Exportar estructura de tablas DBF locales
```foxpro
* Para cada DBF en Data/
LOCAL cPath, aFiles[1], i
cPath = 'Data\'
ADIR(aFiles, cPath + '*.dbf')

CREATE TABLE extracted\dbf-schemas.txt FREE
FOR i = 1 TO ALEN(aFiles, 1)
    USE (cPath + aFiles[i,1])
    LIST STRUCTURE TO FILE 'extracted\dbf-schemas.txt' ADDITIVE
    USE
ENDFOR
```
- [ ] Resultado guardado en `extracted/dbf/dbf-schemas.txt`

### 2.6 Leer base de datos DBC local (AppData.dbc)
```foxpro
OPEN DATABASE Data\appdata.dbc
LIST TABLES
* Para cada tabla:
USE Data\AppReg01.dbf
LIST STRUCTURE TO FILE extracted\dbf\AppReg01-structure.txt
```
- [ ] `extracted/dbf/AppData-tables.txt`
- [ ] `extracted/dbf/AppReg01-structure.txt`
- [ ] `extracted/dbf/EVENTLOG-structure.txt`

### 2.7 Exportar reportes VFP (.FRX → texto)
```foxpro
* Los reportes tienen companion .FRT con el código
COPY FILE Data\rpt_comisiones_mecanicos.rpt TO extracted\reports\rpt_comisiones_mecanicos.rpt
* No hay reportes .frx en este proyecto — usa Crystal Reports
```
- [ ] Confirmar: ¿hay archivos .FRX en el proyecto? (no se encontraron en el análisis inicial)

### 2.8 Verificar si hay código en common50/codemine
```foxpro
* Listar archivos del framework CodeMine
ADIR(aFiles, '..\common50\*.*', 'F')
DISPLAY MEMORY LIKE aFiles
```
- [ ] `extracted/framework/codemine-files.txt` — para saber qué hace el framework que no vemos

---

## BLOQUE 3 — CRYSTAL REPORTS (abrir cada .rpt en Crystal Reports)

Para cada archivo `.rpt` en el sistema:
1. Abrir en Crystal Reports Designer
2. File → Export → Export Report
3. Formato: RPT XML (o Text)
4. Guardar en `extracted/reports/`

También exportar las queries SQL que usa cada reporte:
1. Abrir el reporte
2. Database → Show SQL Query
3. Copiar y guardar

- [ ] `extracted/reports/rpt_servicios-query.sql`
- [ ] `extracted/reports/rpt_presupuesto_new-query.sql`
- [ ] `extracted/reports/rpt_presupuesto_por_autorizar-query.sql`
- [ ] `extracted/reports/rpt_historial_facturas-query.sql`
- [ ] `extracted/reports/rpt_ordenes_trabajadas-query.sql`
- [ ] `extracted/reports/rpt_avisos-query.sql`
- [ ] `extracted/reports/rpt_comisiones_mecanicos-query.sql`
- [ ] `extracted/reports/productos_ordenados_nofacturados-query.sql`
- [ ] `extracted/reports/rpt_presupuestos-query.sql` (versión antigua)

---

## BLOQUE 4 — SISTEMA EN EJECUCIÓN (observación funcional)

### 4.1 Recorrer el flujo completo con datos reales
Con el sistema VFP corriendo, documentar:
- [ ] Crear un cliente nuevo → anotar validaciones que aparecen
- [ ] Crear un vehículo → anotar validaciones y comportamientos del combo marca/línea
- [ ] Crear un presupuesto → agregar ítems, autorizar, cerrar
- [ ] Convertir presupuesto a OS → anotar qué valida el sistema
- [ ] Agregar servicios e insumos a la OS
- [ ] Cerrar la OS → anotar validaciones
- [ ] Intentar revertir cierre → anotar condiciones exactas
- [ ] Ejecutar cada reporte con datos reales → guardar PDF de ejemplo

### 4.2 Capturar SQL real enviado a SQL Server
Usar SQL Server Profiler mientras se opera el sistema VFP:
1. SQL Server Management Studio → Tools → SQL Server Profiler
2. Conectar al servidor
3. Operar el sistema VFP normalmente
4. Capturar todos los eventos `SQL:BatchCompleted` y `RPC:Completed`
5. Guardar la traza

- [ ] `extracted/traces/trace-cliente-crud.trc`
- [ ] `extracted/traces/trace-vehiculo-crud.trc`
- [ ] `extracted/traces/trace-presupuesto-crud.trc`
- [ ] `extracted/traces/trace-orden-servicio-crud.trc`
- [ ] `extracted/traces/trace-cierre-orden.trc`
- [ ] `extracted/traces/trace-reversion-orden.trc`

### 4.3 Capturar datos de muestra por tabla
```sql
-- Para cada tabla importante, exportar 10-50 filas de ejemplo
SELECT TOP 20 * FROM Cliente
SELECT TOP 20 * FROM Vehiculo
SELECT TOP 20 * FROM tbl_orden_servicio
SELECT TOP 20 * FROM detalle_servicios
SELECT TOP 20 * FROM ordenes_servicio_integracion
SELECT TOP 20 * FROM tbl_presupuesto_servicio
SELECT TOP 20 * FROM tbl_presupuesto_servicio_detalle
```
- [ ] `extracted/data-samples/muestra-por-tabla.xlsx`

---

## BLOQUE 5 — CONFIGURACIÓN Y AMBIENTE

### 5.1 Configuración del DSN ODBC
En el servidor Windows donde corre VFP:
- Panel de control → Herramientas administrativas → ODBC Data Sources
- Anotar la configuración exacta del DSN "inventarios":
  - Servidor SQL Server
  - Nombre de BD
  - Método de autenticación

- [ ] `extracted/config/odbc-inventarios.txt`

### 5.2 Versión de SQL Server
```sql
SELECT @@VERSION
SELECT SERVERPROPERTY('ProductVersion'), SERVERPROPERTY('Edition')
```
- [ ] Confirmada: SQL Server ____

### 5.3 Collation de la BD
```sql
SELECT DATABASEPROPERTYEX('db_Control_AutomotrizIA', 'Collation')
```
- [ ] Confirmada: Collation ____

### 5.4 Nombre exacto de la base de datos de inventarios
```sql
SELECT name FROM sys.databases ORDER BY name
```
- [ ] Confirmar si `db_inventario_pfp` es el nombre real

### 5.5 Usuarios de la aplicación en SQL Server
```sql
SELECT name, type_desc, default_schema_name
FROM sys.database_principals
WHERE type IN ('S','U') AND name NOT IN ('dbo','guest','sys','INFORMATION_SCHEMA')
```
- [ ] `extracted/config/usuarios-sql.csv`

---

## RESUMEN — Qué garantiza cada bloque

| Bloque | Garantiza |
|--------|-----------|
| 1 — SQL Server schema | Modelo de datos 100% fiel — sin columnas ocultas ni constraints perdidos |
| 2 — VFP código exportado | Lógica de UI, validaciones campo a campo, cálculos de totales, eventos completos |
| 3 — Crystal Reports queries | SQL exacto que usa cada reporte — reproduce datos idénticos |
| 4 — SQL Profiler traces | Qué SQL real ejecuta el sistema — detecta lógica oculta no documentada |
| 4 — Flujo funcional | Valida reglas de negocio que no están en el código (conocimiento del usuario) |
| 5 — Configuración | Reproduce el ambiente exacto — sin sorpresas de collation, conexión, permisos |

Con estos 5 bloques completos: **migración 100% documentada y verificable.**
