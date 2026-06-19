# Guía de desarrollo — Windows

## Prerrequisitos

| Herramienta | Versión mínima | Descarga |
|---|---|---|
| Docker Desktop | 4.x | https://www.docker.com/products/docker-desktop |
| .NET SDK | 10.0 | https://dotnet.microsoft.com/download |
| Node.js | 20 LTS | https://nodejs.org |
| dotnet-ef (global) | 10.0 | `dotnet tool install -g dotnet-ef` |

> **Editor recomendado:** Visual Studio 2022 Community o VS Code con extensiones C# Dev Kit + ESLint + Prettier.

---

## Primera vez en esta máquina

Abrir una terminal PowerShell en la raíz del proyecto y ejecutar:

```powershell
.\scripts\setup-dev.ps1
```

El script hace todo automáticamente: levanta SQL Server en Docker, aplica las migraciones y verifica las dependencias del frontend.

---

## Inicio rápido (sesiones siguientes)

### 1. Levantar SQL Server

```powershell
docker compose up -d
```

> Los datos persisten en el volumen Docker `sqlserver_data` aunque apagues la máquina.
> Para detener sin borrar datos: `docker compose stop`

### 2. Backend

Abrir una terminal en la raíz del proyecto:

```powershell
$env:ASPNETCORE_ENVIRONMENT = "Development"
$env:ASPNETCORE_URLS        = "http://localhost:5000"
dotnet run --project src\ControlVehiculos.API\ControlVehiculos.API.csproj --no-launch-profile
```

El backend queda en `http://localhost:5000`  
Swagger disponible en `http://localhost:5000/swagger`

### 3. Frontend

Abrir una segunda terminal:

```powershell
cd frontend
npm run dev
```

La app queda en `http://localhost:5173`

---

## Credenciales

| Recurso | Usuario | Contraseña |
|---|---|---|
| App web (admin) | `admin` | `Admin123!` |
| SQL Server (sa) | `sa` | `Dev_CtrlV3h1!` |
| Base de datos | `db_ControlVehiculos` | — |

> ⚠️ Estas contraseñas son **solo para desarrollo local**. En producción se usan variables de entorno / secrets manager.

---

## Estructura del proyecto

```
ControlVehiculosIA-main/
├── docker-compose.yml              ← SQL Server 2022
├── scripts/
│   ├── setup-dev.ps1               ← Setup automático Windows
│   ├── 01-prod-schema-deploy.sql   ← Migración para BD de producción existente
│   └── 02-validate-migration.sql   ← Validación post-migración
├── src/
│   ├── ControlVehiculos.API/       ← ASP.NET Core Web API (.NET 10)
│   ├── ControlVehiculos.Application/
│   ├── ControlVehiculos.Infrastructure/  ← EF Core, entidades, migraciones
│   └── ControlVehiculos.Tests/     ← 17 integration tests (xUnit)
├── frontend/                       ← React + TypeScript + Vite + Ant Design
│   └── src/
│       ├── api/                    ← Clientes HTTP por módulo
│       ├── modules/                ← Páginas (ordenes, clientes, vehiculos...)
│       └── store/                  ← Zustand (auth)
└── .ia-context/                    ← Documentación del sistema VFP original
    ├── INDEX.md
    ├── architecture/
    ├── forms/
    ├── memory/
    └── tasks/backlog.md
```

---

## Comandos útiles

```powershell
# Correr los 17 integration tests
dotnet test src\ControlVehiculos.Tests\ControlVehiculos.Tests.csproj

# Agregar una nueva migración EF Core
$env:ASPNETCORE_ENVIRONMENT = "Development"
dotnet ef migrations add NombreMigracion `
  --project src\ControlVehiculos.Infrastructure `
  --startup-project src\ControlVehiculos.API

# Ver logs de SQL Server
docker logs ctrl_vehiculos_sql --tail 50

# Conectarse a SQL Server con sqlcmd
docker exec -it ctrl_vehiculos_sql /opt/mssql-tools18/bin/sqlcmd `
  -S localhost -U sa -P 'Dev_CtrlV3h1!' -C -d db_ControlVehiculos

# Build producción frontend
cd frontend && npm run build
```

---

## Estado actual del proyecto — dónde continuar

**Última sesión:** 2026-06-18

### Módulos implementados ✅
- **Auth:** login JWT, guard de rutas, sesión persistente (Zustand)
- **Clientes / Proveedores:** CRUD completo, filtro por tipo C/P
- **Vehículos:** CRUD con filtro por NIT
- **Productos / Servicios:** CRUD con filtro por tipo
- **Órdenes de Servicio:** crear, cerrar, reabrir, eliminar
- **Presupuestos:** crear, cerrar, convertir → OS
- **17 integration tests** en verde (auth, ciclo OS, conversión presupuesto)

### Próxima tarea pendiente
El campo **Placa** en Nueva OS ya tiene el `<Select>` que carga los vehículos del NIT seleccionado.
**Verificar en el navegador** que el flujo funciona end-to-end:
1. Ir a Clientes → crear un cliente con NIT
2. Ir a Vehículos → registrar un vehículo para ese NIT
3. Ir a Órdenes → Nueva OS → seleccionar el NIT → verificar que aparece la placa

### Fases siguientes (en `.ia-context/tasks/backlog.md`)
- **FASE 6:** Facturación — `POST /api/ordenes-servicio/{id}/facturar`
- **FASE 7:** Reportes PDF con QuestPDF
- **FASE 8:** Catálogos frontend (Marcas, Colores, Vendedores, Cajas…)
- **FASE 9:** Dashboard analítico con Recharts
