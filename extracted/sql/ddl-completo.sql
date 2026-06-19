CREATE TABLE [__EFMigrationsHistory] (
  [MigrationId] nvarchar(150) NOT NULL,
  [ProductVersion] nvarchar(32) NOT NULL
);
GO
CREATE TABLE [bodega] (
  [IdBodega] int IDENTITY(1,1) NOT NULL,
  [NombreBodega] nvarchar(100) NOT NULL,
  [EmpresaIdEmpresa] int NOT NULL
);
GO
CREATE TABLE [Cliente] (
  [IdCliente] int IDENTITY(1,1) NOT NULL,
  [NIT] nvarchar(20) NULL,
  [FacturarA] nvarchar(200) NULL,
  [Direccion] varchar(200) NULL,
  [Municipio] varchar(50) NULL,
  [Departamento] varchar(50) NULL,
  [Telefono1] varchar(20) NULL,
  [Telefono2] varchar(20) NULL,
  [Fecha_Ult_Movimiento] datetime NULL,
  [CorreoElectronico] varchar(100) NULL,
  [Tipo_PrecioVta] char(1) NULL,
  [EmpresaIdEmpresa] int NOT NULL,
  [Estado] bit NULL
);
GO
CREATE TABLE [Color] (
  [IdColor] int IDENTITY(1,1) NOT NULL,
  [NombreColor] nvarchar(100) NOT NULL,
  [EmpresaIdEmpresa] int NOT NULL
);
GO
CREATE TABLE [Empleado] (
  [IdTblEmpleado] int NOT NU
