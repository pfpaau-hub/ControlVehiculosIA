-- ============================================================
-- FASE 5 — Validación post-migración (corrida en paralelo)
-- Ejecutar después de 01-prod-schema-deploy.sql
--
-- Cada query devuelve conteos que deben coincidir entre el
-- sistema VFP y el nuevo sistema.  Las diferencias indican
-- registros que el nuevo sistema no está procesando.
-- ============================================================

USE [db_inventario_pfp];
GO

-- ============================================================
-- 1. Conteo de registros por tabla clave
-- ============================================================
SELECT
    'Tbl_Proveedores'               AS tabla, COUNT(*) AS registros FROM [Tbl_Proveedores] UNION ALL
SELECT 'Tbl_Vehiculos',                        COUNT(*) FROM [Tbl_Vehiculos]               UNION ALL
SELECT 'Tbl_Marcas',                           COUNT(*) FROM [Tbl_Marcas]                  UNION ALL
SELECT 'Tbl_Orden_Servicio',                   COUNT(*) FROM [Tbl_Orden_Servicio]           UNION ALL
SELECT 'Tbl_Orden_Servicio_Detalle',           COUNT(*) FROM [Tbl_Orden_Servicio_Detalle]   UNION ALL
SELECT 'Tbl_Presupuesto_Orden_Servicio',       COUNT(*) FROM [Tbl_Presupuesto_Orden_Servicio] UNION ALL
SELECT 'tbl_presupuesto_orden_servicio_detalle', COUNT(*) FROM [tbl_presupuesto_orden_servicio_detalle] UNION ALL
SELECT 'AspNetUsers',                          COUNT(*) FROM [AspNetUsers]
ORDER BY tabla;
GO

-- ============================================================
-- 2. Clientes/proveedores sin FK surrogate (Id = NULL)
-- Si este query devuelve filas, hay registros que se crearon
-- ANTES de ejecutar 01-prod-schema-deploy.sql y no tienen Id.
-- Deben ser 0.
-- ============================================================
SELECT 'Tbl_Proveedores sin Id' AS problema, COUNT(*) AS registros
FROM [Tbl_Proveedores]
WHERE [Id] IS NULL
UNION ALL
SELECT 'Tbl_Vehiculos sin Id',    COUNT(*) FROM [Tbl_Vehiculos]    WHERE [Id] IS NULL
UNION ALL
SELECT 'Tbl_Orden_Servicio sin Id', COUNT(*) FROM [Tbl_Orden_Servicio] WHERE [Id] IS NULL;
GO

-- ============================================================
-- 3. Órdenes de servicio abiertas vs cerradas
-- Comparar con pantalla de consulta del sistema VFP
-- ============================================================
SELECT
    Status,
    COUNT(*) AS total_ordenes,
    MIN(Fecha) AS fecha_mas_antigua,
    MAX(Fecha) AS fecha_mas_reciente
FROM [Tbl_Orden_Servicio]
GROUP BY Status
ORDER BY Status;
GO

-- ============================================================
-- 4. Presupuestos: distribución por estado
-- ============================================================
SELECT
    Status,
    COUNT(*) AS total_presupuestos
FROM [Tbl_Presupuesto_Orden_Servicio]
GROUP BY Status
ORDER BY Status;
GO

-- ============================================================
-- 5. Órdenes sin FK a vehículo (placa no encontrada)
-- Indica placas en OS que no tienen entrada en Tbl_Vehiculos
-- ============================================================
SELECT
    os.Id_Empresa,
    os.Num_Placa,
    COUNT(*) AS ordenes_sin_vehiculo
FROM [Tbl_Orden_Servicio] os
WHERE os.[VehiculoId] IS NULL
  AND os.Num_Placa <> ''
GROUP BY os.Id_Empresa, os.Num_Placa
ORDER BY ordenes_sin_vehiculo DESC;
GO

-- ============================================================
-- 6. Órdenes sin FK a cliente (NIT no encontrado)
-- ============================================================
SELECT
    os.Id_Empresa,
    os.Nit,
    COUNT(*) AS ordenes_sin_cliente
FROM [Tbl_Orden_Servicio] os
WHERE os.[ProveedorId] IS NULL
  AND os.Nit <> ''
  AND os.Nit <> 'CF'
GROUP BY os.Id_Empresa, os.Nit
ORDER BY ordenes_sin_cliente DESC;
GO

-- ============================================================
-- 7. Presupuestos convertidos vs OS creadas por mes (último año)
-- Validar que la conversión genera el mismo número de OS
-- ============================================================
SELECT
    FORMAT(os.Fecha, 'yyyy-MM') AS mes,
    COUNT(*) AS ordenes_creadas
FROM [Tbl_Orden_Servicio] os
WHERE os.Fecha >= DATEADD(YEAR, -1, GETDATE())
GROUP BY FORMAT(os.Fecha, 'yyyy-MM')
ORDER BY mes DESC;
GO

-- ============================================================
-- 8. Verificar que usuarios de ASP.NET Identity existen
-- ============================================================
SELECT
    UserName,
    Email,
    IdEmpresa,
    Periodo,
    LockoutEnabled,
    AccessFailedCount
FROM [AspNetUsers]
ORDER BY UserName;
GO

-- ============================================================
-- 9. Check de integridad: detalles OS sin cabecera
-- ============================================================
SELECT COUNT(*) AS detalles_huerfanos
FROM [Tbl_Orden_Servicio_Detalle] d
WHERE NOT EXISTS (
    SELECT 1 FROM [Tbl_Orden_Servicio] os
    WHERE os.Id_Empresa = d.Id_Empresa
      AND os.Id_Orden   = CAST(d.Id_Orden AS INT)
);
GO

-- ============================================================
-- RESULTADO ESPERADO:
--   Todos los conteos de la sección 2 = 0
--   Secciones 5 y 6 vacías (o solo NITs = 'CF' que es normal)
--   Sección 9 = 0 detalles huérfanos
-- ============================================================
