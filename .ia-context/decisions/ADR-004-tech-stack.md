# ADR-004 — Stack Tecnológico del Nuevo Sistema

**Estado:** Aceptado
**Fecha:** 2026-06-17

## Contexto
El equipo tiene experiencia en tecnologías Microsoft. El sistema original es VFP + SQL Server.
Se busca modernizar minimizando la curva de aprendizaje y aprovechando conocimiento existente.

## Decisión — Stack seleccionado

| Capa | Tecnología | Versión objetivo |
|------|-----------|-----------------|
| Backend | C# + ASP.NET Core Web API | .NET 8 LTS |
| Frontend | React + TypeScript | React 18+ |
| Base de datos | SQL Server | Mantener versión actual |
| ORM | Entity Framework Core | EF Core 8 |
| Query complejas | Dapper | Junto a EF Core |
| Autenticación | ASP.NET Core Identity + JWT | |
| Reportes PDF | FastReport.NET o RDLC | Reemplaza Crystal Reports |
| Documentación API | Swagger / OpenAPI | Integrado en ASP.NET Core |
| Despliegue | IIS o Azure App Service | |

## Por qué este stack

**C# + ASP.NET Core:**
- Ecosistema Microsoft — equipo ya conoce patrones y herramientas
- Tipado fuerte: natural para un sistema con muchas reglas de negocio explícitas
- Entity Framework Core tiene `HasQueryFilter` para el filtro multi-empresa global (`id_empresa`)
- Excelente integración nativa con SQL Server (driver Microsoft oficial)

**SQL Server (mantener):**
- Cero migración de datos — misma BD, mismo motor
- Los stored procedures actuales se pueden reutilizar durante la transición
- El equipo ya lo administra y conoce
- Las licencias ya existen

**React + TypeScript:**
- Más ecosistema y comunidad que Blazor para componentes de UI
- TypeScript añade seguridad de tipos — coherente con C# en el backend
- Alternativa si el equipo prefiere mantenerse 100% Microsoft: **Blazor Server** (C# en el frontend también)

**FastReport.NET / RDLC:**
- Reemplaza Crystal Reports v9
- Ecosistema Microsoft / .NET
- RDLC es el formato de Microsoft Report — familiar para equipos .NET
- FastReport tiene mayor flexibilidad de diseño

## Ventaja de migración gradual
Mantener SQL Server permite una estrategia de migración por fases:
1. Crear la nueva API en ASP.NET Core apuntando a la **misma BD SQL Server**
2. Correr ambos sistemas en paralelo (VFP + nuevo) durante la transición
3. Migrar módulo por módulo sin cortar el sistema original
4. Aplicar correcciones de BUG-001 a BUG-004 en el nuevo esquema sin afectar el VFP

## Estructura de solución recomendada

```
ControlVehiculosIA.sln
├── src/
│   ├── ControlVehiculos.API/          ASP.NET Core Web API
│   │   ├── Controllers/               Un controller por módulo
│   │   ├── Middleware/                Auth, manejo de errores, empresa-context
│   │   └── Program.cs
│   │
│   ├── ControlVehiculos.Application/  Lógica de negocio (CQRS o Services)
│   │   ├── Clientes/
│   │   ├── Vehiculos/
│   │   ├── Presupuestos/
│   │   ├── OrdenesServicio/
│   │   └── Reportes/
│   │
│   ├── ControlVehiculos.Domain/       Entidades y reglas de dominio
│   │   ├── Entities/
│   │   └── Enums/
│   │
│   └── ControlVehiculos.Infrastructure/  EF Core, repositorios, SQL Server
│       ├── Data/
│       │   ├── AppDbContext.cs
│       │   └── Migrations/
│       └── Repositories/
│
└── frontend/                          React + TypeScript
    ├── src/
    │   ├── modules/                   Un folder por módulo
    │   │   ├── clientes/
    │   │   ├── vehiculos/
    │   │   ├── presupuestos/
    │   │   └── ordenes-servicio/
    │   ├── components/                Componentes reutilizables
    │   └── services/                  Llamadas a la API
    └── package.json
```

## Mapeo VFP → .NET

| Concepto VFP | Equivalente .NET |
|-------------|-----------------|
| Variables globales `nEmpresa`, `cPeriodo` | JWT claims + middleware de contexto |
| `goStateManager` (CodeMine) | React Context / Zustand |
| Privilegios por campo | ASP.NET Core Policies + atributos `[Authorize]` |
| `SQLEXEC()` inline | EF Core LINQ o Dapper |
| `SQLCONNECT("inventarios","sa","")` | Connection string en `appsettings.json` + secrets |
| Crystal Reports `.rpt` | FastReport `.frx` o RDLC `.rdlc` |
| Tablas DBF locales | Eliminadas — todo en SQL Server |
| `frm_pantalla_busqueda` genérico | Componente React reutilizable con props configurables |
| ContourCubeLite OLAP | AG Grid con pivot, o SQL Server Reporting Services |
