Para levantar en Windows — 3 pasos:

  # 1. Setup inicial (solo la primera vez)
  .\scripts\setup-dev.ps1

  # 2. Sesiones siguientes — Terminal 1 (backend)
  $env:ASPNETCORE_ENVIRONMENT = "Development"
  $env:ASPNETCORE_URLS        = "http://localhost:5000"
  dotnet run --project src\ControlVehiculos.API\ControlVehiculos.API.csproj --no-launch-profile

  # 3. Terminal 2 (frontend)
  cd frontend && npm run dev

  Abrir: http://localhost:5173 — usuario admin / contraseña Admin123!

  ---
  Para continuar desde este punto — la guía completa está en SETUP-WINDOWS.md. La siguiente tarea es verificar en el navegador que al crear una OS el combo de Placa muestra solo los vehículos del NIT seleccionado, y luego seguir con FASE 6 — Facturación (definida en
  .ia-context/tasks/backlog.md).
