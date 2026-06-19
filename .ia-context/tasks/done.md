# Tasks — Completado

---

## 2026-06-17 — Definición del stack tecnológico
- [x] Equipo con experiencia Microsoft → Stack definido: C# + ASP.NET Core + React + TypeScript + SQL Server
- [x] ADR-004 creado con estructura de solución recomendada y mapeo VFP → .NET
- [x] Backlog Fase 0 marcado como completado
- [x] Skill.md actualizado con stack definido

## 2026-06-17 — Checklist de migración completa
- [x] Identificar qué se necesita para migración 100% confiable
- [x] Crear `tasks/migration-checklist.md` con comandos exactos de extracción (5 bloques)
- [x] Información solicitada al equipo — en espera de recibir archivos `extracted/`

## 2026-06-17 — Análisis y documentación del sistema original

### Exploración inicial
- [x] Identificar estructura de carpetas y archivos del proyecto VFP
- [x] Extraer lista de los 40 formularios (.scx)
- [x] Leer programa principal (appmain.prg, appdefs.h, config.fpw)
- [x] Leer menú del sistema (APPMENU.MPR)

### Base de datos
- [x] Identificar el dump de SQL Server en DATABASE/
- [x] Extraer las 17 tablas del diagrama de BD
- [x] Extraer todos los stored procedures y sus parámetros
- [x] Extraer campos y tipos de datos de cada tabla
- [x] Identificar bugs en el dump (BUG-001 a BUG-004, INC-001 a INC-005)

### Formularios
- [x] Analizar los 40 formularios VFP extrayendo strings de los .SCT
- [x] Documentar campos, cursores y SPs de cada formulario
- [x] Identificar el patrón de comunicación VFP→SQL (SQLEXEC, no XML)
- [x] Identificar credenciales hardcoded (SEC-001, SEC-002)
- [x] Identificar los dos sistemas de presupuestos paralelos (ADR-002)

### Documentación creada
- [x] CLAUDE.md — documentación completa para Claude Code
- [x] .ia-context/INDEX.md — índice del sistema de contexto IA
- [x] .ia-context/memory/ — 4 archivos de memoria
- [x] .ia-context/architecture/ — 5 archivos de arquitectura
- [x] .ia-context/decisions/ — 3 ADRs
- [x] .ia-context/tasks/ — backlog, in-progress, done
- [x] .ia-context/forms/ — detalle de formularios (pendiente)
- [x] Memoria persistente en ~/.claude/projects/.../memory/
