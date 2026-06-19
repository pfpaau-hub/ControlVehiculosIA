# ControlVehiculosIA — Claude Code Context

Sistema de gestión de taller automotriz en Visual FoxPro + SQL Server, actualmente en producción.
Objetivo: recrear toda la lógica en tecnologías modernas.

**Todo el contexto detallado vive en `.ia-context/` — leer `INDEX.md` primero.**

---

## Contexto rápido

- **Flujo:** Cliente → Vehículo → Presupuesto → Orden de Servicio → Facturación → Reportes
- **40 formularios**, **17 tablas SQL Server**, **30+ stored procedures**, **9 reportes Crystal Reports**
- **Variables de sesión clave:** `nEmpresa`, `cPeriodo`, `ncaja`
- **Punto de entrada VFP:** `Source/appmain.prg`
- **Backup de BD:** `DATABASE/db_Control_AutomotrizIA`

## Dónde encontrar cada cosa

| Necesito saber... | Leer... |
|---|---|
| Qué es el sistema y cómo funciona | `.ia-context/memory/project-overview.md` |
| Reglas de negocio por módulo | `.ia-context/memory/business-rules.md` |
| Variables de sesión y privilegios | `.ia-context/memory/session-model.md` |
| Bugs y deuda técnica conocida | `.ia-context/memory/technical-debt.md` |
| Tablas y modelo de datos | `.ia-context/architecture/data-model.md` |
| Módulos y responsabilidades | `.ia-context/architecture/modules.md` |
| Stored procedures y SQL directo | `.ia-context/architecture/stored-procedures.md` |
| Reportes y parámetros | `.ia-context/architecture/reports.md` |
| Integraciones externas | `.ia-context/architecture/integrations.md` |
| Por qué se tomó cada decisión | `.ia-context/decisions/` |
| Trabajo pendiente | `.ia-context/tasks/backlog.md` |
| Detalle de un formulario específico | `.ia-context/forms/<módulo>.md` |
