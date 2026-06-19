# =============================================================
# setup-dev.ps1  —  Levanta el entorno de desarrollo en Windows
# Ejecutar desde la raiz del proyecto:
#   .\scripts\setup-dev.ps1
# =============================================================

$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ControlVehiculos — Setup Desarrollo   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ── 1. Verificar prerrequisitos ──────────────────────────────
function Check-Tool($cmd, $name, $url) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Host "[FALTA] $name — Instalar desde: $url" -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] $name" -ForegroundColor Green
}

Check-Tool "docker"  "Docker Desktop"  "https://www.docker.com/products/docker-desktop"
Check-Tool "dotnet"  ".NET SDK 10"     "https://dotnet.microsoft.com/download"
Check-Tool "node"    "Node.js 20+"     "https://nodejs.org"
Check-Tool "npm"     "npm"             "https://nodejs.org"

Write-Host ""

# ── 2. Levantar SQL Server ───────────────────────────────────
Write-Host "Levantando SQL Server en Docker..." -ForegroundColor Yellow
docker compose up -d
if ($LASTEXITCODE -ne 0) { Write-Host "Error al levantar Docker" -ForegroundColor Red; exit 1 }

Write-Host "Esperando que SQL Server este listo (hasta 60s)..." -ForegroundColor Yellow
$ready = $false
for ($i = 1; $i -le 12; $i++) {
    Start-Sleep -Seconds 5
    $result = docker exec ctrl_vehiculos_sql /opt/mssql-tools18/bin/sqlcmd `
        -S localhost -U sa -P 'Dev_CtrlV3h1!' -Q 'SELECT 1' -No 2>&1
    if ($result -match "^1") { $ready = $true; break }
    Write-Host "  Intento $i/12..." -ForegroundColor Gray
}
if (-not $ready) { Write-Host "SQL Server no respondio a tiempo" -ForegroundColor Red; exit 1 }
Write-Host "[OK] SQL Server listo" -ForegroundColor Green

# ── 3. Aplicar migraciones EF Core ──────────────────────────
Write-Host ""
Write-Host "Aplicando migraciones de base de datos..." -ForegroundColor Yellow
$env:ASPNETCORE_ENVIRONMENT = "Development"
dotnet ef database update `
    --project src\ControlVehiculos.Infrastructure\ControlVehiculos.Infrastructure.csproj `
    --startup-project src\ControlVehiculos.API\ControlVehiculos.API.csproj
if ($LASTEXITCODE -ne 0) { Write-Host "Error en migraciones EF Core" -ForegroundColor Red; exit 1 }
Write-Host "[OK] Base de datos lista" -ForegroundColor Green

# ── 4. Instalar dependencias frontend ───────────────────────
Write-Host ""
Write-Host "Instalando dependencias del frontend..." -ForegroundColor Yellow
Set-Location "$Root\frontend"
npm install --silent
if ($LASTEXITCODE -ne 0) { Write-Host "Error en npm install" -ForegroundColor Red; exit 1 }
Write-Host "[OK] node_modules instalado" -ForegroundColor Green
Set-Location $Root

# ── 5. Instrucciones finales ─────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup completado. Para iniciar:" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Terminal 1 — Backend:" -ForegroundColor Cyan
Write-Host '    $env:ASPNETCORE_ENVIRONMENT="Development"' -ForegroundColor White
Write-Host '    $env:ASPNETCORE_URLS="http://localhost:5000"' -ForegroundColor White
Write-Host "    dotnet run --project src\ControlVehiculos.API\ControlVehiculos.API.csproj --no-launch-profile" -ForegroundColor White
Write-Host ""
Write-Host "  Terminal 2 — Frontend:" -ForegroundColor Cyan
Write-Host "    cd frontend" -ForegroundColor White
Write-Host "    npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "  Abrir en el navegador: http://localhost:5173" -ForegroundColor Cyan
Write-Host "  Usuario: admin   Contrasena: Admin123!" -ForegroundColor Cyan
Write-Host ""
