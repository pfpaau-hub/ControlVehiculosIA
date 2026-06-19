-- TRIGGER: T_D_COLORES ON Tbl_colores
CREATE TRIGGER [dbo].[T_D_COLORES] ON [dbo].[Tbl_colores] 
FOR  DELETE 
AS
BEGIN
	    DECLARE          	 @row_count       INT,
			           	@error_number    INT,
			           @error_message   VARCHAR(255)

-- TRIGGER: T_D_empresas ON empresas
CREATE TRIGGER [dbo].[T_D_empresas] ON [dbo].[empresas] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(255)

    SELECT @r
-- TRIGGER: T_D_Tbl_Abonos ON Tbl_Abonos
CREATE TRIGGER [dbo].[T_D_Tbl_Abonos] ON [dbo].[Tbl_Abonos] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(255)

    S
-- TRIGGER: T_D_TBL_ANTICIPOS_CLIENTES ON Tbl_anticipos_clientes
CREATE TRIGGER [dbo].[T_D_TBL_ANTICIPOS_CLIENTES] ON [dbo].[Tbl_anticipos_clientes] 
FOR  DELETE 
AS
begin
	  DECLARE                   @row_count       INT,
		           @error_number 
-- TRIGGER: T_D_Tbl_articulos ON Tbl_articulos
CREATE TRIGGER [dbo].[T_D_Tbl_articulos] ON [dbo].[Tbl_articulos] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(2
-- TRIGGER: T_D_Tbl_bodega ON Tbl_bodega
CREATE TRIGGER [dbo].[T_D_Tbl_bodega] ON [dbo].[Tbl_bodega] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(255)

    S
-- TRIGGER: T_D_Tbl_Cab_Facturacion ON Tbl_Cab_Facturacion
/*  Delete Trigger 'T_D_Tbl_Cab_Facturacion' for Table 'Tbl_Cab_Facturacion'  */

CREATE TRIGGER [dbo].[T_D_Tbl_Cab_Facturacion] ON dbo.Tbl_Cab_Facturacion FOR DELETE AS

BEGIN
    DECLARE
 
-- TRIGGER: T_D_Tbl_Cab_Notas_credito ON Tbl_Cab_Notas_Credito





CREATE TRIGGER [dbo].[T_D_Tbl_Cab_Notas_credito] ON [dbo].[Tbl_Cab_Notas_Credito] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    IN
-- TRIGGER: T_D_Tbl_cabecera_movimientos ON Tbl_cabecera_movimientos
--alter table tbl_cabecera_movimientos enable trigger all

/*  Delete Trigger 'T_D_Tbl_cabecera_movimientos' for Table 'Tbl_cabecera_movimientos'  */
CREATE  TRIGGER [dbo].[T_D_Tbl_ca
-- TRIGGER: T_D_Tbl_Cajas ON Tbl_Cajas

CREATE TRIGGER [dbo].[T_D_Tbl_Cajas] ON [dbo].[Tbl_Cajas] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(255)

    SEL
-- TRIGGER: T_d_tbl_cargos ON Tbl_Cargos
CREATE TRIGGER [dbo].[T_d_tbl_cargos] ON dbo.Tbl_Cargos 
FOR  DELETE 
AS
begin
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(255)

    SE
-- TRIGGER: T_D_TBL_COBROS ON Tbl_cobros
CREATE TRIGGER [T_D_TBL_COBROS] ON dbo.Tbl_cobros 
FOR  DELETE  AS
BEGIN
	Declare @Id_empresa	int,
		@Id_Tipo_cobro	char(3),
		@Num_docto_cobro	int,
		@Linea			int


	select 	@Id_empresa		=	id_empresa,
		
-- TRIGGER: T_D_Tbl_cotizacion_clientes ON Tbl_cotizacion_clientes
CREATE TRIGGER [dbo].[T_D_Tbl_cotizacion_clientes] ON [dbo].[Tbl_cotizacion_clientes] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT
-- TRIGGER: t_d_tbl_cuentas_por_cobrar ON Tbl_cuentas_por_cobrar
CREATE TRIGGER [dbo].[t_d_tbl_cuentas_por_cobrar] ON [dbo].[Tbl_cuentas_por_cobrar] 
FOR  DELETE AS
begin
  DECLARE                   @row_count       INT,
		           @error_number    
-- TRIGGER: T_D_Tbl_departamentos ON Tbl_departamentos
CREATE TRIGGER [dbo].[T_D_Tbl_departamentos] ON [dbo].[Tbl_departamentos] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_mes
-- TRIGGER: T_D_Tbl_Det_Abonos ON Tbl_Det_Abonos
CREATE TRIGGER [T_D_Tbl_Det_Abonos] ON dbo.Tbl_Det_Abonos 
FOR DELETE 
AS


SET DATEFORMAT DMY

---actualizando el saldo de la factura cuando aplique el anticipo
Declare @Id_empresa		int,
	@Nit 			
-- TRIGGER: T_d_tbl_det_cobros ON Tbl_det_cobros
CREATE TRIGGER [dbo].[T_d_tbl_det_cobros] ON [dbo].[Tbl_det_cobros] 
FOR  DELETE AS
begin
	declare @valor_aplicado	numeric(12,2)
	select @valor_aplicado=valor_aplicado from deleted d
	update tbl_cabece
-- TRIGGER: T_D_TBL_DET_ENTREGA_DESPACHO ON tbl_det_entrega_despacho
CREATE   TRIGGER [dbo].[T_D_TBL_DET_ENTREGA_DESPACHO] ON [dbo].[tbl_det_entrega_despacho] 
FOR  DELETE 
AS
--DESACTUALIZA
DECLARE @ID_EMPRESA INT,@ID_SOLICITUD_DESPACHO INT, @ID_PROD
-- TRIGGER: T_D_Tbl_Det_Facturacion ON Tbl_Det_Facturacion



CREATE TRIGGER [dbo].[T_D_Tbl_Det_Facturacion] ON [dbo].[Tbl_Det_Facturacion] FOR DELETE AS
BEGIN
	DECLARE
	           @row_count       INT,
	           @null_row_count  INT,
	         
-- TRIGGER: T_D_TBL_DETALLE_ANTICIPOS_CLIENTES ON Tbl_detalle_anticipos_clientes
CREATE TRIGGER [T_D_TBL_DETALLE_ANTICIPOS_CLIENTES] ON [dbo].[Tbl_detalle_anticipos_clientes] 
FOR  DELETE AS

declare @Id_empresa int,@serie char(3),@tipo_docto char(3),@
-- TRIGGER: T_D_Tbl_Detalle_movimientos ON Tbl_Detalle_movimientos
CREATE TRIGGER [dbo].[T_D_Tbl_Detalle_movimientos] ON dbo.Tbl_Detalle_movimientos FOR DELETE AS

	DECLARE
        @row_count       INT,
		@null_row_count  INT,
		@error_number    INT,
-- TRIGGER: T_D_Tbl_Detalle_movimientos_sub ON Tbl_Detalle_movimientos_sub
CREATE TRIGGER [T_D_Tbl_Detalle_movimientos_sub] ON [dbo].[Tbl_Detalle_movimientos_sub] FOR DELETE AS
--TRIGUERS DELETE
    DECLARE
           @row_count       INT,
           
-- TRIGGER: T_D_Tbl_Materia_prima ON Tbl_Productos



/*  Delete Trigger 'T_D_Tbl_Materia_prima' for Table 'Tbl_Productos'  */

CREATE TRIGGER [dbo].[T_D_Tbl_Materia_prima] ON [dbo].[Tbl_Productos] FOR DELETE AS

BEGIN
    DECLARE
           @row
-- TRIGGER: t_d_tbl_orden_compra_proyecto_detalle ON Tbl_Orden_Compra_Proyecto_Detalle

create trigger dbo.t_d_tbl_orden_compra_proyecto_detalle on dbo.tbl_orden_compra_proyecto_detalle for delete as
begin
update tbl_rubro_proyecto set cantidad_pedida=
-- TRIGGER: T_D_Tbl_Orden_Servicio ON Tbl_Orden_Servicio
CREATE TRIGGER [dbo].[T_D_Tbl_Orden_Servicio] ON [dbo].[Tbl_Orden_Servicio] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error
-- TRIGGER: T_D_Tbl_Orden_Servicio_Detalle ON Tbl_Orden_Servicio_Detalle
CREATE TRIGGER [dbo].[T_D_Tbl_Orden_Servicio_Detalle] ON [dbo].[Tbl_Orden_Servicio_Detalle] FOR DELETE AS
begin
	DECLARE           @row_count       INT,
			 @error_number    INT,
-- TRIGGER: T_D_Tbl_Orden_Servicio_Detalle_Integracion ON Tbl_Orden_Servicio_Detalle_Integracion
CREATE TRIGGER [T_D_Tbl_Orden_Servicio_Detalle_Integracion] ON [dbo].[Tbl_Orden_Servicio_Detalle_Integracion] 
FOR  DELETE 
AS

Begin
	Declare @Costo_Tot
-- TRIGGER: T_D_Tbl_pedidos ON Tbl_pedidos
/*  Delete Trigger 'T_D_Tbl_pedidos' for Table 'Tbl_pedidos'  */

CREATE TRIGGER [dbo].[T_D_Tbl_pedidos] ON [dbo].[Tbl_pedidos] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           
-- TRIGGER: T_D_Tbl_Presupuesto_Orden_Servicio ON Tbl_Presupuesto_Orden_Servicio
CREATE TRIGGER [dbo].[T_D_Tbl_Presupuesto_Orden_Servicio] ON [dbo].[Tbl_Presupuesto_Orden_Servicio] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
   
-- TRIGGER: T_D_Tbl_presupuesto_Orden_Servicio_Detalle ON tbl_presupuesto_orden_servicio_detalle
CREATE TRIGGER [T_D_Tbl_presupuesto_Orden_Servicio_Detalle] ON [dbo].[tbl_presupuesto_orden_servicio_detalle] FOR DELETE AS
begin
	DECLARE           @row_co
-- TRIGGER: T_d_Tbl_produccion_diaria ON Tbl_produccion_diaria
CREATE TRIGGER [dbo].[T_d_Tbl_produccion_diaria] ON [dbo].[Tbl_produccion_diaria] FOR delete AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
     
-- TRIGGER: T_D_Tbl_Proveedores ON Tbl_Proveedores
CREATE TRIGGER [T_D_Tbl_Proveedores] ON dbo.Tbl_Proveedores FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(255
-- TRIGGER: T_D_Tbl_Rubro_proyecto ON Tbl_Rubro_Proyecto
/*  Insert Trigger 'T_I_Tbl_Rubro_proyecto' for Table 'Tbl_Rubro_proyecto'  */

CREATE TRIGGER [dbo].[T_D_Tbl_Rubro_proyecto] ON [dbo].[Tbl_Rubro_Proyecto] FOR DELETE AS

BEGIN
    DECLARE
   
-- TRIGGER: T_D_Tbl_Series ON Tbl_Series

CREATE TRIGGER [dbo].[T_D_Tbl_Series] ON [dbo].[Tbl_Series] FOR DELETE AS

BEGIN
    DECLARE   
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(255)


-- TRIGGER: T_D_Tbl_tbl_cajeros ON Tbl_Cajeros
CREATE  TRIGGER [dbo].[T_D_Tbl_tbl_cajeros] ON [dbo].[Tbl_Cajeros] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message   VARCHAR(
-- TRIGGER: T_D_Tbl_Tipos_Inv ON Tbl_Tipos_Inv
CREATE TRIGGER [dbo].[T_D_Tbl_Tipos_Inv] ON [dbo].[Tbl_Tipos_Inv] FOR DELETE AS

BEGIN
    DECLARE
           	@row_count       INT,
           	@error_number    INT,
           	@error_message   VARCHA
-- TRIGGER: T_D_Tbl_Unidad_Medida ON Tbl_Unidad_Medida
CREATE TRIGGER [T_D_Tbl_Unidad_Medida] ON [dbo].[Tbl_Unidad_Medida] FOR DELETE AS

BEGIN
    DECLARE
           @row_count       INT,
           @error_number    INT,
           @error_message  
-- TRIGGER: t_d_tbl_vehiculos ON Tbl_Vehiculos
create TRIGGER [t_d_tbl_vehiculos]  ON [dbo].[Tbl_Vehiculos] 
FOR DELETE  as

begin
	DECLARE
	           @row_count       INT,
	           @error_number    INT,
	           @error_message   VARCHAR(255
-- TRIGGER: T_I_EMPRESAS ON empresas
CREATE TRIGGER [dbo].[T_I_EMPRESAS] ON [dbo].[empresas] FOR insert AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
           @error_messa
-- TRIGGER: T_I_recepcion_pedidos ON Tbl_recepcion_pedidos








/*  Insert Trigger 'T_I_Tbl_bodega' for Table 'Tbl_bodega'  */

CREATE TRIGGER [dbo].[T_I_recepcion_pedidos] ON [dbo].[Tbl_recepcion_pedidos] FOR INSERT AS

BEGIN
    DECLARE
-- TRIGGER: T_I_recepcion_pedidos_detalle ON Tbl_recepcion_pedidos_detalle


CREATE TRIGGER [dbo].[T_I_recepcion_pedidos_detalle] ON [dbo].[Tbl_recepcion_pedidos_detalle] FOR INSERT AS
BEGIN
    DECLARE
           @row_count       INT,
           @n
-- TRIGGER: T_I_Tbl_Abonos ON Tbl_Abonos
CREATE TRIGGER [dbo].[T_I_Tbl_Abonos] ON [dbo].[Tbl_Abonos] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
           @err
-- TRIGGER: T_I_Tbl_articulos ON Tbl_articulos
CREATE TRIGGER [dbo].[T_I_Tbl_articulos] ON [dbo].[Tbl_articulos] FOR update AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
   
-- TRIGGER: T_I_Tbl_bodega ON Tbl_bodega
CREATE TRIGGER [dbo].[T_I_Tbl_bodega] ON [dbo].[Tbl_bodega] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
           @err
-- TRIGGER: T_I_Tbl_Cab_Facturacion ON Tbl_Cab_Facturacion
/*
--1. Crear campo nuevo
set dateformat dmy
update tbl_series_por_caja set fecha_ult_movimiento='12/06/2008' 
where id_caja=1
--2. modificar el trigger para que actualize la fecha del ultimo
-- TRIGGER: T_i_tbl_cab_generacion_compras ON Tbl_Cab_generacion_compras
CREATE TRIGGER [dbo].[T_i_tbl_cab_generacion_compras] ON [dbo].[Tbl_Cab_generacion_compras] FOR INSERT AS

begin

--Insert dbo.tbl_cabecera_movimientos
--select Id_empresa,perio
-- TRIGGER: T_I_Tbl_Cab_Notas_credito ON Tbl_Cab_Notas_Credito





/*  Insert Trigger 'T_I_Tbl_Cab_Notas_credito' for Table 'Tbl_Cab_Notas_credito'  */
CREATE TRIGGER [dbo].[T_I_Tbl_Cab_Notas_credito] ON [dbo].[Tbl_Cab_Notas_Credito] FOR  INSERT AS
-- TRIGGER: T_I_Tbl_cabecera_movimientos ON Tbl_cabecera_movimientos


/*  Insert Trigger 'T_I_Tbl_cabecera_movimientos' for Table 'Tbl_cabecera_movimientos'  */
CREATE TRIGGER [dbo].[T_I_Tbl_cabecera_movimientos] ON [dbo].[Tbl_cabecera_movimientos] FO
-- TRIGGER: T_I_Tbl_Cajas ON Tbl_Cajas
CREATE TRIGGER [dbo].[T_I_Tbl_Cajas] ON [dbo].[Tbl_Cajas] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
           @error_m
-- TRIGGER: T_I_TBL_CARGOS ON Tbl_Cargos
/*SELECT TOP 1 * INTO TMP_YOS FROM Tbl_Cargos WHERE Id_Empresa=1 AND Nit='?414259-3'           
SELECT *FROM TBL_CARGOS WHERE NIT='?414259-3' 
SELECT *FROM TBL_DET_ABONOS WHERE NIT='?414259-3' 
INSERT Tbl_Cargos
-- TRIGGER: T_I_TBL_COBROS ON Tbl_cobros
CREATE TRIGGER [T_I_TBL_COBROS] ON dbo.Tbl_cobros 
FOR INSERT
AS

BEGIN

	 DECLARE
	           @row_count       INT,
	           @null_row_count  INT,
	           @error_number    INT,
	           @error_
-- TRIGGER: T_I_Tbl_CONTRASENAS ON Tbl_contrasenas


/*  Insert Trigger 'T_I_Tbl_CONTRASENAS' for Table 'Tbl_CONTRASENAS'  */

CREATE TRIGGER [dbo].[T_I_Tbl_CONTRASENAS] ON [dbo].[Tbl_contrasenas] FOR INSERT AS

BEGIN
    DECLARE
           @row_co
-- TRIGGER: T_I_Tbl_cotizacion_clientes ON Tbl_cotizacion_clientes
CREATE TRIGGER [dbo].[T_I_Tbl_cotizacion_clientes] ON [dbo].[Tbl_cotizacion_clientes] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT
-- TRIGGER: T_I_Tbl_cotizacion_clientes_de ON Tbl_cotizacion_clientes_detalle
CREATE TRIGGER [dbo].[T_I_Tbl_cotizacion_clientes_de] ON [dbo].[Tbl_cotizacion_clientes_detalle] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
         
-- TRIGGER: t_i_tbl_cuentas_por_cobrar ON Tbl_cuentas_por_cobrar
-- =============================================
-- Author:		Pablo Paau
-- Create date: 
-- Description:	
-- =============================================
--Create an INSTEAD OF INSERT 
-- TRIGGER: T_I_Tbl_departamentos ON Tbl_departamentos
CREATE TRIGGER [dbo].[T_I_Tbl_departamentos] ON [dbo].[Tbl_departamentos] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_num
-- TRIGGER: T_I_TBL_DET_ABONOS ON Tbl_Det_Abonos
CREATE TRIGGER [T_I_TBL_DET_ABONOS] ON dbo.Tbl_Det_Abonos 
FOR INSERT
AS

    DECLARE
          	 @row_count       INT,
           	@null_row_count  INT,
           	@error_number    INT,
          
-- TRIGGER: T_I_tbl_det_cobros ON Tbl_det_cobros
CREATE TRIGGER [T_I_tbl_det_cobros] ON [dbo].[Tbl_det_cobros] 
FOR INSERT
AS

begin
	PRINT 'SS'

end



GO
                                                                                       
-- TRIGGER: T_I_Tbl_Det_Facturacion ON Tbl_Det_Facturacion


/*  Insert Trigger 'T_I_Tbl_Det_Facturacion' for Table 'Tbl_Det_Facturacion'  */

CREATE TRIGGER [dbo].[T_I_Tbl_Det_Facturacion] ON [dbo].[Tbl_Det_Facturacion] FOR INSERT AS

BEGIN
	DECLA
-- TRIGGER: T_I_Tbl_Det_Notas_credito ON Tbl_Det_Notas_Credito


/*  Insert Trigger 'T_I_Tbl_Det_Facturacion' for Table 'Tbl_Det_Facturacion'  */

CREATE TRIGGER [dbo].[T_I_Tbl_Det_Notas_credito] ON [dbo].[Tbl_Det_Notas_Credito] FOR INSERT AS

BEGIN
-- TRIGGER: T_I_Tbl_detalle_anticipos_clientes  ON Tbl_detalle_anticipos_clientes
CREATE TRIGGER [T_I_Tbl_detalle_anticipos_clientes ] ON [dbo].[Tbl_detalle_anticipos_clientes] 
FOR INSERT AS

declare @Id_empresa int,@serie char(3),@tipo_docto char(3),
-- TRIGGER: T_I_Tbl_Detalle_movimientos ON Tbl_Detalle_movimientos
/*  Insert Trigger 'T_I_Tbl_Detalle_movimientos' for Table 'Tbl_Detalle_movimientos'  */
CREATE TRIGGER [dbo].[T_I_Tbl_Detalle_movimientos] ON [dbo].[Tbl_Detalle_movimientos] FOR INSERT A
-- TRIGGER: T_I_TBL_DETALLE_MOVIMIENTOS_SUB ON Tbl_Detalle_movimientos_sub
CREATE TRIGGER [dbo].[T_I_TBL_DETALLE_MOVIMIENTOS_SUB] ON [dbo].[Tbl_Detalle_movimientos_sub] 
FOR INSERT
AS
BEGIN
	DECLARE 	@ERROR_NUMBER 	INT ,
			@error_message	varchar(255
-- TRIGGER: T_I_Tbl_detalle_orden_produccion ON Tbl_detalle_orden_produccion
CREATE TRIGGER [dbo].[T_I_Tbl_detalle_orden_produccion] ON [dbo].[Tbl_detalle_orden_produccion] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           
-- TRIGGER: T_I_Tbl_detalle_pedidos ON Tbl_detalle_pedidos
CREATE TRIGGER [dbo].[T_I_Tbl_detalle_pedidos] ON [dbo].[Tbl_detalle_pedidos] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @e
-- TRIGGER: T_I_Tbl_existencia ON Tbl_existencia
/*  Insert Trigger 'T_I_Tbl_existencia' for Table 'Tbl_existencia'  */

CREATE TRIGGER [dbo].[T_I_Tbl_existencia] ON dbo.Tbl_existencia FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT
-- TRIGGER: T_I_Tbl_Materia_prima ON Tbl_Productos


/*  Insert Trigger 'T_I_Tbl_Materia_prima' for Table 'Tbl_Productos'  */

CREATE TRIGGER [dbo].[T_I_Tbl_Materia_prima] ON [dbo].[Tbl_Productos] FOR INSERT AS

BEGIN
    DECLARE
           @row_c
-- TRIGGER: T_I_TBL_ORDEN_COMPRA_PROYECTO ON Tbl_Orden_Compra_Proyecto
CREATE TRIGGER [dbo].[T_I_TBL_ORDEN_COMPRA_PROYECTO] ON dbo.Tbl_Orden_Compra_Proyecto FOR INSERT AS
BEGIN

DECLARE @ID_ORDEN_COMPRA_PROYECTO INT,
		@Id_transaccion_tbl_rubro int,

-- TRIGGER: t_i_tbl_orden_compra_proyecto_detalle ON Tbl_Orden_Compra_Proyecto_Detalle

CREATE trigger [dbo].[t_i_tbl_orden_compra_proyecto_detalle] on [dbo].[Tbl_Orden_Compra_Proyecto_Detalle] for insert as
begin
update tbl_rubro_proyecto set cantidad
-- TRIGGER: T_I_Tbl_Orden_Servicio ON Tbl_Orden_Servicio
CREATE TRIGGER [dbo].[T_I_Tbl_Orden_Servicio] ON [dbo].[Tbl_Orden_Servicio] 
FOR INSERT
AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @er
-- TRIGGER: T_I_Tbl_Orden_Servicio_Detalle_Integracion ON Tbl_Orden_Servicio_Detalle_Integracion
CREATE TRIGGER [T_I_Tbl_Orden_Servicio_Detalle_Integracion] ON [dbo].[Tbl_Orden_Servicio_Detalle_Integracion] 
FOR INSERT
AS
Declare @Fecha_ult_Movimiento 
-- TRIGGER: T_I_Tbl_Presupuesto_Orden_Servicio ON Tbl_Presupuesto_Orden_Servicio
CREATE TRIGGER [T_I_Tbl_Presupuesto_Orden_Servicio] ON [dbo].[Tbl_Presupuesto_Orden_Servicio] 
FOR INSERT
AS

BEGIN
    DECLARE
           @row_count       INT,
      
-- TRIGGER: T_I_Tbl_Prod_Proveedores ON Tbl_Prod_Proveedores
CREATE TRIGGER [T_I_Tbl_Prod_Proveedores] ON dbo.Tbl_Prod_Proveedores 
FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error
-- TRIGGER: T_I_Tbl_produccion_diaria ON Tbl_produccion_diaria
CREATE TRIGGER dbo.T_I_Tbl_produccion_diaria ON dbo.tbl_produccion_diaria FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @e
-- TRIGGER: T_I_Tbl_Proveedores ON Tbl_Proveedores
CREATE TRIGGER [dbo].[T_I_Tbl_Proveedores] ON [dbo].[Tbl_Proveedores] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    I
-- TRIGGER: T_I_Tbl_Rubro_proyecto ON Tbl_Rubro_Proyecto
/*  Insert Trigger 'T_I_Tbl_Rubro_proyecto' for Table 'Tbl_Rubro_proyecto'  */

CREATE TRIGGER [dbo].[T_I_Tbl_Rubro_proyecto] ON [dbo].[Tbl_Rubro_Proyecto] FOR INSERT AS

BEGIN
    DECLARE
   
-- TRIGGER: T_I_Tbl_Series ON Tbl_Series
CREATE TRIGGER [dbo].[T_I_Tbl_Series] ON [dbo].[Tbl_Series] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
           @err
-- TRIGGER: T_I_Tbl_Tipos_Inv ON Tbl_Tipos_Inv
CREATE TRIGGER [dbo].[T_I_Tbl_Tipos_Inv] ON [dbo].[Tbl_Tipos_Inv] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
   
-- TRIGGER: T_I_Tbl_Unidad_Medida ON Tbl_Unidad_Medida
CREATE TRIGGER [dbo].[T_I_Tbl_Unidad_Medida] ON [dbo].[Tbl_Unidad_Medida] FOR INSERT AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_num
-- TRIGGER: T_U_empresas ON empresas
CREATE TRIGGER [dbo].[T_U_empresas] ON [dbo].[empresas] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
           @error_messa
-- TRIGGER: T_U_recepcion_pedidos_detalle ON Tbl_recepcion_pedidos_detalle




CREATE  TRIGGER [dbo].[T_U_recepcion_pedidos_detalle] ON [dbo].[Tbl_recepcion_pedidos_detalle] AFTER UPDATE AS
BEGIN
    DECLARE
           @row_count       INT,
      
-- TRIGGER: T_u_tbl_anticipos_por_aplicacion ON Tbl_anticipos_pos_aplicacion
-- =============================================
-- Author:		<Pablo Paau>
-- Create date: 23/01/2009
-- Description:	modificacion
-- =========================================
-- TRIGGER: T_U_Tbl_articulos ON Tbl_articulos
CREATE TRIGGER [dbo].[T_U_Tbl_articulos] ON [dbo].[Tbl_articulos] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
   
-- TRIGGER: T_U_Tbl_bodega ON Tbl_bodega
CREATE TRIGGER [dbo].[T_U_Tbl_bodega] ON [dbo].[Tbl_bodega] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
           @err
-- TRIGGER: T_U_Tbl_Cab_entrega_despacho ON tbl_cab_entrega_despacho
CREATE TRIGGER [dbo].[T_U_Tbl_Cab_entrega_despacho] ON [dbo].[tbl_cab_entrega_despacho] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count 
-- TRIGGER: T_U_Tbl_Cab_Facturacion ON Tbl_Cab_Facturacion
/*  Update Trigger 'T_U_Tbl_Cab_Facturacion' for Table 'Tbl_Cab_Facturacion'  */

CREATE TRIGGER [dbo].[T_U_Tbl_Cab_Facturacion] ON dbo.Tbl_Cab_Facturacion FOR UPDATE AS

BEGIN
    DECLARE
 
-- TRIGGER: T_u_tbl_cab_generacion_compras ON Tbl_Cab_generacion_compras
CREATE TRIGGER [dbo].[T_u_tbl_cab_generacion_compras] ON [dbo].[Tbl_Cab_generacion_compras] FOR update AS

begin

declare @Id_empresa int,@nit char(20),@Id_recepcion int,@numero 
-- TRIGGER: T_U_Tbl_Cab_Notas_credito ON Tbl_Cab_Notas_Credito



/*  Update Trigger 'T_U_Tbl_Cab_Facturacion' for Table 'Tbl_Cab_Facturacion'  */

CREATE  TRIGGER [dbo].[T_U_Tbl_Cab_Notas_credito] ON [dbo].[Tbl_Cab_Notas_Credito] FOR UPDATE AS

BEG
-- TRIGGER: T_U_Tbl_cabecera_movimientos ON Tbl_cabecera_movimientos

/*  Update Trigger 'T_U_Tbl_cabecera_movimientos' for Table 'Tbl_cabecera_movimientos'  */

CREATE TRIGGER [dbo].[T_U_Tbl_cabecera_movimientos] ON [dbo].[Tbl_cabecera_movimientos] FO
-- TRIGGER: T_U_Tbl_Cajas ON Tbl_Cajas
CREATE TRIGGER [dbo].[T_U_Tbl_Cajas] ON [dbo].[Tbl_Cajas] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
           @error_m
-- TRIGGER: T_U_tbl_contrasenas ON Tbl_contrasenas
CREATE trigger [dbo].[T_U_tbl_contrasenas] on [dbo].[Tbl_contrasenas] for update as
begin
	declare @id_empresa int,
			@Id_contrasena int,
			@Id_Orden_compra_proyecto int

	select @id_empresa=id_em
-- TRIGGER: T_U_Tbl_cotizacion_clientes ON Tbl_cotizacion_clientes
CREATE TRIGGER [dbo].[T_U_Tbl_cotizacion_clientes] ON [dbo].[Tbl_cotizacion_clientes] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT
-- TRIGGER: T_U_Tbl_departamentos ON Tbl_departamentos
CREATE TRIGGER [dbo].[T_U_Tbl_departamentos] ON [dbo].[Tbl_departamentos] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_num
-- TRIGGER: T_U_Tbl_Det_Abonos ON Tbl_Det_Abonos
CREATE TRIGGER [T_U_Tbl_Det_Abonos] ON dbo.Tbl_Det_Abonos 
FOR  UPDATE
AS


Declare @Id_empresa		int,
	@Nit 			char(20),
	@Tipo_cargo 		char(3),
	@Numero_factura 	numeric(15),
	@Valor_aplicado		num
-- TRIGGER: T_U_TBL_DET_COBROS ON Tbl_det_cobros
CREATE TRIGGER [T_U_TBL_DET_COBROS] ON [dbo].[Tbl_det_cobros] 
FOR INSERT, UPDATE
AS
BEGIN

--DESACTUALIZA
declare @valor_aplicado	numeric(12,2)
	select @valor_aplicado=valor_aplicado from deleted d
-- TRIGGER: T_U_TBL_DET_ENTREGA_DESPACHO ON tbl_det_entrega_despacho
--update tbl_det_entrega_despacho set cantidad=100 where id_empresa=1 and numero=2 and id_producto='601'

--alter table tbl_det_entrega_despacho enable trigger all


CREATE        T
-- TRIGGER: t_u_tbl_det_explosion ON Tbl_det_explosion
CREATE  trigger [dbo].[t_u_tbl_det_explosion] on [dbo].[Tbl_det_explosion] for update as 
begin


   DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_
-- TRIGGER: T_U_Tbl_detalle_COMPRAS ON Tbl_detalle_compras


/*  Insert Trigger 'T_I_Tbl_detalle_compras' for Table 'Tbl_detalle_pedidos'  */

CREATE TRIGGER [dbo].[T_U_Tbl_detalle_COMPRAS] ON [dbo].[Tbl_detalle_compras] FOR update AS

BEGIN
    DECL
-- TRIGGER: T_U_Tbl_Detalle_movimientos ON Tbl_Detalle_movimientos
CREATE TRIGGER [dbo].[T_U_Tbl_Detalle_movimientos] ON dbo.Tbl_Detalle_movimientos FOR UPDATE AS
BEGIN
	DECLARE	@row_count       			INT,
	           		@null_row_count  	INT,
	          
-- TRIGGER: T_U_Tbl_Detalle_movimientos_sub ON Tbl_Detalle_movimientos_sub
CREATE  TRIGGER [dbo].[T_U_Tbl_Detalle_movimientos_sub] ON [dbo].[Tbl_Detalle_movimientos_sub] FOR UPDATE AS
BEGIN
	DECLARE	@row_count       	INT,
	           		@null_row_count 
-- TRIGGER: T_U_Tbl_Materia_prima ON Tbl_Productos


/*  Update Trigger 'T_U_Tbl_Materia_prima' for Table 'Tbl_Productos'  */

CREATE TRIGGER [dbo].[T_U_Tbl_Materia_prima] ON [dbo].[Tbl_Productos] FOR UPDATE AS

BEGIN
    DECLARE
           @row_c
-- TRIGGER: T_U_Tbl_Orden_Compra ON Tbl_Orden_Compra_Proyecto
/*  Insert Trigger 'T_I_Tbl_log_Tbl_Proyecto_Estado' for Table 'Tbl_log_Tbl_Proyecto_Estado'  */





CREATE TRIGGER [dbo].[T_U_Tbl_Orden_Compra] ON [dbo].[Tbl_Orden_Compra_Proyecto] FOR 
-- TRIGGER: t_u_tbl_orden_compra_proyecto_detalle ON Tbl_Orden_Compra_Proyecto_Detalle

CREATE trigger [dbo].[t_u_tbl_orden_compra_proyecto_detalle] on [dbo].[Tbl_Orden_Compra_Proyecto_Detalle] for update as
begin

--desactualiza el valor que estoy qu
-- TRIGGER: T_U_Tbl_Orden_Servicio ON Tbl_Orden_Servicio
CREATE  TRIGGER [T_U_Tbl_Orden_Servicio] ON [dbo].[Tbl_Orden_Servicio] 
FOR  UPDATE
AS
Begin
	DECLARE
          	 @row_count       INT,
           	 @null_row_count  INT,
              @error
-- TRIGGER: T_u_Tbl_Orden_Servicio_Detalle_Integracion ON Tbl_Orden_Servicio_Detalle_Integracion
CREATE TRIGGER [T_u_Tbl_Orden_Servicio_Detalle_Integracion] ON [dbo].[Tbl_Orden_Servicio_Detalle_Integracion] 
FOR  UPDATE
AS
Begin
------desactualizando 
-- TRIGGER: T_U_Tbl_pedidos ON Tbl_pedidos
/*  Update Trigger 'T_U_Tbl_pedidos' for Table 'Tbl_pedidos'  */

CREATE TRIGGER [dbo].[T_U_Tbl_pedidos] ON [dbo].[Tbl_pedidos] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           
-- TRIGGER: T_U_Tbl_Presupuesto_Orden_Servicio ON Tbl_Presupuesto_Orden_Servicio
CREATE TRIGGER [T_U_Tbl_Presupuesto_Orden_Servicio] ON [dbo].[Tbl_Presupuesto_Orden_Servicio] 
FOR  UPDATE
AS
Begin
	DECLARE
          	 @row_count       INT,
         
-- TRIGGER: T_u_Tbl_produccion_diaria ON Tbl_produccion_diaria
CREATE TRIGGER [dbo].[T_u_Tbl_produccion_diaria] ON [dbo].[Tbl_produccion_diaria] FOR update AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
     
-- TRIGGER: T_U_Tbl_Proveedores ON Tbl_Proveedores
CREATE TRIGGER [T_U_Tbl_Proveedores] ON dbo.Tbl_Proveedores FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
     
-- TRIGGER: T_U_Tbl_Proyecto ON Tbl_Proyecto

--UPDATE  TBL_PROYECTO SET ESTADO_PROYECTO='ANULADO' WHERE ID_TRANSACCION_PROYECTO=74

/*  Insert Trigger 'T_I_Tbl_log_Tbl_Proyecto_Estado' for Table 'Tbl_log_Tbl_Proyecto_Estado'  */

CREATE TRIGGER [dbo
-- TRIGGER: T_U_Tbl_recepcion_pedidos ON Tbl_recepcion_pedidos

CREATE TRIGGER [dbo].[T_U_Tbl_recepcion_pedidos] ON [dbo].[Tbl_recepcion_pedidos] FOR UPDATE AS

if update(status)
begin
	declare @Id_pedido int,
			@Id_empresa int
	select @Id_pedido=
-- TRIGGER: T_U_tbl_rubro_proyecto ON Tbl_Rubro_Proyecto
CREATE TRIGGER [dbo].[T_U_tbl_rubro_proyecto] ON [dbo].[Tbl_Rubro_Proyecto]
FOR UPDATE
AS


declare @error_number int,
		@error_message char(250)

begin
declare @Id_Transaccion_Proyecto int
-- TRIGGER: T_U_Tbl_Series ON Tbl_Series

CREATE TRIGGER [dbo].[T_U_Tbl_Series] ON [dbo].[Tbl_Series] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT, 
           @
-- TRIGGER: T_U_TBL_SOLICITUD_DESPACHO_CLIENTE ON Tbl_solicitud_despacho_cliente
CREATE TRIGGER T_U_TBL_SOLICITUD_DESPACHO_CLIENTE ON DBO.TBL_SOLICITUD_DESPACHO_CLIENTE FOR UPDATE AS 


IF UPDATE(STATUS_SOLICITUD)
BEGIN
	SELECT *FROM TBL_SOLICITUD_DE
-- TRIGGER: t_u_tbl_solicitud_despacho_cliente_detalle ON tbl_solicitud_Despacho_cliente_detalle

--al cambiar el precio del detalle de una solicitud de envio
--cambia tambien el precio que este en el detalle del envio 
CREATE trigger dbo.t_u_tbl_solic
-- TRIGGER: T_U_Tbl_Tipos_Inv ON Tbl_Tipos_Inv
CREATE TRIGGER [T_U_Tbl_Tipos_Inv] ON [dbo].[Tbl_Tipos_Inv] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_number    INT,
         
-- TRIGGER: T_U_Tbl_Unidad_Medida ON Tbl_Unidad_Medida
CREATE TRIGGER [dbo].[T_U_Tbl_Unidad_Medida] ON [dbo].[Tbl_Unidad_Medida] FOR UPDATE AS

BEGIN
    DECLARE
           @row_count       INT,
           @null_row_count  INT,
           @error_num
-- TRIGGER: TBL_I_TBL_CAB_ENTREGA_DESPACHO ON tbl_cab_entrega_despacho

CREATE    TRIGGER [dbo].[TBL_I_TBL_CAB_ENTREGA_DESPACHO] ON [dbo].[tbl_cab_entrega_despacho] FOR INSERT AS
BEGIN
      DECLARE
           @row_count       INT,
           @null_r
-- TRIGGER: tbl_u_anticipos_clientes ON Tbl_anticipos_clientes

CREATE trigger [dbo].[tbl_u_anticipos_clientes] on [dbo].[Tbl_anticipos_clientes] for update as

if update(anio) and update(mes) and update(tipo) and update(numero)
begin
--insertando ca

(119 rows affected)
