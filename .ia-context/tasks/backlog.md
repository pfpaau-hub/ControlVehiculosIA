# Tasks — Backlog

Trabajo pendiente para la recreación del sistema.
Formato: `[ ] Tarea — Notas relevantes`

---

## FASE 0 — Definición del nuevo stack ✅ COMPLETADO
- [x] Backend: C# + ASP.NET Core Web API (.NET 8 LTS)
- [x] Frontend: React + TypeScript
- [x] Base de datos: SQL Server (mantener — misma BD del VFP)
- [x] ORM: Entity Framework Core 8 + Dapper para queries complejas
- [x] Auth: ASP.NET Core Identity + JWT
- [x] Reportes PDF: FastReport.NET o RDLC (reemplaza Crystal Reports)
- [x] Despliegue: IIS o Azure App Service
- [ ] Definir estrategia multi-empresa en EF Core (HasQueryFilter global por id_empresa)
- [ ] Confirmar si inventarios es parte de este sistema o API/BD externa separada
- [ ] Decidir entre FastReport.NET vs RDLC para reportes

## FASE 1 — Diseño del nuevo sistema
- [ ] Diseñar nuevo esquema de BD aplicando correcciones de ADR-003
- [ ] Definir modelo de autenticación y roles (reemplaza sistema de privilegios CodeMine)
- [ ] Definir cómo se maneja el contexto de sesión (empresa, período, caja)
- [ ] Diseñar API REST (endpoints por módulo)
- [ ] Diseñar componente de búsqueda genérica (reemplaza frm_pantalla_busqueda)
- [ ] Diseñar modelo de reportes (parámetros, formato de salida)

## FASE 2 — Migración de datos
- [ ] Inspeccionar tablas SQL Server actuales con datos reales
- [ ] Mapear columnas antiguas → columnas nuevas (aplicando correcciones)
- [ ] Script de migración: clientes
- [ ] Script de migración: vehículos (corrección BUG-001 Puertas→Modelo)
- [ ] Script de migración: marcas, líneas, tipos, colores
- [ ] Script de migración: órdenes de servicio y detalles
- [ ] Script de migración: presupuestos (solo Sistema B: tbl_presupuesto_servicio*)
- [ ] Script de migración: series, cajas, cajeros
- [ ] Script de migración: empleados/vendedores
- [ ] Script de migración: comisiones (corrección BUG-002 Comision int→decimal)
- [ ] Eliminar tblprueba y sus inserts antes de migrar
- [ ] Validar integridad referencial después de migración

## FASE 3 — Implementación backend
- [ ] Setup proyecto y estructura de carpetas
- [ ] Configuración de BD y ORM
- [ ] Autenticación y gestión de sesión
- [ ] CRUD Empresas (config: sig_orden, sig_presupuesto, período, límite líneas)
- [ ] CRUD Clientes con validación NIT único
- [ ] CRUD Vehículos con relación marca→línea en cascada
- [ ] CRUD Catálogos (marcas, líneas, tipos, colores)
- [ ] CRUD Empleados/Vendedores
- [ ] CRUD Catálogos menores (bancos, casas de crédito, cajeros)
- [ ] CRUD Series y Cajas
- [ ] CRUD Bodegas
- [ ] CRUD Productos (servicios y repuestos con is_service flag)
- [ ] Gestión de Presupuestos (cabecera + detalle con autorizado)
- [ ] Conversión Presupuesto → Orden de Servicio (lógica de sp_genera_orden_servicio)
- [ ] Gestión de Órdenes de Servicio (cabecera + servicios + insumos)
- [ ] Lógica de cierre de OS (status 1→2, fecha_cierre)
- [ ] Lógica de reversión de cierre (validar numero=0 y fecha_facturacion IS NULL)
- [ ] Función equivalente a total_lineas_orden (con límite configurable)
- [ ] Endpoint sp_cambia_descuento_ordenes
- [ ] Endpoint sp_devuelve_NumOServicio
- [ ] Consulta de vehículos por cliente (sp_vehiculo_cliente)
- [ ] Consulta OLAP de órdenes (reemplazar co_ordenes_servicio)
- [ ] Gestión de comisiones por servicio (tipo 1 y tipo 2)
- [ ] Existencia de productos por bodega
- [ ] Generación de reportes PDF (los 10 reportes identificados)

## FASE 4 — Implementación frontend
- [ ] Login y selección de empresa
- [ ] Menú principal
- [ ] Módulo Clientes (con control de permisos por campo)
- [ ] Módulo Vehículos (con reload de líneas al cambiar marca)
- [ ] Módulo Presupuestos (cabecera + detalle con checkbox autorizado)
- [ ] Módulo Órdenes de Servicio (3 niveles: cabecera + servicios + insumos)
- [ ] Flujo Conversión Presupuesto → OS
- [ ] Módulo Anular Cierre de OS
- [ ] Módulo Comisiones (configuración)
- [ ] Módulo Catálogos (marcas/líneas, tipos, colores)
- [ ] Módulo Configuración (empresas, series, cajas, cajeros)
- [ ] Módulo Entidades (vendedores, bancos, casas crédito)
- [ ] Componente de búsqueda genérica reutilizable
- [ ] Módulo de Reportes (selección de filtros + vista previa PDF)
- [ ] Herramienta OLAP / BI (reemplaza ContourCubeLite)

## FASE 5 — Pruebas y puesta en marcha ✅ COMPLETADO
- [x] Integration tests: auth, ciclo de vida OS, conversión presupuesto→OS (17 tests, 17 verdes)
- [x] Script SQL de despliegue sobre BD de producción (scripts/01-prod-schema-deploy.sql)
- [x] Script de validación post-migración (scripts/02-validate-migration.sql)
- [x] appsettings.Production.json con variables de entorno
- [ ] Pruebas de control de permisos/roles
- [ ] Capacitación de usuarios
- [ ] Puesta en marcha en paralelo con sistema VFP
- [ ] Corte y cierre del sistema VFP

---

## FASE 6 — Facturación (PRÓXIMA)
**Objetivo:** Facturar una Orden de Servicio cerrada, emitir correlativo y cerrar el ciclo.

- [ ] Backend: endpoint `POST /api/ordenes-servicio/{id}/facturar` (serie, numero, fecha)
  - Valida que la OS esté cerrada (status=2) y sin factura (Numero=0)
  - Registra en `Tbl_Cab_Facturacion` y `Tbl_Det_Facturacion`
  - Actualiza `OS.Numero`, `OS.FechaFacturacion`, `OS.Serie`
  - Incrementa correlativo en `Tbl_Series`
- [ ] Backend: endpoint `GET /api/ordenes-servicio/{id}/factura` (consulta)
- [ ] Backend: endpoint `POST /api/facturas/{id}/anular` (notas de crédito)
- [ ] Frontend: `FacturacionPage.tsx` — flujo cerrar OS → seleccionar serie → emitir factura
- [ ] Frontend: botón "Facturar" en `OrdenesPage.tsx` (solo OS cerradas sin factura)
- [ ] Integration tests: flujo completo create→cerrar→facturar

## FASE 7 — Reportes PDF
**Objetivo:** Reemplazar los 9 reportes Crystal Reports con PDFs generados en el servidor.

Librería recomendada: **RDLC** (`Microsoft.Reporting.NETCore`) o **QuestPDF** (open source, fluent API).
QuestPDF es preferible: sin licencia de servidor, API moderna, fácil de testear.

- [ ] Instalar QuestPDF (`dotnet add package QuestPDF`)
- [ ] Servicio base `ReportService` con layout de página corporativo
- [ ] Reporte OS (equivale a `rpt_ordenes_servicio.rpt`) — cabecera + servicios + insumos
- [ ] Reporte Presupuesto (`rpt_presupuesto_servicio.rpt`)
- [ ] Reporte Factura (`rpt_cab_facturacion.rpt` + detalle)
- [ ] Reporte Lista de Servicios por OS (`rpt_lista_servicios.rpt`)
- [ ] Reporte Comisiones de Mecánico (`rpt_comisiones.rpt`)
- [ ] Reporte de Órdenes por Período (`rpt_ordenes_periodo.rpt`)
- [ ] Endpoints `GET /api/reportes/os/{id}/pdf`, `/presupuesto/{id}/pdf`, etc.
- [ ] Frontend: botón "Imprimir" abre PDF en nueva pestaña (blob URL)

## FASE 8 — Catálogos y configuración (frontend)
**Objetivo:** Completar las páginas de administración que faltan en el frontend.

- [ ] `MarcasPage.tsx` — CRUD marcas + inline gestión de líneas por marca
- [ ] `ColoresPage.tsx`, `TiposVehiculoPage.tsx` — CRUDs simples
- [ ] `VendedoresPage.tsx` — CRUD con campo porcentaje de comisión
- [ ] `BancosPage.tsx`, `CasasCreditoPage.tsx` — CRUDs simples
- [ ] `CajasPage.tsx`, `CajerosPage.tsx`, `SeriesPage.tsx` — con filtro por empresa
- [ ] `EmpresasPage.tsx` — formulario de configuración global (sig_orden, período, IVA, logo)
- [ ] Agregar todas al menú lateral de `AppLayout.tsx` bajo sección "Configuración"
- [ ] Componente `BuscadorGenerico.tsx` reutilizable (reemplaza frm_pantalla_busqueda del VFP)

## FASE 9 — OLAP / Dashboard analítico
**Objetivo:** Panel de inteligencia de negocio que reemplaza ContourCubeLite del sistema VFP.

- [ ] Backend: endpoint `GET /api/reportes/olap/ordenes` — pivot por período/mecánico/servicio
  - Equivale a `co_ordenes_servicio` del VFP
  - Parámetros: fechaDesde, fechaHasta, idEmpresa, agruparPor
- [ ] Backend: endpoint `GET /api/reportes/olap/ingresos-mes` — serie de tiempo mensual
- [ ] Backend: endpoint `GET /api/reportes/olap/top-servicios` — ranking de servicios
- [ ] Backend: endpoint `GET /api/reportes/olap/comisiones` — resumen por mecánico
- [ ] Frontend: `DashboardPage.tsx` ampliado con gráficas (librería: **Recharts** o **Apache ECharts**)
  - KPIs en tiempo real: OS abiertas, facturadas en el mes, anticipo pendiente
  - Gráfica de barras: ingresos por mes (últimos 12 meses)
  - Gráfica de donut: distribución por tipo de servicio
  - Tabla top-10: servicios más solicitados
