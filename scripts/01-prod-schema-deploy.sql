-- ============================================================
-- FASE 5 — Script de despliegue sobre base de datos de producción
-- Target: [db_inventario_pfp] (SQL Server)
--
-- Este script es IDEMPOTENTE: verifica la existencia de cada
-- columna/tabla antes de agregarla. Se puede ejecutar varias
-- veces sin error.
--
-- ORDEN:
--   PASO 1  Agregar columna Id IDENTITY a tablas que no la tienen
--   PASO 2  Agregar columnas FK surrogate (ProveedorId, VehiculoId, etc.)
--   PASO 3  Poblar FKs desde claves naturales existentes
--   PASO 4  Crear tablas de ASP.NET Identity (AspNetUsers, etc.)
--   PASO 5  Registrar migración EF Core en __EFMigrationsHistory
--
-- PRECONDICIÓN: Ejecutar 01-prod-schema-deploy.sql ANTES de
--   `dotnet ef database update` — esto evita que EF intente crear
--   tablas que ya existen.
-- ============================================================

USE [db_inventario_pfp];
GO

-- ============================================================
-- PASO 1 — Agregar Id INT IDENTITY a cada tabla de taller
-- ============================================================

-- Macro reutilizable para agregar Id a una tabla
-- (copiada y adaptada desde extracted/inventario/fase2-migration.sql)

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Proveedores') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Proveedores] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Proveedores.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Vehiculos') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Vehiculos] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Vehiculos.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Marcas') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Marcas] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Marcas.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Linea_Vehiculo') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Linea_Vehiculo] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Linea_Vehiculo.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_colores') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_colores] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_colores.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Tipo_Vehiculos') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Tipo_Vehiculos] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Tipo_Vehiculos.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Vendedores') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Vendedores] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Vendedores.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_bodega') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_bodega] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_bodega.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Cajas') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Cajas] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Cajas.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Cajeros') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Cajeros] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Cajeros.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Series') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Series] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Series.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Bancos') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Bancos] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Bancos.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Casas_Credito') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Casas_Credito] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Casas_Credito.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Orden_Servicio') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Orden_Servicio] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Orden_Servicio.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Orden_Servicio_Detalle') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Orden_Servicio_Detalle] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Orden_Servicio_Detalle.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Orden_Servicio_Detalle_Integracion') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Orden_Servicio_Detalle_Integracion.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Presupuesto_Orden_Servicio') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Presupuesto_Orden_Servicio] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Presupuesto_Orden_Servicio.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('tbl_presupuesto_orden_servicio_detalle') AND name = 'Id')
BEGIN
    ALTER TABLE [tbl_presupuesto_orden_servicio_detalle] ADD [Id] INT IDENTITY(1,1);
    PRINT 'tbl_presupuesto_orden_servicio_detalle.Id agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion') AND name = 'Id')
BEGIN
    ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion] ADD [Id] INT IDENTITY(1,1);
    PRINT 'Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion.Id agregada';
END
GO

-- ============================================================
-- PASO 2 — Agregar columnas FK surrogate (soft references)
-- Usadas por EF Core para navegar entre entidades.
-- El sistema VFP sigue usando las claves naturales — estas
-- columnas son adicionales, no reemplazan nada.
-- ============================================================

-- OrdenServicio.ProveedorId → Tbl_Proveedores.Id
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Orden_Servicio') AND name = 'ProveedorId')
BEGIN
    ALTER TABLE [Tbl_Orden_Servicio] ADD [ProveedorId] INT NULL;
    PRINT 'Tbl_Orden_Servicio.ProveedorId agregada';
END
GO

-- OrdenServicio.VehiculoId → Tbl_Vehiculos.Id
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Orden_Servicio') AND name = 'VehiculoId')
BEGIN
    ALTER TABLE [Tbl_Orden_Servicio] ADD [VehiculoId] INT NULL;
    PRINT 'Tbl_Orden_Servicio.VehiculoId agregada';
END
GO

-- PresupuestoOrdenServicio.ProveedorId y VehiculoId
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Presupuesto_Orden_Servicio') AND name = 'ProveedorId')
BEGIN
    ALTER TABLE [Tbl_Presupuesto_Orden_Servicio] ADD [ProveedorId] INT NULL;
    PRINT 'Tbl_Presupuesto_Orden_Servicio.ProveedorId agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Presupuesto_Orden_Servicio') AND name = 'VehiculoId')
BEGIN
    ALTER TABLE [Tbl_Presupuesto_Orden_Servicio] ADD [VehiculoId] INT NULL;
    PRINT 'Tbl_Presupuesto_Orden_Servicio.VehiculoId agregada';
END
GO

-- Detalle Orden — VendedorId
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Orden_Servicio_Detalle') AND name = 'VendedorId')
BEGIN
    ALTER TABLE [Tbl_Orden_Servicio_Detalle] ADD [VendedorId] INT NULL;
    PRINT 'Tbl_Orden_Servicio_Detalle.VendedorId agregada';
END
GO

-- Detalle Orden Integracion — OrdenServicioId y BodegaId
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Orden_Servicio_Detalle_Integracion') AND name = 'OrdenServicioId')
BEGIN
    ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion] ADD [OrdenServicioId] INT NULL;
    PRINT 'Tbl_Orden_Servicio_Detalle_Integracion.OrdenServicioId agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Orden_Servicio_Detalle_Integracion') AND name = 'BodegaId')
BEGIN
    ALTER TABLE [Tbl_Orden_Servicio_Detalle_Integracion] ADD [BodegaId] INT NULL;
    PRINT 'Tbl_Orden_Servicio_Detalle_Integracion.BodegaId agregada';
END
GO

-- Detalle Presupuesto — VendedorId y PresupuestoId
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('tbl_presupuesto_orden_servicio_detalle') AND name = 'VendedorId')
BEGIN
    ALTER TABLE [tbl_presupuesto_orden_servicio_detalle] ADD [VendedorId] INT NULL;
    PRINT 'tbl_presupuesto_orden_servicio_detalle.VendedorId agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('tbl_presupuesto_orden_servicio_detalle') AND name = 'PresupuestoId')
BEGIN
    ALTER TABLE [tbl_presupuesto_orden_servicio_detalle] ADD [PresupuestoId] INT NULL;
    PRINT 'tbl_presupuesto_orden_servicio_detalle.PresupuestoId agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion') AND name = 'PresupuestoId')
BEGIN
    ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion] ADD [PresupuestoId] INT NULL;
    PRINT 'Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion.PresupuestoId agregada';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion') AND name = 'BodegaId')
BEGIN
    ALTER TABLE [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion] ADD [BodegaId] INT NULL;
    PRINT 'Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion.BodegaId agregada';
END
GO

-- ============================================================
-- PASO 3 — Poblar FKs surrogate desde claves naturales
-- Solo afecta filas existentes — nuevas filas las llenará EF.
-- ============================================================

-- OrdenServicio → Vehiculo (join por Num_Placa + Id_Empresa)
UPDATE os
SET os.[VehiculoId] = v.[Id]
FROM [Tbl_Orden_Servicio] os
JOIN [Tbl_Vehiculos] v
  ON v.[Num_Placa] = os.[Num_Placa]
 AND v.[Id_Empresa] = os.[Id_Empresa]
WHERE os.[VehiculoId] IS NULL;
PRINT CONCAT('Vehiculos enlazados a OS: ', @@ROWCOUNT);
GO

-- OrdenServicio → Proveedor/Cliente (join por Nit + Id_Empresa)
UPDATE os
SET os.[ProveedorId] = p.[Id]
FROM [Tbl_Orden_Servicio] os
JOIN [Tbl_Proveedores] p
  ON p.[Nit] = os.[Nit]
 AND p.[Id_Empresa] = os.[Id_Empresa]
WHERE os.[ProveedorId] IS NULL;
PRINT CONCAT('Clientes enlazados a OS: ', @@ROWCOUNT);
GO

-- Presupuesto → Vehiculo
UPDATE pos
SET pos.[VehiculoId] = v.[Id]
FROM [Tbl_Presupuesto_Orden_Servicio] pos
JOIN [Tbl_Vehiculos] v
  ON v.[Num_Placa] = pos.[Num_Placa]
 AND v.[Id_Empresa] = pos.[Id_Empresa]
WHERE pos.[VehiculoId] IS NULL;
PRINT CONCAT('Vehiculos enlazados a Presupuestos: ', @@ROWCOUNT);
GO

-- Presupuesto → Proveedor
UPDATE pos
SET pos.[ProveedorId] = p.[Id]
FROM [Tbl_Presupuesto_Orden_Servicio] pos
JOIN [Tbl_Proveedores] p
  ON p.[Nit] = pos.[Nit]
 AND p.[Id_Empresa] = pos.[Id_Empresa]
WHERE pos.[ProveedorId] IS NULL;
PRINT CONCAT('Clientes enlazados a Presupuestos: ', @@ROWCOUNT);
GO

-- Detalle OS → OS (join por Id_Empresa + Id_Orden)
UPDATE d
SET d.[OrdenServicioId] = os.[Id]
FROM [Tbl_Orden_Servicio_Detalle_Integracion] d
JOIN [Tbl_Orden_Servicio] os
  ON os.[Id_Empresa] = d.[Id_Empresa]
 AND CAST(os.[Id_Orden] AS VARCHAR) = d.[Id_Orden]
WHERE d.[OrdenServicioId] IS NULL;
PRINT CONCAT('Insumos enlazados a OS: ', @@ROWCOUNT);
GO

-- ============================================================
-- PASO 4 — Crear tablas de ASP.NET Identity (solo si no existen)
-- Estas tablas son nuevas — no existían en el sistema VFP.
-- ============================================================

IF OBJECT_ID('AspNetRoles') IS NULL
BEGIN
    CREATE TABLE [AspNetRoles] (
        [Id]               NVARCHAR(450)  NOT NULL,
        [Name]             NVARCHAR(256)  NULL,
        [NormalizedName]   NVARCHAR(256)  NULL,
        [ConcurrencyStamp] NVARCHAR(MAX)  NULL,
        CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
    );
    CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;
    PRINT 'AspNetRoles creada';
END
GO

IF OBJECT_ID('AspNetUsers') IS NULL
BEGIN
    CREATE TABLE [AspNetUsers] (
        [Id]                   NVARCHAR(450)  NOT NULL,
        [UserName]             NVARCHAR(256)  NULL,
        [NormalizedUserName]   NVARCHAR(256)  NULL,
        [Email]                NVARCHAR(256)  NULL,
        [NormalizedEmail]      NVARCHAR(256)  NULL,
        [EmailConfirmed]       BIT            NOT NULL,
        [PasswordHash]         NVARCHAR(MAX)  NULL,
        [SecurityStamp]        NVARCHAR(MAX)  NULL,
        [ConcurrencyStamp]     NVARCHAR(MAX)  NULL,
        [PhoneNumber]          NVARCHAR(MAX)  NULL,
        [PhoneNumberConfirmed] BIT            NOT NULL,
        [TwoFactorEnabled]     BIT            NOT NULL,
        [LockoutEnd]           DATETIMEOFFSET NULL,
        [LockoutEnabled]       BIT            NOT NULL,
        [AccessFailedCount]    INT            NOT NULL,
        [IdEmpresa]            INT            NOT NULL DEFAULT 0,
        [Periodo]              NVARCHAR(MAX)  NOT NULL DEFAULT '',
        [IdCaja]               INT            NOT NULL DEFAULT 0,
        CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
    );
    CREATE UNIQUE INDEX [UserNameIndex]  ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;
    CREATE INDEX        [EmailIndex]     ON [AspNetUsers] ([NormalizedEmail]);
    PRINT 'AspNetUsers creada';
END
GO

IF OBJECT_ID('AspNetUserRoles') IS NULL
BEGIN
    CREATE TABLE [AspNetUserRoles] (
        [UserId] NVARCHAR(450) NOT NULL,
        [RoleId] NVARCHAR(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
        CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers]([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);
    PRINT 'AspNetUserRoles creada';
END
GO

IF OBJECT_ID('AspNetUserClaims') IS NULL
BEGIN
    CREATE TABLE [AspNetUserClaims] (
        [Id]         INT           IDENTITY(1,1) NOT NULL,
        [UserId]     NVARCHAR(450) NOT NULL,
        [ClaimType]  NVARCHAR(MAX) NULL,
        [ClaimValue] NVARCHAR(MAX) NULL,
        CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);
    PRINT 'AspNetUserClaims creada';
END
GO

IF OBJECT_ID('AspNetRoleClaims') IS NULL
BEGIN
    CREATE TABLE [AspNetRoleClaims] (
        [Id]         INT           IDENTITY(1,1) NOT NULL,
        [RoleId]     NVARCHAR(450) NOT NULL,
        [ClaimType]  NVARCHAR(MAX) NULL,
        [ClaimValue] NVARCHAR(MAX) NULL,
        CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);
    PRINT 'AspNetRoleClaims creada';
END
GO

IF OBJECT_ID('AspNetUserLogins') IS NULL
BEGIN
    CREATE TABLE [AspNetUserLogins] (
        [LoginProvider]       NVARCHAR(450) NOT NULL,
        [ProviderKey]         NVARCHAR(450) NOT NULL,
        [ProviderDisplayName] NVARCHAR(MAX) NULL,
        [UserId]              NVARCHAR(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
        CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);
    PRINT 'AspNetUserLogins creada';
END
GO

IF OBJECT_ID('AspNetUserTokens') IS NULL
BEGIN
    CREATE TABLE [AspNetUserTokens] (
        [UserId]        NVARCHAR(450) NOT NULL,
        [LoginProvider] NVARCHAR(450) NOT NULL,
        [Name]          NVARCHAR(450) NOT NULL,
        [Value]         NVARCHAR(MAX) NULL,
        CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
        CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers]([Id]) ON DELETE CASCADE
    );
    PRINT 'AspNetUserTokens creada';
END
GO

-- Tabla de historial de migraciones EF (puede ya existir si se creó en otro BD)
IF OBJECT_ID('__EFMigrationsHistory') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId]    NVARCHAR(150) NOT NULL,
        [ProductVersion] NVARCHAR(32)  NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
    PRINT '__EFMigrationsHistory creada';
END
GO

-- ============================================================
-- PASO 5 — Registrar la migración EF como ya aplicada
-- Esto evita que "dotnet ef database update" intente re-crear
-- las tablas VFP que ya existen en la base de datos.
-- ============================================================

IF NOT EXISTS (
    SELECT 1 FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = '20260618210837_InitialSchema')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES ('20260618210837_InitialSchema', '10.0.9');
    PRINT 'Migración inicial registrada en __EFMigrationsHistory';
END
GO

PRINT '=== Script completado exitosamente ===';
PRINT 'Siguiente paso: dotnet ef database update (en ControlVehiculos.API)';
PRINT 'Esto solo ejecutará migraciones posteriores a InitialSchema.';
GO
