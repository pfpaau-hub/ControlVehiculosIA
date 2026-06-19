# Tasks — En Progreso

Trabajo actualmente en curso.

---

## ✅ COMPLETADO — Análisis del schema real (2026-06-18)

**Bloque 1 — SQL Server** — archivos recibidos en `extracted/inventario/`:
- [x] `extracted/inventario/01-tablas-columnas.csv`
- [x] `extracted/inventario/03-foreign-keys.csv`
- [x] `extracted/inventario/04-indices.csv`
- [x] `extracted/inventario/06-stored-procedures.sql`
- [x] `extracted/inventario/07-vistas.sql`
- [x] `extracted/inventario/08-triggers.sql`
- [x] `extracted/inventario/09-conteo-registros.csv`
- [x] `extracted/inventario/ddl-completo.sql`
- [x] `extracted/inventario/sp-nombres.txt`

**Análisis completado:**
- [x] Mapeo tablas documentadas → tablas reales (`architecture/data-model.md`)
- [x] Hallazgos del schema real (`architecture/real-schema-findings.md`)
- [x] Identificación de 153 tablas vs 17 documentadas
- [x] Confirmación de 23 migraciones EF (sistema web nuevo ya existe)
- [x] Análisis de SPs del módulo taller
- [x] Análisis del sistema de autenticación (ASP.NET Identity)

---

## ⏳ PENDIENTE — Bloque 2 y siguientes (aún no recibidos)

**Bloque 2 — VFP código exportado** (40 formularios + 3 librerías .vcx):
- [ ] `extracted/forms/*.prg` — 40 formularios exportados desde VFP IDE
- [ ] `extracted/classes/AppMain.prg`
- [ ] `extracted/classes/AppForms.prg`
- [ ] `extracted/classes/AppTools.prg`
- [ ] `extracted/classes/botones.prg`
- [ ] `extracted/dbf/dbf-schemas.txt`

**Bloque 3 — Crystal Reports queries**:
- [ ] SQL de cada uno de los 9 reportes .rpt

**Bloque 4 — SQL Profiler traces**:
- [ ] Trazas de cada flujo principal (cliente, vehículo, presupuesto, OS)

**Bloque 5 — Configuración del ambiente**:
- [ ] DSN ODBC, collation, versión SQL Server, nombre BD inventarios

---

## ⏳ PRÓXIMO PASO — Diseño Fase 1

Con el schema real analizado, se puede iniciar el diseño del nuevo sistema:
1. Definir el modelo de datos nuevo (EF Core) para el módulo taller
2. Decidir si separar `Tbl_Proveedores` en `Clientes` y `Proveedores` en el nuevo sistema
3. Decidir el manejo de catálogos de vehículos (con FKs normalizadas vs texto libre)
4. Diseñar las APIs para el flujo principal OS
5. Conectar con el sistema web que ya existe (23 migraciones EF en la misma BD)

---

*Mover tareas a este archivo cuando se inician, y a done.md cuando se completan.*
