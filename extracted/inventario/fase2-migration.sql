-- ============================================================
-- FASE 2 — Migración de llaves compuestas a llaves sustitutas
-- Base de datos: db_inventario_pfp  (módulo taller automotriz)
-- Referencia ADR: ADR-005-surrogate-keys.md
-- Generado: 2026-06-18
--
-- ORDEN DE EJECUCIÓN (nunca saltar pasos ni cambiar orden):
--   PARTE A  Eliminar PKs compuestas existentes
--   PARTE B  Agregar columna Id INT IDENTITY como nueva PK
--   PARTE C  Agregar UNIQUE constraints sobre claves naturales
--   PARTE D  Agregar columnas de navegación FK
--   PARTE E  Poblar columnas FK desde datos existentes
--   PARTE F  Agregar FK constraints reales
--   PARTE G  Validación post-migración
--
-- PRECAUCIONES:
--   - Ejecutar completo en una transacción o script a script
--   - Si hay datos reales, ejecutar PARTE G primero en modo READ ONLY
--   - Los SPs y triggers del sistema VFP siguen funcionando:
--     siguen leyendo/escribiendo los campos originales (no se eliminan)
-- ============================================================

USE [db_inventario_pfp];
GO

-- ============================================================
-- PARTE A — Eliminar PKs compuestas existentes
-- Usa SQL dinámico porque los nombres son auto-generados
-- ============================================================

-- Macro reutilizable: drop PK de una tabla
-- (ejecutar bloque a bloque para cada tabla)

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Bancos] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Bancos' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_bodega] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_bodega' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Cajas] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Cajas' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Cajeros] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Cajeros' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Casas_Credito] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Casas_Credito' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_colores] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_colores' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_insumos_servicios] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_insumos_servicios' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Linea_Vehiculo] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Linea_Vehiculo' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Marcas] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Marcas' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Orden_Servicio] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Orden_Servicio' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Orden_Servicio_Detalle] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Orden_Servicio_Detalle' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Orden_Servicio_Detalle_Integracion' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

-- Nota: _eliminadas ya tiene [correlativo] IDENTITY(1,1) — solo cambiar la definición de PK
DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion_eliminadas] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Orden_Servicio_Detalle_Integracion_eliminadas' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Presupuesto_Orden_Servicio] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Presupuesto_Orden_Servicio' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [tbl_presupuesto_orden_servicio_detalle] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'tbl_presupuesto_orden_servicio_detalle' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Productos] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Productos' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [tbl_productos_comisiones] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'tbl_productos_comisiones' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Proveedores] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Proveedores' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Series] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Series' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Tipo_Vehiculos] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Tipo_Vehiculos' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Vehiculos] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Vehiculos' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

DECLARE @sql NVARCHAR(512);
SELECT @sql = N'ALTER TABLE [Tbl_Vendedores] DROP CONSTRAINT [' + CONSTRAINT_NAME + N']'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Tbl_Vendedores' AND CONSTRAINT_TYPE = 'PRIMARY KEY';
IF @sql IS NOT NULL EXEC sp_executesql @sql;
GO

-- ============================================================
-- PARTE B — Agregar columna Id INT IDENTITY como nueva PK
-- Al agregar IDENTITY a tabla con filas existentes, SQL Server
-- auto-asigna valores secuenciales sin necesidad de SET IDENTITY_INSERT
-- ============================================================

-- Catálogos simples
ALTER TABLE [Tbl_Bancos]                               ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_bodega]                               ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Cajas]                                ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Cajeros]                              ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Casas_Credito]                        ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_colores]                              ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_insumos_servicios]                    ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Linea_Vehiculo]                       ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Marcas]                               ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Tipo_Vehiculos]                       ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Vendedores]                           ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Productos]                            ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [tbl_productos_comisiones]                 ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Proveedores]                          ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Series]                               ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Vehiculos]                            ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO

-- Tablas transaccionales
ALTER TABLE [Tbl_Presupuesto_Orden_Servicio]                    ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [tbl_presupuesto_orden_servicio_detalle]            ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion] ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Orden_Servicio]                               ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Orden_Servicio_Detalle]                       ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion]           ADD [Id] INT IDENTITY(1,1) NOT NULL;
GO
-- _eliminadas: ya tiene [correlativo] IDENTITY — no agregar otro, usar correlativo como PK
-- (columna Id en EF Core mapea a [correlativo] via HasColumnName)

-- ============================================================
-- PARTE C — Agregar nuevas PKs sobre la columna Id
-- ============================================================

ALTER TABLE [Tbl_Bancos]                               ADD CONSTRAINT [PK_Tbl_Bancos]              PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_bodega]                               ADD CONSTRAINT [PK_Tbl_bodega]              PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Cajas]                                ADD CONSTRAINT [PK_Tbl_Cajas]               PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Cajeros]                              ADD CONSTRAINT [PK_Tbl_Cajeros]             PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Casas_Credito]                        ADD CONSTRAINT [PK_Tbl_Casas_Credito]       PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_colores]                              ADD CONSTRAINT [PK_Tbl_colores]             PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_insumos_servicios]                    ADD CONSTRAINT [PK_Tbl_insumos_servicios]   PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Linea_Vehiculo]                       ADD CONSTRAINT [PK_Tbl_Linea_Vehiculo]      PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Marcas]                               ADD CONSTRAINT [PK_Tbl_Marcas]              PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Tipo_Vehiculos]                       ADD CONSTRAINT [PK_Tbl_Tipo_Vehiculos]      PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Vendedores]                           ADD CONSTRAINT [PK_Tbl_Vendedores]          PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Productos]                            ADD CONSTRAINT [PK_Tbl_Productos]           PRIMARY KEY ([Id]);
GO
ALTER TABLE [tbl_productos_comisiones]                 ADD CONSTRAINT [PK_tbl_productos_comisiones] PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Proveedores]                          ADD CONSTRAINT [PK_Tbl_Proveedores]         PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Series]                               ADD CONSTRAINT [PK_Tbl_Series]              PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Vehiculos]                            ADD CONSTRAINT [PK_Tbl_Vehiculos]           PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Presupuesto_Orden_Servicio]           ADD CONSTRAINT [PK_Tbl_Presupuesto_OS]      PRIMARY KEY ([Id]);
GO
ALTER TABLE [tbl_presupuesto_orden_servicio_detalle]   ADD CONSTRAINT [PK_tbl_Presupuesto_OS_Det]  PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion]
                                                       ADD CONSTRAINT [PK_Tbl_Presupuesto_OS_Det_Int] PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Orden_Servicio]                       ADD CONSTRAINT [PK_Tbl_Orden_Servicio]      PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Orden_Servicio_Detalle]               ADD CONSTRAINT [PK_Tbl_Orden_Servicio_Det]  PRIMARY KEY ([Id]);
GO
ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion]   ADD CONSTRAINT [PK_Tbl_OS_Det_Int]          PRIMARY KEY ([Id]);
GO
-- _eliminadas: correlativo ya existe, solo asignar como PK simple
ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion_eliminadas]
                                                       ADD CONSTRAINT [PK_Tbl_OS_Det_Int_Elim]     PRIMARY KEY ([correlativo]);
GO

-- ============================================================
-- PARTE D — UNIQUE constraints sobre las claves naturales
-- Preservan la integridad del negocio y permiten al sistema VFP
-- seguir funcionando con sus referencias compuestas
-- ============================================================

-- Catálogos simples
ALTER TABLE [Tbl_Bancos]          ADD CONSTRAINT [UQ_Tbl_Bancos_Natural]        UNIQUE ([Id_Empresa], [Id_Banco]);
GO
ALTER TABLE [Tbl_bodega]          ADD CONSTRAINT [UQ_Tbl_bodega_Natural]        UNIQUE ([Id_Empresa], [Id_Bodega]);
GO
ALTER TABLE [Tbl_Cajas]           ADD CONSTRAINT [UQ_Tbl_Cajas_Natural]         UNIQUE ([Id_Empresa], [Id_Caja]);
GO
ALTER TABLE [Tbl_Cajeros]         ADD CONSTRAINT [UQ_Tbl_Cajeros_Natural]       UNIQUE ([Id_Empresa], [Id_Cajero]);
GO
ALTER TABLE [Tbl_Casas_Credito]   ADD CONSTRAINT [UQ_Tbl_Casas_Natural]         UNIQUE ([Id_Empresa], [Id_Casa]);
GO
ALTER TABLE [Tbl_colores]         ADD CONSTRAINT [UQ_Tbl_colores_Natural]       UNIQUE ([Id_Empresa], [Color]);
GO
ALTER TABLE [Tbl_insumos_servicios] ADD CONSTRAINT [UQ_Tbl_insumos_Natural]     UNIQUE ([Id_empresa], [Id_producto], [Id_Producto1]);
GO
ALTER TABLE [Tbl_Linea_Vehiculo]  ADD CONSTRAINT [UQ_Tbl_Linea_Veh_Natural]     UNIQUE ([Id_Empresa], [Id_Marca], [Id_Linea]);
GO
ALTER TABLE [Tbl_Marcas]          ADD CONSTRAINT [UQ_Tbl_Marcas_Natural]        UNIQUE ([Id_Empresa], [Id_Marca]);
GO
ALTER TABLE [Tbl_Tipo_Vehiculos]  ADD CONSTRAINT [UQ_Tbl_Tipo_Veh_Natural]      UNIQUE ([Id_Empresa], [Tipo]);
GO
ALTER TABLE [Tbl_Vendedores]      ADD CONSTRAINT [UQ_Tbl_Vendedores_Natural]    UNIQUE ([Id_Empresa], [Id_Empleado]);
GO
ALTER TABLE [Tbl_Productos]       ADD CONSTRAINT [UQ_Tbl_Productos_Natural]     UNIQUE ([Id_Empresa], [Id_Producto]);
GO
ALTER TABLE [tbl_productos_comisiones] ADD CONSTRAINT [UQ_tbl_prod_com_Natural] UNIQUE ([Id_Empresa], [Id_Producto]);
GO
ALTER TABLE [Tbl_Proveedores]     ADD CONSTRAINT [UQ_Tbl_Proveedores_Natural]   UNIQUE ([Id_Empresa], [Nit]);
GO
ALTER TABLE [Tbl_Series]          ADD CONSTRAINT [UQ_Tbl_Series_Natural]        UNIQUE ([Id_Empresa], [Autorizacion]);
GO
ALTER TABLE [Tbl_Vehiculos]       ADD CONSTRAINT [UQ_Tbl_Vehiculos_Natural]     UNIQUE ([Id_Empresa], [Num_Placa]);
GO

-- Tablas transaccionales
ALTER TABLE [Tbl_Presupuesto_Orden_Servicio]
    ADD CONSTRAINT [UQ_Tbl_Presupuesto_OS_Natural]     UNIQUE ([Id_Empresa], [Id_Orden]);
GO
ALTER TABLE [tbl_presupuesto_orden_servicio_detalle]
    ADD CONSTRAINT [UQ_tbl_Presupuesto_OS_Det_Natural] UNIQUE ([Id_Empresa], [Id_Orden], [Linea]);
GO
ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion]
    ADD CONSTRAINT [UQ_Tbl_Presupuesto_OS_DI_Natural]  UNIQUE ([Id_Empresa], [Id_Orden], [Linea], [Linea_det]);
GO
ALTER TABLE [Tbl_Orden_Servicio]
    ADD CONSTRAINT [UQ_Tbl_Orden_Servicio_Natural]     UNIQUE ([Id_Empresa], [Id_Orden]);
GO
ALTER TABLE [Tbl_Orden_Servicio_Detalle]
    ADD CONSTRAINT [UQ_Tbl_OS_Det_Natural]             UNIQUE ([Id_Empresa], [Id_Orden], [Linea]);
GO
ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion]
    ADD CONSTRAINT [UQ_Tbl_OS_Det_Int_Natural]         UNIQUE ([Id_Empresa], [Id_Orden], [Linea], [Linea_det]);
GO
-- _eliminadas: múltiples eliminaciones del mismo (empresa, orden, linea, linea_det) son válidas
-- NO se agrega UNIQUE en esos campos — correlativo ya garantiza unicidad

-- ============================================================
-- PARTE E — Agregar columnas de navegación FK
-- Estas columnas son las que EF Core usa para los navigation properties
-- El sistema VFP NO las usa — son solo para el nuevo sistema
-- ============================================================

-- Tbl_Vehiculos → Tbl_Proveedores (via Nit text → surrogate Id)
ALTER TABLE [Tbl_Vehiculos] ADD [ProveedorId] INT NULL;
GO

-- Tbl_Orden_Servicio → Tbl_Vehiculos (via Num_Placa text → surrogate Id)
ALTER TABLE [Tbl_Orden_Servicio] ADD [VehiculoId] INT NULL;
GO

-- Tbl_Orden_Servicio_Detalle → Tbl_Orden_Servicio (via Id_Empresa+Id_Orden → surrogate Id)
ALTER TABLE [Tbl_Orden_Servicio_Detalle] ADD [OrdenServicioId] INT NULL;
GO

-- Tbl_Orden_Servicio_Detalle_Integracion → Tbl_Orden_Servicio_Detalle
ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion] ADD [OrdenDetalleId] INT NULL;
GO

-- Tbl_Orden_Servicio_Detalle_Integracion_eliminadas → Tbl_Orden_Servicio_Detalle
ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion_eliminadas] ADD [OrdenDetalleId] INT NULL;
GO

-- tbl_presupuesto_orden_servicio_detalle → Tbl_Presupuesto_Orden_Servicio
ALTER TABLE [tbl_presupuesto_orden_servicio_detalle] ADD [PresupuestoId] INT NULL;
GO

-- Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion → tbl_presupuesto_orden_servicio_detalle
ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion] ADD [PresupuestoDetalleId] INT NULL;
GO

-- Tbl_Linea_Vehiculo → Tbl_Marcas
ALTER TABLE [Tbl_Linea_Vehiculo] ADD [MarcaId] INT NULL;
GO

-- tbl_productos_comisiones → Tbl_Productos
ALTER TABLE [tbl_productos_comisiones] ADD [ProductoId] INT NULL;
GO

-- Tbl_Presupuesto_Orden_Servicio → Tbl_Vehiculos (via Num_Placa)
ALTER TABLE [Tbl_Presupuesto_Orden_Servicio] ADD [VehiculoId] INT NULL;
GO

-- ============================================================
-- PARTE F — Poblar columnas FK con los Ids surrogate
-- Estos UPDATE relacionan los datos existentes via las claves naturales
-- ============================================================

-- Tbl_Vehiculos.ProveedorId ← Tbl_Proveedores.Id  (via Nit + Id_Empresa)
UPDATE v
SET    v.[ProveedorId] = p.[Id]
FROM   [Tbl_Vehiculos] v
JOIN   [Tbl_Proveedores] p ON p.[Id_Empresa] = v.[Id_Empresa]
                           AND p.[Nit]        = v.[nit];
GO

-- Tbl_Orden_Servicio.VehiculoId ← Tbl_Vehiculos.Id  (via Num_Placa + Id_Empresa)
UPDATE os
SET    os.[VehiculoId] = v.[Id]
FROM   [Tbl_Orden_Servicio] os
JOIN   [Tbl_Vehiculos] v ON v.[Id_Empresa] = os.[Id_Empresa]
                        AND v.[Num_Placa]  = os.[Num_Placa];
GO

-- Tbl_Orden_Servicio_Detalle.OrdenServicioId ← Tbl_Orden_Servicio.Id
UPDATE d
SET    d.[OrdenServicioId] = os.[Id]
FROM   [Tbl_Orden_Servicio_Detalle] d
JOIN   [Tbl_Orden_Servicio] os ON os.[Id_Empresa] = d.[Id_Empresa]
                               AND os.[Id_Orden]   = d.[Id_Orden];
GO

-- Tbl_Orden_Servicio_Detalle_Integracion.OrdenDetalleId ← Tbl_Orden_Servicio_Detalle.Id
UPDATE di
SET    di.[OrdenDetalleId] = det.[Id]
FROM   [Tbl_Orden_Servicio_Detalle_Integracion] di
JOIN   [Tbl_Orden_Servicio_Detalle] det ON det.[Id_Empresa] = di.[Id_Empresa]
                                        AND det.[Id_Orden]   = di.[Id_Orden]
                                        AND det.[Linea]      = di.[Linea];
GO

-- Tbl_Orden_Servicio_Detalle_Integracion_eliminadas.OrdenDetalleId ← Tbl_Orden_Servicio_Detalle.Id
-- Nota: algunas filas pueden no tener match si el detalle padre ya fue eliminado (esperado)
UPDATE di
SET    di.[OrdenDetalleId] = det.[Id]
FROM   [Tbl_Orden_Servicio_Detalle_Integracion_eliminadas] di
JOIN   [Tbl_Orden_Servicio_Detalle] det ON det.[Id_Empresa] = di.[Id_Empresa]
                                        AND det.[Id_Orden]   = di.[Id_Orden]
                                        AND det.[Linea]      = di.[Linea];
GO

-- tbl_presupuesto_orden_servicio_detalle.PresupuestoId ← Tbl_Presupuesto_Orden_Servicio.Id
UPDATE d
SET    d.[PresupuestoId] = p.[Id]
FROM   [tbl_presupuesto_orden_servicio_detalle] d
JOIN   [Tbl_Presupuesto_Orden_Servicio] p ON p.[Id_Empresa] = d.[Id_Empresa]
                                          AND p.[Id_Orden]   = d.[Id_Orden];
GO

-- Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion.PresupuestoDetalleId
UPDATE di
SET    di.[PresupuestoDetalleId] = det.[Id]
FROM   [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion] di
JOIN   [tbl_presupuesto_orden_servicio_detalle] det ON det.[Id_Empresa] = di.[Id_Empresa]
                                                    AND det.[Id_Orden]   = di.[Id_Orden]
                                                    AND det.[Linea]      = di.[Linea];
GO

-- Tbl_Linea_Vehiculo.MarcaId ← Tbl_Marcas.Id
UPDATE lv
SET    lv.[MarcaId] = m.[Id]
FROM   [Tbl_Linea_Vehiculo] lv
JOIN   [Tbl_Marcas] m ON m.[Id_Empresa] = lv.[Id_Empresa]
                      AND m.[Id_Marca]   = lv.[Id_Marca];
GO

-- tbl_productos_comisiones.ProductoId ← Tbl_Productos.Id
UPDATE pc
SET    pc.[ProductoId] = p.[Id]
FROM   [tbl_productos_comisiones] pc
JOIN   [Tbl_Productos] p ON p.[Id_Empresa] = pc.[Id_Empresa]
                         AND p.[Id_Producto] = pc.[Id_Producto];
GO

-- Tbl_Presupuesto_Orden_Servicio.VehiculoId ← Tbl_Vehiculos.Id
UPDATE pos
SET    pos.[VehiculoId] = v.[Id]
FROM   [Tbl_Presupuesto_Orden_Servicio] pos
JOIN   [Tbl_Vehiculos] v ON v.[Id_Empresa] = pos.[Id_Empresa]
                        AND v.[Num_Placa]  = pos.[Num_Placa];
GO

-- ============================================================
-- PARTE G — Agregar FK constraints reales
-- Solo agregar si las columnas FK están 100% pobladas (validar primero)
-- ============================================================

-- Verificar que no hay NULLs antes de ejecutar esta parte:
-- SELECT COUNT(*) FROM [Tbl_Vehiculos]  WHERE [ProveedorId] IS NULL AND [nit] <> '';
-- SELECT COUNT(*) FROM [Tbl_Orden_Servicio] WHERE [VehiculoId] IS NULL;
-- Si hay NULLs por datos inconsistentes en el sistema antiguo, decidir:
--   opción A: dejar la columna nullable y no agregar FK constraint
--   opción B: limpiar los datos primero

ALTER TABLE [Tbl_Vehiculos]
    ADD CONSTRAINT [FK_Vehiculos_Proveedores]
    FOREIGN KEY ([ProveedorId]) REFERENCES [Tbl_Proveedores] ([Id]);
GO

ALTER TABLE [Tbl_Orden_Servicio]
    ADD CONSTRAINT [FK_OS_Vehiculos]
    FOREIGN KEY ([VehiculoId]) REFERENCES [Tbl_Vehiculos] ([Id]);
GO

ALTER TABLE [Tbl_Orden_Servicio_Detalle]
    ADD CONSTRAINT [FK_OS_Det_OS]
    FOREIGN KEY ([OrdenServicioId]) REFERENCES [Tbl_Orden_Servicio] ([Id]);
GO

ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion]
    ADD CONSTRAINT [FK_OS_Det_Int_Det]
    FOREIGN KEY ([OrdenDetalleId]) REFERENCES [Tbl_Orden_Servicio_Detalle] ([Id]);
GO

-- _eliminadas: FK opcional (el detalle padre puede ya no existir)
ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion_eliminadas]
    ADD CONSTRAINT [FK_OS_Det_Int_Elim_Det]
    FOREIGN KEY ([OrdenDetalleId]) REFERENCES [Tbl_Orden_Servicio_Detalle] ([Id]);
GO

ALTER TABLE [tbl_presupuesto_orden_servicio_detalle]
    ADD CONSTRAINT [FK_Presupuesto_Det_Presupuesto]
    FOREIGN KEY ([PresupuestoId]) REFERENCES [Tbl_Presupuesto_Orden_Servicio] ([Id]);
GO

ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion]
    ADD CONSTRAINT [FK_Presupuesto_Det_Int_Det]
    FOREIGN KEY ([PresupuestoDetalleId]) REFERENCES [tbl_presupuesto_orden_servicio_detalle] ([Id]);
GO

ALTER TABLE [Tbl_Linea_Vehiculo]
    ADD CONSTRAINT [FK_LineaVehiculo_Marcas]
    FOREIGN KEY ([MarcaId]) REFERENCES [Tbl_Marcas] ([Id]);
GO

ALTER TABLE [tbl_productos_comisiones]
    ADD CONSTRAINT [FK_ProductosComisiones_Productos]
    FOREIGN KEY ([ProductoId]) REFERENCES [Tbl_Productos] ([Id]);
GO

ALTER TABLE [Tbl_Presupuesto_Orden_Servicio]
    ADD CONSTRAINT [FK_Presupuesto_OS_Vehiculos]
    FOREIGN KEY ([VehiculoId]) REFERENCES [Tbl_Vehiculos] ([Id]);
GO

-- ============================================================
-- PARTE H — Validación post-migración
-- Ejecutar estos SELECT para verificar que la migración fue correcta
-- ============================================================

-- 1. Verificar que todas las tablas tienen columna Id
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'Tbl_Bancos', 'Tbl_bodega', 'Tbl_Cajas', 'Tbl_Cajeros', 'Tbl_Casas_Credito',
    'Tbl_colores', 'Tbl_insumos_servicios', 'Tbl_Linea_Vehiculo', 'Tbl_Marcas',
    'Tbl_Tipo_Vehiculos', 'Tbl_Vendedores', 'Tbl_Productos', 'tbl_productos_comisiones',
    'Tbl_Proveedores', 'Tbl_Series', 'Tbl_Vehiculos',
    'Tbl_Presupuesto_Orden_Servicio', 'tbl_presupuesto_orden_servicio_detalle',
    'Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion',
    'Tbl_Orden_Servicio', 'Tbl_Orden_Servicio_Detalle',
    'Tbl_Orden_Servicio_Detalle_Integracion'
) AND COLUMN_NAME = 'Id'
ORDER BY TABLE_NAME;
GO

-- 2. Verificar que las PKs están correctas
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME IN (
    'Tbl_Bancos', 'Tbl_Orden_Servicio', 'Tbl_Orden_Servicio_Detalle',
    'Tbl_Orden_Servicio_Detalle_Integracion', 'Tbl_Proveedores', 'Tbl_Vehiculos'
) AND CONSTRAINT_NAME LIKE 'PK%'
ORDER BY TABLE_NAME;
GO

-- 3. Verificar integridad de FKs: cuántas filas tienen FK NULL
SELECT
    'Tbl_Vehiculos.ProveedorId NULL'  AS check_name,
    COUNT(*)                          AS filas_sin_fk
FROM [Tbl_Vehiculos]
WHERE [ProveedorId] IS NULL AND [nit] <> ''
UNION ALL
SELECT
    'Tbl_OS.VehiculoId NULL',
    COUNT(*)
FROM [Tbl_Orden_Servicio]
WHERE [VehiculoId] IS NULL
UNION ALL
SELECT
    'Tbl_OS_Det.OrdenServicioId NULL',
    COUNT(*)
FROM [Tbl_Orden_Servicio_Detalle]
WHERE [OrdenServicioId] IS NULL
UNION ALL
SELECT
    'Tbl_OS_Det_Int.OrdenDetalleId NULL',
    COUNT(*)
FROM [Tbl_Orden_Servicio_Detalle_Integracion]
WHERE [OrdenDetalleId] IS NULL;
GO

-- 4. Verificar que los UNIQUE constraints no tienen duplicados
-- (si esta query retorna filas, hay duplicados en los datos originales que hay que limpiar)
SELECT 'Tbl_Proveedores duplicados' AS tabla, Id_Empresa, Nit, COUNT(*) AS cnt
FROM [Tbl_Proveedores] GROUP BY Id_Empresa, Nit HAVING COUNT(*) > 1
UNION ALL
SELECT 'Tbl_Vehiculos duplicados', Id_Empresa, Num_Placa, COUNT(*)
FROM [Tbl_Vehiculos] GROUP BY Id_Empresa, Num_Placa HAVING COUNT(*) > 1
UNION ALL
SELECT 'Tbl_OS duplicados', CAST(Id_Empresa AS CHAR(10)), CAST(Id_Orden AS CHAR(20)), COUNT(*)
FROM [Tbl_Orden_Servicio] GROUP BY Id_Empresa, Id_Orden HAVING COUNT(*) > 1;
GO
