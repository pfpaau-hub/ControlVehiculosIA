# .ia-context — Índice de Contexto IA

Repositorio de contexto para asistencia inteligente en la recreación del sistema ControlVehiculosIA.
Cada carpeta es independiente y autosuficiente. Leer este índice primero.

---

## Estructura

```
.ia-context/
├── INDEX.md                        ← Estás aquí
│
├── memory/                         ← Qué es el sistema y cómo funciona
│   ├── project-overview.md         Sistema, stack, estado, carpetas
│   ├── business-rules.md           Reglas de negocio por módulo
│   ├── session-model.md            Variables globales, sesión, privilegios
│   └── technical-debt.md           Bugs conocidos, inconsistencias, deuda técnica
│
├── architecture/                   ← Cómo está construido
│   ├── data-model.md               Tablas, campos, tipos, relaciones (actualizado con schema real)
│   ├── real-schema-findings.md     Hallazgos del schema real extraído mayo 2024
│   ├── migration-validation.md     Validación de migración — gaps, riesgos, semáforo por módulo
│   ├── reconstructed-logic.md      ← NUEVO: SPs y triggers faltantes reconstruidos desde DDL
│   ├── modules.md                  Módulos del sistema y responsabilidades
│   ├── stored-procedures.md        SPs y SQL directo con parámetros
│   ├── reports.md                  Reportes, parámetros y herramienta
│   └── integrations.md             Conexiones externas, OLAP, Crystal Reports
│
├── decisions/                      ← Por qué se decidió cada cosa (ADR)
│   ├── ADR-001-migration-goal.md   Objetivo de la migración
│   ├── ADR-002-budget-systems.md   Dos sistemas de presupuestos paralelos
│   ├── ADR-003-bugs-to-fix.md      Bugs a corregir durante la recreación
│   ├── ADR-004-tech-stack.md       Stack: ASP.NET Core + React + SQL Server
│   └── ADR-005-surrogate-keys.md   Llaves compuestas → surrogate IDENTITY + UNIQUE constraint
│
├── tasks/                          ← Trabajo pendiente y completado
│   ├── backlog.md                  Todo el trabajo por hacer
│   ├── in-progress.md              Trabajo en curso
│   └── done.md                     Trabajo completado
│
└── forms/                          ← Detalle de cada formulario VFP
    ├── README.md                   Resumen de los 40 formularios
    ├── clientes.md                 frm_clientes + frm_clientes_children
    ├── vehiculos.md                frm_vehiculos + historial
    ├── ordenes-servicio.md         frm_orden_servicios (formulario central)
    ├── presupuestos.md             frm_presupuestos_new + conversión a OS
    ├── catalogos.md                Marcas, tipos, colores, vendedores, etc.
    ├── configuracion.md            Empresas, series, cajas, cajeros
    └── reportes.md                 Todos los formularios de reporte
```

---

## Cómo usar este contexto

1. **Inicio de sesión nueva** → Leer `INDEX.md` + `memory/project-overview.md`
2. **Trabajar en un módulo** → Leer el archivo correspondiente en `forms/`
3. **Diseñar la nueva arquitectura** → Leer `architecture/data-model.md` + `architecture/modules.md`
4. **Antes de tomar decisiones** → Revisar `decisions/` para no repetir decisiones ya tomadas
5. **Ver qué falta hacer** → `tasks/backlog.md`

---

## Estado actual (2026-06-18)
> **VALIDACIÓN DE MIGRACIÓN COMPLETADA** — Schema real analizado, gaps identificados, riesgos priorizados.
> Se encontraron 153 tablas (vs 17 documentadas). Sistema multimódulo.
> El proyecto web ASP.NET Core ya existe con 23 migraciones EF aplicadas.

| Fase | Estado |
|------|--------|
| Análisis del sistema VFP original | ✅ Completo |
| Stack tecnológico definido | ✅ C# + ASP.NET Core + React + SQL Server |
| Checklist de extracción | ✅ Enviado al equipo |
| Recepción de archivos `extracted/` | ✅ Recibidos en `extracted/inventario/` |
| Análisis del schema real | ✅ Completado — ver `architecture/real-schema-findings.md` |
| Validación de migración | ✅ Completado — ver `architecture/migration-validation.md` |
| Diseño del nuevo sistema (Fase 1) | ⏳ Pendiente de resolución de gaps críticos |

---

## Contexto rápido (resumen en 5 líneas)

Sistema de gestión de taller automotriz en **Visual FoxPro + SQL Server**, actualmente en producción.
Flujo: `Cliente → Vehículo → Presupuesto → Orden de Servicio → Facturación → Reportes`.
**40 formularios**, **17 tablas SQL Server**, **30+ stored procedures**, **9 reportes Crystal Reports**.
Objetivo: recrear toda la lógica en tecnologías modernas, corrigiendo bugs y vulnerabilidades conocidas.
Variables de sesión clave: `nEmpresa`, `cPeriodo`, `ncaja`.
