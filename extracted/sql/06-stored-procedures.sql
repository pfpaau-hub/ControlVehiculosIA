-- ============================================
-- SP: rpt_lista_marca
-- ============================================
create procedure [dbo].[rpt_lista_marca] as
 
select IdMarcaVehiculo,MarcaVehiculo from [dbo].[Marca]
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
-- ============================================
-- SP: sp_alterdiagram
-- ============================================

	CREATE PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
-- ============================================
-- SP: sp_buscar_cliente
-- ============================================
CREATE procedure [dbo].[sp_buscar_cliente] as
select NIT,FacturarA from [dbo].[Cliente]
where estado=1
order by FacturarA
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
-- ============================================
-- SP: sp_buscar_lineavehiculo
-- ============================================
create procedure [dbo].[sp_buscar_lineavehiculo] as


select IdLinea,LineaVehiculo from [dbo].[Linea]
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
-- ============================================
-- SP: sp_buscar_placa
-- ============================================
CREATE procedure sp_buscar_placa @Placa nvarchar(10) as
select  NumPlaca from Vehiculo
where NumPlaca=@Placa 
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
-- ============================================
-- SP: sp_buscar_vehiculocliente
-- ============================================
CREATE procedure [dbo].[sp_vehiculo_cliente]  @NIT varchar(20) as

select v.IdVehiculo ,
v.NumPlaca
from Vehiculo v inner join Cliente k
on v.NIT=k.NIT
where k.nit=@NIT 



GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
-- ============================================
-- SP: sp_creatediagram
-- ============================================

	CREATE PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
-- ============================================
-- SP: sp_devuelve_NumOServicio
-- ============================================
CREATE procedure sp_devuelve_NumOServicio @Fecha_Inicial datetime, @Fecha_Final datetime as
declare @veces  int
SET DATEFORMAT DMY

SELECT count(*)  as Numero FROM  [dbo].[OrdenServicio]
where datediff(day,fechaorden,@Fecha_Inicial) 
between 0 and datediff(day,@Fecha_Inicial,@Fecha_Final)
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
-- ============================================
-- SP: sp_dropdiagram
-- ============================================

	CREATE PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
-- ============================================
-- SP: sp_eliminacliente
-- ============================================
create procedure sp_eliminacliente @IdCliente int as
begin
 Delete from cliente where IdCliente=@IdCliente
end
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
-- ============================================
-- SP: sp_eliminacolor
-- ============================================
CREATE procedure [dbo].[sp_eliminacolor] @IdColor int as
begin

 Delete from Color where IdColor=@IdColor
end
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
-- ============================================
-- SP: sp_eliminamarca
-- ============================================
create procedure [dbo].[sp_eliminamarca] @IdMarca int as
begin

 Delete from Marca where IdMarcaVehiculo=@IdMarca
end
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
-- ============================================
-- SP: sp_eliminamecanico
-- ============================================
CREATE procedure sp_eliminamecanico @IdMecanico int as
delete from Mecanico
where IdMecanico=@IdMecanico 

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
-- ============================================
-- SP: sp_eliminatipovehiculo
-- ============================================
create procedure [dbo].[sp_eliminatipovehiculo] @IdTipo int as
begin

 Delete from TipoVehiculo where IdTipoVehiculo=@IdTipo 
end
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
-- ============================================
-- SP: sp_eliminavehiculo
-- ============================================
create procedure [dbo].[sp_eliminavehiculo] @IdVehiculo int as
begin
select *from Vehiculo
 Delete from Vehiculo where IdVehiculo=@IdVehiculo  
end
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
-- ============================================
-- SP: sp_helpdiagramdefinition
-- ============================================

	CREATE PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
-- ============================================
-- SP: sp_helpdiagrams
-- ============================================

	CREATE PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
-- ============================================
-- SP: sp_insertabodega
-- ============================================
create procedure sp_insertabodega(
@XmlFactura xml )
as
insert into bodega(NombreBodega,EmpresaIdEmpresa)
select
    nodo.elemento.value('NombreBodega[1]','varchar(100)')[NombreBodega],
	nodo.elemento.value('EmpresaIdEmpresa[1]','int')[IdEmpresa]
from  @xmlFactura.nodes('DatosCertificados[1]') nodo(elemento)


GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
-- ============================================
-- SP: sp_insertacliente
-- ============================================
CREATE procedure [dbo].[sp_insertacliente](
@ClienteXml xml	 )
as
declare @IdCliente int
select  @IdCliente= nodo.elemento.value('IdCliente[1]','int')
from  @ClienteXml.nodes('Cliente') nodo(elemento)

--Si es @IdCliente=0, no tiene ID es nuevo
if @IdCliente = 0
begin
insert into Cliente(NIT,FacturarA,Direccion,Municipio,Departamento,Telefono1,Telefono2,CorreoElectronico,Tipo_PrecioVta,EmpresaIdEmpresa,Estado)
select
    nodo.elemento.value('NIT[1]','nvarchar(20)') As NIT,
	nodo.elemento.value('FacturarA[1]','nvarchar(20)') as FacturarA,
	nodo.elemento.value('Direccion[1]','varchar(200)') as Direccion,
	nodo.elemento.value('Municipio[1]','varchar(50)') as Municipio,
	nodo.elemento.value('Departamento[1]','varchar(50)') as Departamento,
	nodo.elemento.value('Telefono1[1]','varchar(20)') as Telefono1,
	nodo.elemento.value('Telefono2[1]','varchar(20)') as Telefono2,
	nodo.elemento.value('CorreoElectronico[1]','varchar(100)') as CorreoElectronico,
	nodo.elemento.value('Tipo_PrecioVta[1]','varchar(1)') as Tipo_PrecioVta,
	nodo.elemento.value('EmpresaIdEmpresa[1]','int') as Empresa,
	1

from  @ClienteXml.nodes('Cliente') nodo(elemento)
end
else begin
	declare @NIT nvarchar(20),
			@FacturarA nvarchar(200),
			@Direccion varchar(200),
			@Municipio varchar(50),
			@Departamento varchar(50),
			@Telefono1 varchar(20),
			@Telefono2 varchar(20),
			@CorreoElectronico varchar(100),
			@Tipo_PrecioVta char(1)

	select
		@NIT=nodo.elemento.value('NIT[1]','nvarchar(20)') ,
		@FacturarA= nodo.elemento.value('FacturarA[1]','nvarchar(20)') ,
		@Direccion=nodo.elemento.value('Direccion[1]','varchar(200)') ,
		@Municipio=nodo.elemento.value('Municipio[1]','varchar(50)') ,
		@Departamento=nodo.elemento.value('Departamento[1]','varchar(50)') ,
		@Telefono1=nodo.elemento.value('Telefono1[1]','varchar(20)') ,
		@Telefono2=nodo.elemento.value('Telefono2[1]','varchar(20)') ,
		@CorreoElectronico=nodo.elemento.value('CorreoElectronico[1]','varchar(100)') ,
		@Tipo_PrecioVta=nodo.elemento.value('Tipo_PrecioVta[1]','varchar(1)') 
		

	from  @ClienteXml.nodes('Cliente') nodo(elemento)

		update Cliente set	NIT=@NIT,
							FacturarA=@FacturarA,
							Direccion=@Direccion,
							Municipio=@Municipio,
							Departamento=@Departamento,
							Telefono1=@Telefono1,
							Telefono2=@Telefono2,
							CorreoElectronico=@CorreoElectronico,
							Tipo_PrecioVta=@Tipo_PrecioVta

						WHERE 	IdCliente=@IdCliente 
		
	end

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
-- ============================================
-- SP: sp_insertacolor
-- ============================================


CREATE procedure [dbo].[sp_insertacolor](
@ColorXml xml	 )
as
--insert tblprueba 
--select @ColorXml




declare @IdColor int
select  @IdColor= nodo.elemento.value('IdColor[1]','int')
from  @ColorXml.nodes('ColorVehiculo') nodo(elemento)

declare @archivo xml
set @archivo= '<ColorVehiculo><IdColor>0</IdColor><Nombrecolor>AZUL</Nombrecolor><EmpresaIdEmpresa>1</EmpresaIdEmpresa></ColorVehiculo>'
select
    
	nodo.elemento.value('NombreColor[1]','nvarchar(100)') as NombreColor,
	nodo.elemento.value('EmpresaIdEmpresa[1]','int') as Empresa

from  @archivo.nodes('ColorVehiculo') nodo(elemento)



--Si es @IdCliente=0, no tiene ID es nuevo
if @IdColor = 0
begin
insert into Color(NombreColor,EmpresaIdEmpresa)
select
    
	nodo.elemento.value('NombreColor[1]','nvarchar(100)') as NombreColor,
	nodo.elemento.value('EmpresaIdEmpresa[1]','int') as Empresa

from  @ColorXml.nodes('ColorVehiculo') nodo(elemento)
end
else begin
	declare @NombreColor nvarchar(100)
			
	select
		@IdColor=nodo.elemento.value('IdColor[1]','int') ,
		@NombreColor=nodo.elemento.value('NombreColor[1]','nvarchar(100)')  

	from  @ColorXml.nodes('ColorVehiculo') nodo(elemento)	
		update Color set	NombreColor=@NombreColor

						WHERE 	IdColor=@IdColor
		
	end

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
-- ============================================
-- SP: sp_insertamarca
-- ============================================

CREATE procedure [dbo].[sp_insertamarca](
@MarcaXml xml	 )
as
insert tblprueba 
select @MarcaXml

select *from tblprueba
select *from Linea

declare @IdMarca int,
		@MarcaVehiculo nvarchar(max),
		@EmpresaIdEmpresa int
select  @IdMarca= nodo.elemento.value('IdMarcaVehiculo[1]','int')
from  @MarcaXml.nodes('MarcaVehiculo') nodo(elemento)

--declare @archivo xml
--set @archivo= '<ColorVehiculo><IdColor>0</IdColor><Nombrecolor>AZUL</Nombrecolor><EmpresaIdEmpresa>1</EmpresaIdEmpresa></ColorVehiculo>'
--select
    
--	nodo.elemento.value('MarcaVehiculo[1]','nvarchar(100)') as NombreColor,
--	nodo.elemento.value('EmpresaIdEmpresa[1]','int') as Empresa

--from  @archivo.nodes('MarcaVehiculo') nodo(elemento)



--Si es @IdCliente=0, no tiene ID es nuevo
if @IdMarca = 0
begin
	insert into Marca(MarcaVehiculo,EmpresaIdEmpresa)
	select
    
		nodo.elemento.value('MarcaVehiculo[1]','nvarchar(100)') as MarcaVehiculo,
		nodo.elemento.value('EmpresaIdEmpresa[1]','int') as Empresa

	from  @MarcaXml.nodes('MarcaVehiculo') nodo(elemento)

	select
		@IdMarca=nodo.elemento.value('IdMarcaVehiculo[1]','int') 
	from  @MarcaXml.nodes('MarcaVehiculo') nodo(elemento)

	insert into Linea(LineaVehiculo,IdMarcaVehiculo)
		select nodo.elemento.value('LineaVehiculo[1]','nvarchar(50)'),
		@@IDENTITY
	from @MarcaXml.nodes('MarcaVehiculo/LineaVehiculos/Item') nodo(elemento) 


	select nodo.elemento.value('LineaVehiculo[1]','nvarchar(50)'),
	@IdMarca
	from @MarcaXml.nodes('LineaVehiculos') nodo(elemento) 

end
else begin

	declare @IdLinea int,
			@LineaVehiculo nvarchar(50)			
	select
		@IdMarca=nodo.elemento.value('IdMarcaVehiculo[1]','int') ,
		@MarcaVehiculo=nodo.elemento.value('MarcaVehiculo[1]','nvarchar(100)') ,
		@EmpresaIdEmpresa=nodo.elemento.value('EmpresaIdEmpresa[1]','int')

	from  @MarcaXml.nodes('MarcaVehiculo') nodo(elemento)	
		update Marca set	MarcaVehiculo=@MarcaVehiculo 

						WHERE 	IdMarcaVehiculo=@IdMarca
	
	---INSERTANTO EN LA TABLA DETALLE TEMPORAL
	

	--insert tblprueba2
	--select	nodo.elemento.value('Linea[1]','int'),
	--		nodo.elemento.value('LineaVehiculo[1]','nvarchar(50)')
	--from @MarcaXml.nodes('MarcaVehiculo/LineaVehiculos/Item') nodo(elemento) 

	declare detalle cursor for
	select	nodo.elemento.value('Linea[1]','int'),
			nodo.elemento.value('LineaVehiculo[1]','nvarchar(50)')
	from @MarcaXml.nodes('MarcaVehiculo/LineaVehiculos/Item') nodo(elemento) 
	open detalle
	fetch detalle into @Idlinea,@LineaVehiculo 
	while @@FETCH_STATUS=0
	begin
	insert tblprueba2
	select @IdLinea,@LineaVehiculo

		IF @Idlinea=0
		begin
			insert linea
			select @LineaVehiculo,@IdMarca
		end
		else begin
			update linea set LineaVehiculo=@LineaVehiculo where idlinea=@IdLinea 
			end
		fetch detalle into @Idlinea,@LineaVehiculo 
	end
	close detalle
	deallocate detalle
	
	end



GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
-- ============================================
-- SP: sp_insertamecanico
-- ============================================


CREATE  procedure [dbo].[sp_insertamecanico] @MecanicoXml xml as
declare @IdMecanico int,
		@Nombre nvarchar(100),
		@Comision int,
		@EmpresaIdEmpresa int

insert TblPrueba
select @MecanicoXml

select  @IdMecanico= nodo.elemento.value('IdMecanico[1]','int')
from  @MecanicoXml.nodes('Mecanico') nodo(elemento)

if @IdMecanico=0
begin

	insert into Mecanico(Nombre,Comision,EmpresaIdEmpresa)
	select   nodo.elemento.value('Nombre[1]','nVarchar(100)'),
			nodo.elemento.value('Comision[1]','int'),
			nodo.elemento.value('EmpresaIdEmpresa[1]','int')
	from  @MecanicoXml.nodes('Mecanico') nodo(elemento)
end
else begin
		--modificacion
		select  @Nombre=nodo.elemento.value('Nombre[1]','nVarchar(100)'),
				@Comision=nodo.elemento.value('Comision[1]','int'),
				@EmpresaIdEmpresa=nodo.elemento.value('EmpresaIdEmpresa[1]','int')
		from  @MecanicoXml.nodes('Mecanico') nodo(elemento)


		update Mecanico set Nombre=@Nombre,
							Comision=@Comision,		
							EmpresaIdEmpresa=@EmpresaIdEmpresa
		where IdMecanico=@IdMecanico 
	 end
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
-- ============================================
-- SP: sp_insertapresupuesto
-- ============================================
CREATE  procedure [dbo].[sp_insertapresupuesto] @PresupuestoXml xml as
declare @IdPresupuesto int,
		@NIT varchar(20),
		@Direccion varchar(200),
		@Fecha datetime,
		@IdVehiculo int,
		@Estado varchar(10),
		@Observaciones varchar(300)


insert TblPrueba
select @PresupuestoXml

select  @IdPresupuesto= nodo.elemento.value('IdPresupuesto[1]','int')
from  @PresupuestoXml.nodes('Presupuesto') nodo(elemento)


print 'prsupuesto'
print @IdPresupuesto
if @IdPresupuesto=0
begin
	insert tblprueba
	select 'idpresupuestoes cero'





	insert into Presupuesto(NIT,Direccion,Fecha, Estado,IdVehiculo,Observaciones)
	select   nodo.elemento.value('NIT[1]','Varchar(20)'),
			nodo.elemento.value('Direccion[1]','varchar(200)'),
			nodo.elemento.value('Fecha[1]','datetime'),
			nodo.elemento.value('Estado[1]','varchar(10)'),
			nodo.elemento.value('IdVehiculo[1]','int'),
			nodo.elemento.value('Observaciones[1]','varchar(300)')
	from  @PresupuestoXml.nodes('Presupuesto') nodo(elemento)

	print 'identity'
	print @@identity


select 

  
  nodo.elemento.value('Descripcion[1]', 'varchar(250)') as Descripcion,
  nodo.elemento.value('Cantidad[1]', 'decimal(28,2)') as Cantidad,
  nodo.elemento.value('Precio[1]', 'decimal(18,2)') as Precio,
  @@IDENTITY,  
  nodo.elemento.value('IdProducto[1]', 'int') as Producto
from @Presupuestoxml.nodes('Presupuesto/DetallePresupuesto/Item') nodo(elemento)




	insert PresupuestoDetalle


select 

  
  nodo.elemento.value('Descripcion[1]', 'varchar(250)') as Descripcion,
  nodo.elemento.value('Cantidad[1]', 'decimal(28,2)') as Cantidad,
  nodo.elemento.value('Precio[1]', 'decimal(18,2)') as Precio,
  @@IDENTITY,  
  nodo.elemento.value('IdProducto[1]', 'int') as Producto
from @Presupuestoxml.nodes('Presupuesto/DetallePresupuesto/Item') nodo(elemento)





end
else begin
		insert tblprueba
		select 'presupuesto no es cero'
		--modificacion
		select  @NIT=nodo.elemento.value('NIT[1]','Varchar(20)'),
				@Direccion=nodo.elemento.value('Direccion[1]','varchar(200)')

				
		from  @PresupuestoXml.nodes('Presupuesto') nodo(elemento)


		update Presupuesto set NIT=@NIT,
							Direccion=@Direccion,		
							Fecha=@Fecha,
							Estado=@Estado,
							Observaciones=@Observaciones
		where IdPresupuesto=@IdPresupuesto 
	 end
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
-- ============================================
-- SP: sp_insertatipovehiculo
-- ============================================


Create procedure [dbo].sp_insertatipovehiculo(
@TipoXml xml	 )
as
--insert tblprueba 
--select @ColorXml


declare @IdTipo int
select  @IdTipo= nodo.elemento.value('IdTipoVehiculo[1]','int')
from  @TipoXml.nodes('TipoVehiculo') nodo(elemento)

--//declare @archivo xml
--//set @archivo= '<ColorVehiculo><IdColor>0</IdColor><Nombrecolor>AZUL</Nombrecolor><EmpresaIdEmpresa>1</EmpresaIdEmpresa></ColorVehiculo>'
--select
    
--	nodo.elemento.value('NombreColor[1]','nvarchar(100)') as NombreColor,
--	nodo.elemento.value('EmpresaIdEmpresa[1]','int') as Empresa

--from  @archivo.nodes('ColorVehiculo') nodo(elemento)



--Si es @IdCliente=0, no tiene ID es nuevo
if @IdTipo = 0
begin
insert into TipoVehiculo(EstiloVehiculo)
select
    
	nodo.elemento.value('EstiloVehiculo[1]','nvarchar(50)') as EstiloVehiculo

from  @TipoXml.nodes('TipoVehiculo') nodo(elemento)
end
else begin
	declare @EstiloVehiculo nvarchar(50)
			
	select
		@IdTipo=nodo.elemento.value('IdTipoVehiculo[1]','int') ,
		@EstiloVehiculo=nodo.elemento.value('EstiloVehiculo[1]','nvarchar(50)')  

	from  @TipoXml.nodes('TipoVehiculo') nodo(elemento)	
		update TipoVehiculo set	EstiloVehiculo=@EstiloVehiculo

						WHERE 	IdTipoVehiculo=@IdTipo
		
	end

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
-- ============================================
-- SP: sp_insertavehiculo
-- ============================================
--USE [Db_Control_Automotriz]
--GO
--/****** Object:  StoredProcedure [dbo].[sp_insertavehiculo]    Script Date: 17/06/2025 21:11:02 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--declare @VEHICULOXml xml
--set @VEHICULOXml='<Vehiculo>
--  <IdVehiculo>12</IdVehiculo>
--  <NIT>6603696</NIT>
--  <NumPlaca>3333</NumPlaca>
--  <TipoVehiculoIdTipoVehiculo>1</TipoVehiculoIdTipoVehiculo>
--  <IdLinea>1005</IdLinea>
--  <Modelo>2020</Modelo>
--  <Puertas>4</Puertas>
--  <Cilindros>4</Cilindros>
--  <Motor>2.0</Motor>
--  <UnidadMedida>Millas</UnidadMedida>
--  <Presionllantas>44</Presionllantas>
--  <MotorDe>Diesel</MotorDe>
--  <ServicioCada>3000</ServicioCada>
--  <EmpresaIdEmpresa>1</EmpresaIdEmpresa>
--</Vehiculo>'
--declare @NIT nvarchar(max),
--			@NumPlaca nvarchar(10),
--			@IdLinea int,
--			@Modelo nvarchar(4),
--			@Puertas int,
--			@Cilindros int,
--			@Motor nvarchar(25),
--			@UnidadMedida nvarchar(max),
--			@PresionLlantas int,
--			@MotorDe nvarchar(10),
--			@ServicioCada nvarchar(5),
--			@TipoVehiculoIdTipoVehiculo int

--	select
--		nodo.elemento.value('NIT[1]','nvarchar(max)') ,
--		nodo.elemento.value('NumPlaca[1]','nvarchar(10)') ,
--		nodo.elemento.value('IdLinea[1]','int'),
--		 nodo.elemento.value('IdLinea[1]','int'),
--		 nodo.elemento.value('Modelo[1]','nvarchar(4)'),
--		 nodo.elemento.value('Puertas[1]','int'),
--		 nodo.elemento.value('Cilindros[1]','int'),
--		 nodo.elemento.value('Motor[1]','nvarchar(25)'),
--		nodo.elemento.value('UnidadMedida[1]','nvarchar(max)'),
--		nodo.elemento.value('Presionllantas[1]','int'),
		
	
--		nodo.elemento.value('ServicioCada[1]','nvarchar(5)'),
--		nodo.elemento.value('TipoVehiculoIdTipoVehiculo[1]','int')

--	from  @VehiculoXml.nodes('Vehiculo') nodo(elemento)	



--	select
--		@NIT=nodo.elemento.value('NIT[1]','nvarchar(max)') ,
--		@NumPlaca=nodo.elemento.value('NumPlaca[1]','nvarchar(10)') ,
--		@IdLinea = nodo.elemento.value('IdLinea[1]','int'),
--		@IdLinea = nodo.elemento.value('IdLinea[1]','int'),
--		@Modelo = nodo.elemento.value('Modelo[1]','nvarchar(4)'),
--		@Puertas = nodo.elemento.value('Puertas[1]','int'),
--		@Cilindros = nodo.elemento.value('Cilindros[1]','int'),
--		@Motor = nodo.elemento.value('Motor[1]','nvarchar(25)'),
--		@UnidadMedida=nodo.elemento.value('UnidadMedida[1]','nvarchar(max)'),
--		@PresionLlantas=nodo.elemento.value('Presionllantas[1]','int'),
		
--		@MotorDe=nodo.elemento.value('Motor[1]','int'),
--		@ServicioCada=nodo.elemento.value('ServicioCada[1]','nvarchar(5)'),
--		@TipoVehiculoIdTipoVehiculo=nodo.elemento.value('TipoVehiculoIdTipoVehiculo[1]','int')

--	from  @VehiculoXml.nodes('Vehiculo') nodo(elemento)	





--select * from tblprueba 
CREATE procedure [dbo].[sp_insertavehiculo](
@VehiculoXml xml	 )
as


insert tblprueba
select @VehiculoXml


declare @IdVehiculo int,
		@EmpresaIdEmpresa int
select  @IdVehiculo= nodo.elemento.value('IdVehiculo[1]','int')
from  @VehiculoXml.nodes('Vehiculo') nodo(elemento)




----Si es @IdCliente=0, no tiene ID es nuevo
if @IdVehiculo = 0
begin
	insert into Vehiculo(NumPlaca,IdLinea,Modelo,Puertas,Cilindros,Motor,UnidadMedida,PresionLlantes,MotorDe,ServicioCada,NIT,TipoVehiculoIdTipoVehiculo, EmpresaIdEmpresa,FechaUltMovimiento)
	select
		nodo.elemento.value('NumPlaca[1]','nvarchar(10)') as NumPlaca,
		nodo.elemento.value('IdLinea[1]','int') as IdLinea,
		nodo.elemento.value('Modelo[1]','nvarchar(4)') as Modelo,
		nodo.elemento.value('Puertas[1]','int') as Modelo,
		nodo.elemento.value('Cilindros[1]','int') as Cilidros,
		nodo.elemento.value('Motor[1]','nvarchar(25)') as Motor,
		nodo.elemento.value('UnidadMedida[1]','nvarchar(max)') as UnidadMedida,
		nodo.elemento.value('Presionllantas[1]','int') as PresionLlantas,
		nodo.elemento.valu
-- ============================================
-- SP: sp_lista_cliente
-- ============================================
CREATE procedure sp_lista_cliente as
select IdCliente,NIT,FacturarA,correoelectronico from [dbo].[Cliente]
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
-- ============================================
-- SP: sp_lista_color
-- ============================================
Create procedure [dbo].[sp_lista_color] as
 
select IdColor,NombreColor from [dbo].[Color]
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
-- ============================================
-- SP: sp_lista_linea
-- ============================================
Create procedure sp_lista_linea @IdMarcaVehiculo int as
SELECT  IdLinea,LineaVehiculo  FROM Linea WHERE IdMarcaVehiculo=@IdMarcaVehiculo

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
-- ============================================
-- SP: sp_lista_marca
-- ============================================

create procedure [dbo].[sp_lista_marca] as
 
select IdMarcaVehiculo,MarcaVehiculo from [dbo].[Marca]
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
-- ============================================
-- SP: sp_lista_mecanico
-- ============================================
CREATE procedure [dbo].[sp_lista_mecanico] as
 
select IdMecanico,Nombre,Comision from mecanico
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
-- ============================================
-- SP: sp_lista_presupuesto
-- ============================================
--sp_lista_presupuesto 
CREATE procedure [dbo].[sp_lista_presupuesto]  as

 

select	p.IdPresupuesto,
	p.Fecha,
		p.nit,
		 (select FacturarA from cliente where nit=v.nit) NombreCliente,
	
	
		
		v.NumPlaca,
			p.Estado
from presupuesto p inner join vehiculo v
on p.idVehiculo=v.IdVehiculo





GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
-- ============================================
-- SP: sp_lista_producto
-- ============================================
CREATE  procedure [dbo].[sp_lista_producto] as
 select idProducto,
 codigoproducto,
 DescripcionProducto,
 PrecioA
 from Producto

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
-- ============================================
-- SP: sp_lista_tipovehiculo
-- ============================================
create procedure [dbo].[sp_lista_tipovehiculo] as
 
select IdTipoVehiculo,EstiloVehiculo from [dbo].[TipoVehiculo]
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
-- ============================================
-- SP: sp_lista_vehiculo
-- ============================================
CREATE procedure sp_lista_vehiculo as
select v.IdVehiculo,
	   v.NumPlaca,
	   v.Idlinea,
	   (select LineaVehiculo from Linea where idlinea=v.idlinea) as LineaVehiculo,
	   v.Nit ,
	   (select FacturarA from cliente where nit=v.nit) NombreCliente
from Vehiculo v
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
-- ============================================
-- SP: sp_renamediagram
-- ============================================

	CREATE PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
-- ============================================
-- SP: sp_upgraddiagrams
-- ============================================

	CREATE PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            

(36 rows affected)
