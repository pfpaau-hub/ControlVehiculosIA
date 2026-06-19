-- VIEW: Comisiones
CREATE VIEW dbo.Comisiones
AS
SELECT     dbo.Tbl_Cab_Facturacion.Id_Empresa, dbo.Tbl_Cab_Facturacion.Id_Caja, dbo.Tbl_Cab_Facturacion.Autorizacion, dbo.Tbl_Cab_Facturacion.Serie, 
                      dbo.Tbl_Cab_Facturacion.Id_Tipo, dbo.Tbl_Cab_Facturacion.Numero, dbo.Tbl_Cab_Facturacion.Fecha_Factura, dbo.Tbl_Cab_Facturacion.Id_empleado, 
                      dbo.Tbl_Vendedores.Nombre, dbo.Tbl_Det_Facturacion.Id_Producto, dbo.Tbl_Det_Facturacion.Cantidad, dbo.Tbl_Det_Facturacion.Precio, 
                      dbo.Tbl_Det_Facturacion.Total_Linea, dbo.Tbl_Det_Facturacion.Descripcion_Corta, dbo.Tbl_cobros.Id_tipo_cobro, dbo.Tbl_cobros.Num_docto_cobro, 
                      dbo.Tbl_cobros.Efectivo, dbo.Tbl_cobros.Id_banco, dbo.Tbl_cobros.Valor_cheque, dbo.Tbl_cobros.Id_casa, dbo.Tbl_cobros.Valor_tarjeta, 
                      dbo.Tbl_cobros.Total_cobro, dbo.Tbl_cobros.Numero_cheque, dbo.Tbl_cobros.numero_tarjeta, dbo.Tbl_cobros.Id_banco_deposito, 
                      dbo.Tbl_cobros.Numero_deposito, dbo.Tbl_cobros.Valor_deposito
FROM         dbo.Tbl_cobros INNER JOIN
                      dbo.Tbl_det_cobros ON dbo.Tbl_cobros.Id_empresa = dbo.Tbl_det_cobros.Id_Empresa AND 
                      dbo.Tbl_cobros.Id_tipo_cobro = dbo.Tbl_det_cobros.Id_tipo_cobro AND 
                      dbo.Tbl_cobros.Num_docto_cobro = dbo.Tbl_det_cobros.Num_docto_cobro INNER JOIN
                      dbo.Tbl_Cab_Facturacion ON dbo.Tbl_cobros.Id_empresa = dbo.Tbl_Cab_Facturacion.Id_Empresa AND 
                      dbo.Tbl_det_cobros.Serie = dbo.Tbl_Cab_Facturacion.Serie AND dbo.Tbl_det_cobros.Id_tipo = dbo.Tbl_Cab_Facturacion.Id_Tipo AND 
                      dbo.Tbl_det_cobros.Numero = dbo.Tbl_Cab_Facturacion.Numero INNER JOIN
                      dbo.Tbl_Vendedores ON dbo.Tbl_cobros.Id_empresa = dbo.Tbl_Vendedores.Id_Empresa AND 
                      dbo.Tbl_Cab_Facturacion.Id_empleado = dbo.Tbl_Vendedores.Id_Empleado INNER JOIN
                      dbo.Tbl_Det_Facturacion ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.Tbl_Det_Facturacion.Id_Empresa AND 
                      dbo.Tbl_Cab_Facturacion.Id_Caja = dbo.Tbl_Det_Facturacion.Id_Caja AND 
                      dbo.Tbl_Cab_Facturacion.Autorizacion = dbo.Tbl_Det_Facturacion.Autorizacion AND 
                      dbo.Tbl_Cab_Facturacion.Serie = dbo.Tbl_Det_Facturacion.Serie AND dbo.Tbl_Cab_Facturacion.Id_Tipo = dbo.Tbl_Det_Facturacion.Id_Tipo AND 
                      dbo.Tbl_Cab_Facturacion.Numero = dbo.Tbl_Det_Facturacion.Numero

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
-- VIEW: pruebas

CREATE VIEW dbo.pruebas
AS
SELECT     dbo.Tbl_productos_configuracion_contable.*, dbo.Tbl_productos_configuracion_contable.Id_Cuenta_dev AS Expr1, 
                      dbo.Tbl_Cab_Facturacion.Fecha_Factura AS Expr2
FROM         dbo.Tbl_productos_configuracion_contable INNER JOIN
                      dbo.Tbl_Det_Facturacion ON dbo.Tbl_productos_configuracion_contable.Id_Empresa = dbo.Tbl_Det_Facturacion.Id_Empresa AND 
                      dbo.Tbl_productos_configuracion_contable.Id_Producto = dbo.Tbl_Det_Facturacion.Id_Producto INNER JOIN
                      dbo.Tbl_Cab_Facturacion ON dbo.Tbl_Det_Facturacion.Id_Empresa = dbo.Tbl_Cab_Facturacion.Id_Empresa AND 
                      dbo.Tbl_Det_Facturacion.Id_Caja = dbo.Tbl_Cab_Facturacion.Id_Caja AND 
                      dbo.Tbl_Det_Facturacion.Autorizacion = dbo.Tbl_Cab_Facturacion.Autorizacion AND 
                      dbo.Tbl_Det_Facturacion.Serie = dbo.Tbl_Cab_Facturacion.Serie AND dbo.Tbl_Det_Facturacion.Id_Tipo = dbo.Tbl_Cab_Facturacion.Id_Tipo AND 
                      dbo.Tbl_Det_Facturacion.Numero = dbo.Tbl_Cab_Facturacion.Numero
WHERE     (dbo.Tbl_productos_configuracion_contable.Id_Cuenta_dev = '421.09.03') AND (dbo.Tbl_Cab_Facturacion.Fecha_Factura = CONVERT(DATETIME, 
                      '2006-03-10 00:00:00', 102))


GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
-- VIEW: ventas_por_producto
CREATE view dbo.ventas_por_producto as
SELECT     dbo.Tbl_Cab_Facturacion.Nit, dbo.Tbl_Det_Facturacion.Id_Producto, dbo.Tbl_Det_Facturacion.Cantidad, dbo.Tbl_Det_Facturacion.Precio, 
                      dbo.Tbl_Det_Facturacion.Precio_Descuento, dbo.Tbl_Productos.Descripcion, dbo.Tbl_Cab_Facturacion.Fecha_Factura, dbo.empresas.Nombre_Empresa, 
                      dbo.Tbl_Cab_Facturacion.Id_Caja, dbo.Tbl_Cab_Facturacion.Autorizacion, dbo.Tbl_Cab_Facturacion.Serie, dbo.Tbl_Cab_Facturacion.Id_Tipo, 
                      dbo.Tbl_Cab_Facturacion.Numero, dbo.Tbl_Cab_Facturacion.Id_Empresa, dbo.Tbl_Cab_Facturacion.Descuento, dbo.Tbl_Cab_Facturacion.Subtotal, 
                      dbo.Tbl_Cab_Facturacion.Total, 
                      ROUND(ROUND(dbo.Tbl_Cab_Facturacion.Descuento / CASE WHEN dbo.Tbl_Cab_Facturacion.Subtotal = 0 THEN 1 ELSE dbo.Tbl_Cab_Facturacion.subTotal END, 8) 
                      * dbo.Tbl_Det_Facturacion.Cantidad * dbo.Tbl_Det_Facturacion.Precio, 2) AS descuentazo
FROM         dbo.Tbl_Cab_Facturacion INNER JOIN
                      dbo.Tbl_Det_Facturacion ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.Tbl_Det_Facturacion.Id_Empresa AND 
                      dbo.Tbl_Cab_Facturacion.Id_Caja = dbo.Tbl_Det_Facturacion.Id_Caja AND dbo.Tbl_Cab_Facturacion.Autorizacion = dbo.Tbl_Det_Facturacion.Autorizacion AND 
                      dbo.Tbl_Cab_Facturacion.Serie = dbo.Tbl_Det_Facturacion.Serie AND dbo.Tbl_Cab_Facturacion.Id_Tipo = dbo.Tbl_Det_Facturacion.Id_Tipo AND 
                      dbo.Tbl_Cab_Facturacion.Numero = dbo.Tbl_Det_Facturacion.Numero INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_Det_Facturacion.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.Tbl_Det_Facturacion.Id_Producto = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.empresas ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.empresas.Id_Empresa
WHERE     dbo.tbl_cab_facturacion.status <> 3 AND dbo.Tbl_productos.tipo <> 'MATERIA P.'
UNION ALL
SELECT     dbo.Tbl_Cab_Notas_credito.Nit, dbo.Tbl_Det_Notas_credito.Id_Producto, dbo.Tbl_Det_Notas_credito.Cantidad, dbo.Tbl_Det_Notas_credito.Precio, 
                      dbo.Tbl_Det_Notas_credito.Precio_Descuento, dbo.Tbl_Productos.Descripcion, dbo.Tbl_Cab_Notas_credito.Fecha_Factura, dbo.empresas.Nombre_Empresa, 
                      dbo.Tbl_Cab_Notas_credito.Id_Caja, dbo.Tbl_Cab_Notas_credito.Autorizacion, dbo.Tbl_Cab_Notas_credito.Serie, dbo.Tbl_Cab_Notas_credito.Id_Tipo, 
                      dbo.Tbl_Cab_Notas_credito.Numero, dbo.Tbl_Cab_Notas_credito.Id_Empresa, dbo.Tbl_Cab_Notas_credito.Descuento, dbo.Tbl_Cab_Notas_credito.Subtotal, 
                      dbo.Tbl_Cab_Notas_credito.Total, 
                      ROUND(ROUND(dbo.Tbl_Cab_Notas_credito.Descuento / CASE WHEN dbo.Tbl_Cab_Notas_credito.Subtotal = 0 THEN 1 ELSE dbo.Tbl_Cab_Notas_credito.subTotal END,
                       8) * dbo.Tbl_Det_Notas_credito.Cantidad * dbo.Tbl_Det_Notas_credito.Precio, 2) AS descuentazo
FROM         dbo.Tbl_Cab_Notas_credito INNER JOIN
                      dbo.Tbl_Det_Notas_credito ON dbo.Tbl_Cab_Notas_credito.Id_Empresa = dbo.Tbl_Det_Notas_credito.Id_Empresa AND 
                      dbo.Tbl_Cab_Notas_credito.Id_Caja = dbo.Tbl_Det_Notas_credito.Id_Caja AND dbo.Tbl_Cab_Notas_credito.Autorizacion = dbo.Tbl_Det_Notas_credito.Autorizacion AND
                       dbo.Tbl_Cab_Notas_credito.Serie = dbo.Tbl_Det_Notas_credito.Serie AND dbo.Tbl_Cab_Notas_credito.Id_Tipo = dbo.Tbl_Det_Notas_credito.Id_Tipo AND 
                      dbo.Tbl_Cab_Notas_credito.Numero = dbo.Tbl_Det_Notas_credito.Numero INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_Det_Notas_credito.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.Tbl_Det_Notas_credito.Id_Producto = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.empresas ON dbo.Tbl_Cab_Notas_credito.Id_Empres
-- VIEW: ventas_por_producto_eventos
CREATE view dbo.ventas_por_producto_eventos as
SELECT     dbo.Tbl_Cab_Facturacion.Nit, dbo.Tbl_Det_Facturacion.Id_Producto, dbo.Tbl_Det_Facturacion.Cantidad, dbo.Tbl_Det_Facturacion.Precio, 
                      dbo.Tbl_Det_Facturacion.Precio_Descuento, dbo.Tbl_Productos.Descripcion, dbo.Tbl_Cab_Facturacion.Fecha_Factura, dbo.empresas.Nombre_Empresa, 
                      dbo.Tbl_Cab_Facturacion.Id_Caja, dbo.Tbl_Cab_Facturacion.Autorizacion, dbo.Tbl_Cab_Facturacion.Serie, dbo.Tbl_Cab_Facturacion.Id_Tipo, 
                      dbo.Tbl_Cab_Facturacion.Numero, dbo.Tbl_Cab_Facturacion.Id_Empresa, dbo.Tbl_Cab_Facturacion.Descuento, dbo.Tbl_Cab_Facturacion.Subtotal, 
                      dbo.Tbl_Cab_Facturacion.Total, 
                      ROUND(ROUND(dbo.Tbl_Cab_Facturacion.Descuento / CASE WHEN dbo.Tbl_Cab_Facturacion.Subtotal = 0 THEN 1 ELSE dbo.Tbl_Cab_Facturacion.subTotal END, 8) 
                      * dbo.Tbl_Det_Facturacion.Cantidad * dbo.Tbl_Det_Facturacion.Precio, 2) AS descuentazo
FROM         dbo.Tbl_Cab_Facturacion INNER JOIN
                      dbo.Tbl_Det_Facturacion ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.Tbl_Det_Facturacion.Id_Empresa AND 
                      dbo.Tbl_Cab_Facturacion.Id_Caja = dbo.Tbl_Det_Facturacion.Id_Caja AND dbo.Tbl_Cab_Facturacion.Autorizacion = dbo.Tbl_Det_Facturacion.Autorizacion AND 
                      dbo.Tbl_Cab_Facturacion.Serie = dbo.Tbl_Det_Facturacion.Serie AND dbo.Tbl_Cab_Facturacion.Id_Tipo = dbo.Tbl_Det_Facturacion.Id_Tipo AND 
                      dbo.Tbl_Cab_Facturacion.Numero = dbo.Tbl_Det_Facturacion.Numero INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_Det_Facturacion.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.Tbl_Det_Facturacion.Id_Producto = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.empresas ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.empresas.Id_Empresa
WHERE		dbo.tbl_cab_facturacion.status <> 3 and dbo.Tbl_Cab_Facturacion.Tarjeta_beneficio ='EVENTOS' AND
			dbo.tbl_productos.Tipo <>'MATERIA P.'
UNION ALL
SELECT     dbo.Tbl_Cab_Notas_credito.Nit, dbo.Tbl_Det_Notas_credito.Id_Producto, dbo.Tbl_Det_Notas_credito.Cantidad, dbo.Tbl_Det_Notas_credito.Precio, 
                      dbo.Tbl_Det_Notas_credito.Precio_Descuento, dbo.Tbl_Productos.Descripcion, dbo.Tbl_Cab_Notas_credito.Fecha_Factura, dbo.empresas.Nombre_Empresa, 
                      dbo.Tbl_Cab_Notas_credito.Id_Caja, dbo.Tbl_Cab_Notas_credito.Autorizacion, dbo.Tbl_Cab_Notas_credito.Serie, dbo.Tbl_Cab_Notas_credito.Id_Tipo, 
                      dbo.Tbl_Cab_Notas_credito.Numero, dbo.Tbl_Cab_Notas_credito.Id_Empresa, dbo.Tbl_Cab_Notas_credito.Descuento, dbo.Tbl_Cab_Notas_credito.Subtotal, 
                      dbo.Tbl_Cab_Notas_credito.Total, 
                      ROUND(ROUND(dbo.Tbl_Cab_Notas_credito.Descuento / CASE WHEN dbo.Tbl_Cab_Notas_credito.Subtotal = 0 THEN 1 ELSE dbo.Tbl_Cab_Notas_credito.subTotal END,
                       8) * dbo.Tbl_Det_Notas_credito.Cantidad * dbo.Tbl_Det_Notas_credito.Precio, 2) AS descuentazo
FROM         dbo.Tbl_Cab_Notas_credito INNER JOIN
                      dbo.Tbl_Det_Notas_credito ON dbo.Tbl_Cab_Notas_credito.Id_Empresa = dbo.Tbl_Det_Notas_credito.Id_Empresa AND 
                      dbo.Tbl_Cab_Notas_credito.Id_Caja = dbo.Tbl_Det_Notas_credito.Id_Caja AND dbo.Tbl_Cab_Notas_credito.Autorizacion = dbo.Tbl_Det_Notas_credito.Autorizacion AND
                       dbo.Tbl_Cab_Notas_credito.Serie = dbo.Tbl_Det_Notas_credito.Serie AND dbo.Tbl_Cab_Notas_credito.Id_Tipo = dbo.Tbl_Det_Notas_credito.Id_Tipo AND 
                      dbo.Tbl_Cab_Notas_credito.Numero = dbo.Tbl_Det_Notas_credito.Numero INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_Det_Notas_credito.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.Tbl_Det_Notas_credito.Id_Producto = dbo.Tbl_Productos.Id_Producto INNER JOIN

-- VIEW: vw_comisiones_facturacion
CREATE VIEW dbo.vw_comisiones_facturacion
AS
SELECT     dbo.Tbl_Cab_Facturacion.Serie, dbo.Tbl_Cab_Facturacion.Id_Tipo, dbo.Tbl_Cab_Facturacion.Numero, dbo.Tbl_Vendedores.Id_Empleado, 
                      dbo.Tbl_Vendedores.Nombre, dbo.Tbl_Cab_Facturacion.Nit, dbo.Tbl_Cab_Facturacion.Facturar_a, dbo.Tbl_Cab_Facturacion.Fecha_Factura, 
                      dbo.Tbl_Cab_Facturacion.Total, dbo.Tbl_Orden_Servicio.Serie AS Expr1, dbo.Tbl_Orden_Servicio.tipo, dbo.Tbl_Orden_Servicio.Numero AS Expr2, 
                      dbo.Tbl_Orden_Servicio.Id_Orden, dbo.Tbl_Vendedores.porc_comision, dbo.Tbl_Cab_Facturacion.Id_Empresa, dbo.empresas.Nombre_Empresa
FROM         dbo.Tbl_Cab_Facturacion INNER JOIN
                      dbo.Tbl_Vendedores ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.Tbl_Vendedores.Id_Empresa AND 
                      dbo.Tbl_Cab_Facturacion.Id_empleado = dbo.Tbl_Vendedores.Id_Empleado INNER JOIN
                      dbo.empresas ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.empresas.Id_Empresa LEFT OUTER JOIN
                      dbo.Tbl_Orden_Servicio ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.Tbl_Orden_Servicio.Id_Empresa AND 
                      dbo.Tbl_Cab_Facturacion.Serie = dbo.Tbl_Orden_Servicio.Serie AND dbo.Tbl_Cab_Facturacion.Id_Tipo = dbo.Tbl_Orden_Servicio.tipo AND 
                      dbo.Tbl_Cab_Facturacion.Numero = dbo.Tbl_Orden_Servicio.Numero

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
-- VIEW: vw_contrasenas_facturas
CREATE VIEW dbo.vw_contrasenas_facturas
AS
SELECT     dbo.Tbl_contrasenas.Id_Empresa, dbo.Tbl_contrasenas.Id_contrasena, dbo.Tbl_contrasenas.Nit, dbo.Tbl_contrasenas.Fecha_recepcion, 
                      dbo.Tbl_contrasenas.Descripcion, dbo.Tbl_contrasenas.Fecha_operacion, dbo.Tbl_contrasenas.Usuario, dbo.Tbl_contrasenas.status_contrasena, 
                      dbo.Tbl_Cargos.Descripcion AS Descrip, dbo.Tbl_Cargos.Fecha_Documento, dbo.Tbl_Cargos.Valor_Factura, dbo.Tbl_Proveedores.Nombre, 
                      dbo.Tbl_Cargos.Fecha_Tentativa_pago, dbo.empresas.Nombre_Empresa, dbo.Tbl_Cargos.Tipo_Cargo, dbo.Tbl_Cargos.Numero_Factura, dbo.Tbl_Cargos.Serie
FROM         dbo.Tbl_contrasenas INNER JOIN
                      dbo.Tbl_Cargos ON dbo.Tbl_contrasenas.Id_Empresa = dbo.Tbl_Cargos.Id_Empresa AND 
                      dbo.Tbl_contrasenas.Id_contrasena = dbo.Tbl_Cargos.Id_contrasena INNER JOIN
                      dbo.Tbl_Proveedores ON dbo.Tbl_contrasenas.Id_Empresa = dbo.Tbl_Proveedores.Id_Empresa AND dbo.Tbl_contrasenas.Nit = dbo.Tbl_Proveedores.Nit INNER JOIN
                      dbo.empresas ON dbo.Tbl_contrasenas.Id_Empresa = dbo.empresas.Id_Empresa

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
-- VIEW: Vw_despacho_envio
CREATE VIEW dbo.Vw_despacho_envio
AS
SELECT     dbo.tbl_cab_entrega_despacho.Id_empresa, dbo.tbl_cab_entrega_despacho.Numero, dbo.tbl_cab_entrega_despacho.Periodo, 
                      dbo.tbl_cab_entrega_despacho.Id_solicitud_despacho, dbo.tbl_cab_entrega_despacho.Fecha, dbo.tbl_cab_entrega_despacho.Concepto, 
                      dbo.tbl_cab_entrega_despacho.usuario, dbo.tbl_cab_entrega_despacho.fecha_hora, dbo.tbl_det_entrega_despacho.Id_bodega_movimiento, 
                      dbo.tbl_det_entrega_despacho.Id_producto, dbo.tbl_det_entrega_despacho.Cantidad, dbo.tbl_det_entrega_despacho.Precio, dbo.tbl_det_entrega_despacho.Total, 
                      dbo.Tbl_solicitud_despacho_cliente.Direccion_factura, dbo.Tbl_solicitud_despacho_cliente.Direccion_entrega, dbo.Tbl_solicitud_despacho_cliente.Observaciones, 
                      dbo.empresas.Nombre_Empresa, dbo.Tbl_solicitud_despacho_cliente.Nit_cliente, dbo.Tbl_Proveedores.Nombre, dbo.Tbl_Productos.Descripcion, 
                      dbo.Tbl_solicitud_despacho_cliente.Recibe_orden
FROM         dbo.tbl_cab_entrega_despacho INNER JOIN
                      dbo.tbl_det_entrega_despacho ON dbo.tbl_cab_entrega_despacho.Id_empresa = dbo.tbl_det_entrega_despacho.Id_empresa AND 
                      dbo.tbl_cab_entrega_despacho.Numero = dbo.tbl_det_entrega_despacho.Numero INNER JOIN
                      dbo.Tbl_solicitud_despacho_cliente ON dbo.tbl_cab_entrega_despacho.Id_empresa = dbo.Tbl_solicitud_despacho_cliente.Id_empresa AND 
                      dbo.tbl_cab_entrega_despacho.Id_solicitud_despacho = dbo.Tbl_solicitud_despacho_cliente.Id_solicitud_despacho INNER JOIN
                      dbo.empresas ON dbo.Tbl_solicitud_despacho_cliente.Id_empresa = dbo.empresas.Id_Empresa INNER JOIN
                      dbo.Tbl_Proveedores ON dbo.Tbl_solicitud_despacho_cliente.Id_empresa = dbo.Tbl_Proveedores.Id_Empresa AND 
                      dbo.Tbl_solicitud_despacho_cliente.Nit_cliente = dbo.Tbl_Proveedores.Nit INNER JOIN
                      dbo.Tbl_Productos ON dbo.tbl_cab_entrega_despacho.Id_empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.tbl_det_entrega_despacho.Id_producto = dbo.Tbl_Productos.Id_Producto

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
-- VIEW: VW_FACTURA_CXC_PLANTILLA

CREATE VIEW [dbo].[VW_FACTURA_CXC_PLANTILLA]
AS
SELECT     dbo.Tbl_cuentas_por_cobrar.*, dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Id_producto, 
                      dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Cantidad, dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Total, 
                      dbo.Tbl_cuentas_por_cobrar.Descripcion AS Expr1, dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Descripcion AS Expr2, 
                      dbo.Tbl_Proveedores.Nombre, dbo.Tbl_cuentas_por_cobrar.id_ente_facturador AS Expr3, dbo.Tbl_Ente_facturador.Nombre_Ente_facturador, 
                      dbo.Tbl_Ente_facturador.Direccion_Ente_facturador
FROM         dbo.Tbl_cuentas_por_cobrar INNER JOIN
                      dbo.Tbl_cuentas_por_cobrar_integracion_plantilla ON 
                      dbo.Tbl_cuentas_por_cobrar.Id_Empresa = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Id_empresa AND 
                      dbo.Tbl_cuentas_por_cobrar.Id_Empresa = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Id_empresa AND 
                      dbo.Tbl_cuentas_por_cobrar.Nit = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Nit AND 
                      dbo.Tbl_cuentas_por_cobrar.Nit = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Nit AND 
                      dbo.Tbl_cuentas_por_cobrar.Serie = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Serie AND 
                      dbo.Tbl_cuentas_por_cobrar.Serie = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Serie AND 
                      dbo.Tbl_cuentas_por_cobrar.Tipo_docto = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Tipo_docto AND 
                      dbo.Tbl_cuentas_por_cobrar.Tipo_docto = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Tipo_docto AND 
                      dbo.Tbl_cuentas_por_cobrar.Numero_docto = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Numero_docto AND 
                      dbo.Tbl_cuentas_por_cobrar.Numero_docto = dbo.Tbl_cuentas_por_cobrar_integracion_plantilla.Numero_docto INNER JOIN
                      dbo.Tbl_Proveedores ON dbo.Tbl_cuentas_por_cobrar.Id_Empresa = dbo.Tbl_Proveedores.Id_Empresa AND 
                      dbo.Tbl_cuentas_por_cobrar.Nit = dbo.Tbl_Proveedores.Nit INNER JOIN
                      dbo.Tbl_Ente_facturador ON dbo.Tbl_cuentas_por_cobrar.Id_Empresa = dbo.Tbl_Ente_facturador.Id_Empresa AND 
                      dbo.Tbl_cuentas_por_cobrar.Nit = dbo.Tbl_Ente_facturador.Nit AND 
                      dbo.Tbl_cuentas_por_cobrar.id_ente_facturador = dbo.Tbl_Ente_facturador.Id_Ente_facturador


GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
-- VIEW: vw_inventario_fisico
CREATE view dbo.vw_inventario_fisico as
SELECT     dbo.Tbl_inventario_fisico.Id_empresa, dbo.Tbl_inventario_fisico.Id_inventario, dbo.Tbl_inventario_fisico.Id_transac, 
                      dbo.Tbl_bodega.Nombre AS nombre_bodega, dbo.Tbl_inventario_fisico_detalle.Id_producto, dbo.Tbl_Productos.Descripcion, 
                      dbo.Tbl_inventario_fisico_detalle.Existencia, dbo.Tbl_inventario_fisico_detalle.Existencia_fisica, dbo.empresas.Nombre_Empresa, 
                      dbo.Tbl_inventario_fisico.Fecha
FROM         dbo.Tbl_inventario_fisico INNER JOIN
                      dbo.Tbl_inventario_fisico_detalle ON dbo.Tbl_inventario_fisico.Id_empresa = dbo.Tbl_inventario_fisico_detalle.Id_empresa AND 
                      dbo.Tbl_inventario_fisico.Id_inventario = dbo.Tbl_inventario_fisico_detalle.Id_inventario AND 
                      dbo.Tbl_inventario_fisico.Id_transac = dbo.Tbl_inventario_fisico_detalle.Id_transac INNER JOIN
                      dbo.Tbl_bodega ON dbo.Tbl_inventario_fisico.Id_empresa = dbo.Tbl_bodega.Id_Empresa AND 
                      dbo.Tbl_inventario_fisico.Id_bodega = dbo.Tbl_bodega.Id_Bodega INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_inventario_fisico_detalle.Id_empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.Tbl_inventario_fisico_detalle.Id_producto = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.empresas ON dbo.Tbl_inventario_fisico.Id_empresa = dbo.empresas.Id_Empresa
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
-- VIEW: VW_LISTA_SOLICITUD_DESPACHO_POR_ENTREGAR
CREATE VIEW dbo.VW_LISTA_SOLICITUD_DESPACHO_POR_ENTREGAR
AS
SELECT DISTINCT C.Id_solicitud_despacho, C.Nit_cliente
FROM            dbo.Tbl_solicitud_despacho_cliente AS C INNER JOIN
                         dbo.tbl_solicitud_Despacho_cliente_detalle AS D ON C.Id_empresa = D.Id_empresa AND C.Id_solicitud_despacho = D.Id_solicitud_despacho
WHERE        (D.Cantidad > D.Cantidad_entregada) AND (C.Status_solicitud <> 'RECHAZADA') AND (C.Ltiene_Orden_Entrega = 1)
GROUP BY C.Id_solicitud_despacho, C.Nit_cliente

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
-- VIEW: vw_orden_produccion_materia_prima
CREATE VIEW dbo.vw_orden_produccion_materia_prima
AS
SELECT     dbo.Tbl_detalle_orden_produccion.Id_Empresa, dbo.Tbl_detalle_orden_produccion.Id_Orden_produccion, dbo.Tbl_detalle_orden_produccion.Linea, 
                      dbo.Tbl_detalle_orden_produccion.Id_producto, dbo.Tbl_detalle_orden_produccion.Cantidad_a_producir, dbo.Tbl_detalle_orden_produccion.Cantidad_producida, 
                      dbo.Tbl_SProductos.Id_SProducto, dbo.Tbl_SProductos.Cantidad, dbo.Tbl_Productos.Descripcion
FROM         dbo.Tbl_cabecera_orden_produccion INNER JOIN
                      dbo.Tbl_detalle_orden_produccion ON dbo.Tbl_cabecera_orden_produccion.Id_Empresa = dbo.Tbl_detalle_orden_produccion.Id_Empresa AND 
                      dbo.Tbl_cabecera_orden_produccion.Id_Orden_produccion = dbo.Tbl_detalle_orden_produccion.Id_Orden_produccion INNER JOIN
                      dbo.Tbl_SProductos ON dbo.Tbl_detalle_orden_produccion.Id_Empresa = dbo.Tbl_SProductos.Id_Empresa AND 
                      dbo.Tbl_detalle_orden_produccion.Id_producto = dbo.Tbl_SProductos.Id_Producto INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_SProductos.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND dbo.Tbl_SProductos.Id_SProducto = dbo.Tbl_Productos.Descripcion

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
-- VIEW: vw_ordenes_compra
create view dbo.vw_ordenes_compra as
SELECT     TOP 100 PERCENT dbo.Tbl_pedidos.Id_Empresa, dbo.Tbl_pedidos.Id_Pedido, LTRIM(RTRIM(dbo.Tbl_pedidos.Nit)) 
                      + LTRIM(RTRIM(dbo.Tbl_Proveedores.Nombre)) AS NIT, LTRIM(RTRIM(dbo.Tbl_pedidos.nit_cliente)) + LTRIM(RTRIM(Tbl_Proveedores_1.Nombre)) 
                      AS nit_cliente, dbo.Tbl_detalle_pedidos.Id_Sproducto, dbo.Tbl_detalle_pedidos.Cantidad, dbo.Tbl_detalle_pedidos.Costo, 
                      dbo.Tbl_detalle_pedidos.Cantidad_recibida, dbo.Tbl_detalle_pedidos.Costo_recibida, dbo.empresas.Nombre_Empresa, 
                      dbo.Tbl_pedidos.Fecha_Pedido, dbo.Tbl_pedidos.Orden_recibida_completa
FROM         dbo.Tbl_pedidos INNER JOIN
                      dbo.Tbl_detalle_pedidos ON dbo.Tbl_pedidos.Id_Empresa = dbo.Tbl_detalle_pedidos.Id_Empresa AND 
                      dbo.Tbl_pedidos.Id_Pedido = dbo.Tbl_detalle_pedidos.Id_Pedido INNER JOIN
                      dbo.empresas ON dbo.Tbl_pedidos.Id_Empresa = dbo.empresas.Id_Empresa INNER JOIN
                      dbo.Tbl_Proveedores ON dbo.Tbl_pedidos.Id_Empresa = dbo.Tbl_Proveedores.Id_Empresa AND 
                      dbo.Tbl_pedidos.Nit = dbo.Tbl_Proveedores.Nit INNER JOIN
                      dbo.Tbl_Proveedores Tbl_Proveedores_1 ON dbo.Tbl_pedidos.Id_Empresa = Tbl_Proveedores_1.Id_Empresa AND 
                      dbo.Tbl_pedidos.nit_cliente = Tbl_Proveedores_1.Nit
ORDER BY dbo.Tbl_pedidos.Id_Pedido
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
-- VIEW: vw_ordenes_compra_detallado
CREATE VIEW dbo.vw_ordenes_compra_detallado
AS
SELECT     dbo.Tbl_pedidos.Id_Pedido, LTRIM(RTRIM(dbo.Tbl_pedidos.Nit)) + ' ' + LTRIM(RTRIM(dbo.Tbl_Proveedores.Nombre)) AS proveedor, dbo.Tbl_pedidos.Fecha_Pedido, 
                      LTRIM(RTRIM(dbo.Tbl_pedidos.nit_cliente)) + ' ' + LTRIM(RTRIM(Tbl_Proveedores_1.Nombre)) AS cliente, dbo.Tbl_detalle_pedidos.Cantidad AS cantidad_pedido, 
                      dbo.Tbl_detalle_pedidos.Costo, dbo.Tbl_detalle_pedidos.Total_pedido, dbo.Tbl_Productos.Id_Producto + ' ' + LTRIM(RTRIM(dbo.Tbl_Productos.Descripcion)) 
                      AS Producto, LTRIM(RTRIM(dbo.Tbl_tipo_ocompra.id_tipo_ocompra)) + ' ' + LTRIM(RTRIM(dbo.Tbl_tipo_ocompra.descripcion)) AS tipo_orden, 
                      dbo.Tbl_pedidos.Factura_vta, dbo.Tbl_recepcion_pedidos.Id_empresa, dbo.Tbl_recepcion_pedidos_detalle.Cantidad_por_recibir AS cantidad_recibida, 
                      dbo.Tbl_recepcion_pedidos_detalle.Precio_compra, 
                      dbo.Tbl_recepcion_pedidos_detalle.Cantidad_por_recibir * dbo.Tbl_recepcion_pedidos_detalle.Precio_compra AS totalrecibido
FROM         dbo.Tbl_recepcion_pedidos_detalle INNER JOIN
                      dbo.Tbl_recepcion_pedidos ON dbo.Tbl_recepcion_pedidos_detalle.Id_empresa = dbo.Tbl_recepcion_pedidos.Id_empresa AND 
                      dbo.Tbl_recepcion_pedidos_detalle.Id_recepcion = dbo.Tbl_recepcion_pedidos.Id_recepcion AND 
                      dbo.Tbl_recepcion_pedidos_detalle.Id_pedido = dbo.Tbl_recepcion_pedidos.Id_pedido INNER JOIN
                      dbo.Tbl_pedidos INNER JOIN
                      dbo.Tbl_detalle_pedidos ON dbo.Tbl_pedidos.Id_Empresa = dbo.Tbl_detalle_pedidos.Id_Empresa AND 
                      dbo.Tbl_pedidos.Id_Pedido = dbo.Tbl_detalle_pedidos.Id_Pedido INNER JOIN
                      dbo.Tbl_Prod_Proveedores ON dbo.Tbl_pedidos.Id_Empresa = dbo.Tbl_Prod_Proveedores.Id_Empresa AND 
                      dbo.Tbl_detalle_pedidos.Id_Sproducto = dbo.Tbl_Prod_Proveedores.Id_Alterno INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_pedidos.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.Tbl_Prod_Proveedores.Id_Producto = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.Tbl_Proveedores ON dbo.Tbl_pedidos.Id_Empresa = dbo.Tbl_Proveedores.Id_Empresa AND dbo.Tbl_pedidos.Nit = dbo.Tbl_Proveedores.Nit INNER JOIN
                      dbo.Tbl_Proveedores AS Tbl_Proveedores_1 ON dbo.Tbl_pedidos.Id_Empresa = Tbl_Proveedores_1.Id_Empresa AND 
                      dbo.Tbl_pedidos.nit_cliente = Tbl_Proveedores_1.Nit INNER JOIN
                      dbo.Tbl_tipo_ocompra ON dbo.Tbl_pedidos.Id_Empresa = dbo.Tbl_tipo_ocompra.id_empresa AND 
                      dbo.Tbl_pedidos.Id_tipo_ocompra = dbo.Tbl_tipo_ocompra.id_tipo_ocompra ON dbo.Tbl_recepcion_pedidos.Id_empresa = dbo.Tbl_pedidos.Id_Empresa AND 
                      dbo.Tbl_recepcion_pedidos.Id_pedido = dbo.Tbl_pedidos.Id_Pedido

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
-- VIEW: vw_presupuesto_new
CREATE VIEW dbo.vw_presupuesto_new
AS
SELECT     dbo.Tbl_presupuesto_servicio.Id_empresa, dbo.Tbl_presupuesto_servicio.Id_presupuesto, dbo.Tbl_presupuesto_servicio.Nit, dbo.Tbl_presupuesto_servicio.Fecha, 
                      dbo.Tbl_presupuesto_servicio.Observaciones, dbo.Tbl_presupuesto_servicio.fecha_operacion, dbo.Tbl_presupuesto_servicio.usuario, 
                      dbo.Tbl_presupuesto_servicio.num_placa, dbo.Tbl_presupuesto_servicio.tarjeta, dbo.Tbl_presupuesto_servicio.status, 
                      dbo.Tbl_presupuesto_servicio_detalle.descripción, dbo.Tbl_presupuesto_servicio_detalle.Valor, dbo.Tbl_presupuesto_servicio_detalle.autorizado, 
                      dbo.empresas.Nombre_Empresa, dbo.empresas.direccion, dbo.empresas.telefonos, dbo.empresas.fax
FROM         dbo.Tbl_presupuesto_servicio INNER JOIN
                      dbo.Tbl_presupuesto_servicio_detalle ON dbo.Tbl_presupuesto_servicio.Id_empresa = dbo.Tbl_presupuesto_servicio_detalle.Id_empresa AND 
                      dbo.Tbl_presupuesto_servicio.Id_presupuesto = dbo.Tbl_presupuesto_servicio_detalle.Id_presupuesto INNER JOIN
                      dbo.empresas ON dbo.Tbl_presupuesto_servicio.Id_empresa = dbo.empresas.Id_Empresa

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
-- VIEW: vw_solicitud_envio
CREATE view dbo.vw_solicitud_envio as
SELECT     dbo.Tbl_solicitud_despacho_cliente.Id_solicitud_despacho, dbo.Tbl_solicitud_despacho_cliente.Nit_cliente, dbo.Tbl_solicitud_despacho_cliente.Fecha_solicitud, 
                      dbo.Tbl_solicitud_despacho_cliente.Status_solicitud, dbo.Tbl_solicitud_despacho_cliente.Direccion_factura, dbo.Tbl_solicitud_despacho_cliente.Direccion_entrega, 
                      dbo.empresas.Nombre_Empresa, dbo.tbl_solicitud_Despacho_cliente_detalle.Cantidad, dbo.tbl_solicitud_Despacho_cliente_detalle.despacho_desde, 
                      dbo.tbl_solicitud_Despacho_cliente_detalle.Nit, dbo.tbl_solicitud_Despacho_cliente_detalle.Precio_vta, dbo.tbl_solicitud_Despacho_cliente_detalle.Total, 
                      dbo.tbl_solicitud_Despacho_cliente_detalle.Cantidad_entregada, dbo.tbl_solicitud_Despacho_cliente_detalle.Linea, 
                      dbo.tbl_solicitud_Despacho_cliente_detalle.Id_producto, dbo.Tbl_Productos.Descripcion, dbo.Tbl_solicitud_despacho_cliente.Id_empresa, 
                      dbo.Tbl_Proveedores.Nombre, dbo.Tbl_solicitud_despacho_cliente.Serie, dbo.Tbl_solicitud_despacho_cliente.Id_tipo, 
                      dbo.Tbl_solicitud_despacho_cliente.Numero
FROM         dbo.Tbl_solicitud_despacho_cliente INNER JOIN
                      dbo.empresas ON dbo.Tbl_solicitud_despacho_cliente.Id_empresa = dbo.empresas.Id_Empresa INNER JOIN
                      dbo.tbl_solicitud_Despacho_cliente_detalle ON dbo.Tbl_solicitud_despacho_cliente.Id_empresa = dbo.tbl_solicitud_Despacho_cliente_detalle.Id_empresa AND 
                      dbo.Tbl_solicitud_despacho_cliente.Id_solicitud_despacho = dbo.tbl_solicitud_Despacho_cliente_detalle.Id_solicitud_despacho INNER JOIN
                      dbo.Tbl_Productos ON dbo.tbl_solicitud_Despacho_cliente_detalle.Id_empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.tbl_solicitud_Despacho_cliente_detalle.Id_producto = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.Tbl_Proveedores ON dbo.Tbl_solicitud_despacho_cliente.Id_empresa = dbo.Tbl_Proveedores.Id_Empresa AND 
                      dbo.Tbl_solicitud_despacho_cliente.Nit_cliente = dbo.Tbl_Proveedores.Nit
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
-- VIEW: vw_vales_prepago_pospago
create view vw_vales_prepago_pospago
as
select 
C.ID_CLIENTE_VALE_DETALLE as id_cliente_vale, 
p.Nombre,
c.ID_EMPRESA, 
'' as serie, 
0 as numero_factura, 
c.ID_VALE_POST_PAGO,
c.ID_PRODUCTO, 
c.ID_CLIENTE_VALE_DETALLE, 
c.FECHA_VALE, 
c.VALOR_VALE,
c.CANTIDAD_VALE,
'POSPAGO' as tipo
from TBL_DETALLE_VALES_POR_APLICAR C
INNER JOIN Tbl_Proveedores P
on c.ID_CLIENTE_VALE_DETALLE = p.nit
where c.facturado = 2 
 
 UNION 

select 
C.ID_CLIENTE_VALE, 
'PP' + '- '+ PR.Nombre,  
D.ID_EMPRESA, 
D.SERIE, 
D.NUMERO_FACTURA,
D.ID_VALE_POST_PAGO, 
D.ID_PRODUCTO, 
D.ID_CLIENTE_VALE_DETALLE,
D.FECHA_VALE, 
D.VALOR_VALE, 
D.CANTIDAD_VALE,
'PREPAGO' as tipo
from TBL_CABECERA_VENTAS_VALE C
inner join TBL_DETALLE_VENTAS_VALES D
on C.ID_EMPRESA				= D.ID_EMPRESA				AND
   C.SERIE					= D.SERIE					AND
   C.NUMERO					= D.NUMERO_FACTURA 
inner join Tbl_Proveedores PR
ON   C.ID_CLIENTE_VALE		= PR.Nit   
WHERE C.TIPO_VALE = 'PREPAGO'   
   
   

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
-- VIEW: vw_ventadiariasdevales
CREATE VIEW dbo.vw_ventadiariasdevales
AS
SELECT     dbo.TBL_DETALLE_VENTA_POR_DIA.ID_EMPRESA, dbo.TBL_DETALLE_VENTA_POR_DIA.ID_TRANSACCION_VENTA, 
                      dbo.TBL_DETALLE_VENTA_POR_DIA.LINEA_VENTA_POR_DIA, dbo.TBL_DETALLE_VENTA_POR_DIA.ID_PRODUCTO, 
                      dbo.TBL_DETALLE_VENTA_POR_DIA.CANTIDAD_VENDIDA, dbo.TBL_DETALLE_VENTA_POR_DIA.TOTAL, dbo.Tbl_Productos.Descripcion, 
                      dbo.TBL_CABECERA_VENTA_POR_DIA.SERIE_FACTURA, dbo.TBL_CABECERA_VENTA_POR_DIA.DEL_NUMERO, dbo.TBL_CABECERA_VENTA_POR_DIA.AL_NUMERO, 
                      dbo.TBL_CABECERA_VENTA_POR_DIA.FECHA_VENTA, dbo.TBL_CABECERA_VENTA_POR_DIA.OBSERVACIONES, dbo.empresas.Nombre_Empresa
FROM         dbo.TBL_CABECERA_VENTA_POR_DIA INNER JOIN
                      dbo.TBL_DETALLE_VENTA_POR_DIA ON dbo.TBL_CABECERA_VENTA_POR_DIA.ID_EMPRESA = dbo.TBL_DETALLE_VENTA_POR_DIA.ID_EMPRESA AND 
                      dbo.TBL_CABECERA_VENTA_POR_DIA.ID_TRANSACCION_VENTA = dbo.TBL_DETALLE_VENTA_POR_DIA.ID_TRANSACCION_VENTA INNER JOIN
                      dbo.Tbl_Productos ON dbo.TBL_DETALLE_VENTA_POR_DIA.ID_EMPRESA = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.TBL_DETALLE_VENTA_POR_DIA.ID_PRODUCTO = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.empresas ON dbo.TBL_CABECERA_VENTA_POR_DIA.ID_EMPRESA = dbo.empresas.Id_Empresa

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
-- VIEW: vw_ventas_por_centro_costo



CREATE    view vw_ventas_por_centro_costo as
SELECT     	dbo.Tbl_Det_Facturacion.Id_Producto, 
		dbo.Tbl_Det_Facturacion.Cantidad,
		dbo.Tbl_Productos.Descripcion, 
		dbo.Tbl_Det_Facturacion.Precio_Descuento,
                      dbo.Tbl_Cab_Facturacion.Id_Empresa,
		 dbo.Tbl_Cab_Facturacion.Id_Caja,
		 dbo.Tbl_Cab_Facturacion.Autorizacion,
		 dbo.Tbl_Cab_Facturacion.Serie,
                      dbo.Tbl_Cab_Facturacion.Id_Tipo,
		 dbo.Tbl_Cab_Facturacion.Numero,
		 dbo.Tbl_Cab_Facturacion.Nit, 
		dbo.Tbl_Cab_Facturacion.Facturar_a,
		dbo.Tbl_Cab_facturacion.fecha_factura,
                      CASE WHEN dbo.Tbl_Cab_Facturacion.Contado_o_Credito = 1 THEN 'CREDITO' ELSE 'CONTADO' END AS Tipo_venta,
                      dbo.Tbl_productos_configuracion_contable.Id_Depto_vta
FROM         dbo.Tbl_Cab_Facturacion INNER JOIN
                      dbo.Tbl_Det_Facturacion ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.Tbl_Det_Facturacion.Id_Empresa AND
                      dbo.Tbl_Cab_Facturacion.Id_Caja = dbo.Tbl_Det_Facturacion.Id_Caja AND dbo.Tbl_Cab_Facturacion.Autorizacion = dbo.Tbl_Det_Facturacion.Autorizacion AND
                      dbo.Tbl_Cab_Facturacion.Serie = dbo.Tbl_Det_Facturacion.Serie AND dbo.Tbl_Cab_Facturacion.Id_Tipo = dbo.Tbl_Det_Facturacion.Id_Tipo AND
                      dbo.Tbl_Cab_Facturacion.Numero = dbo.Tbl_Det_Facturacion.Numero INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND
                      dbo.Tbl_Det_Facturacion.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND dbo.Tbl_Det_Facturacion.Id_Producto = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.Tbl_productos_configuracion_contable ON dbo.Tbl_Productos.Id_Empresa = dbo.Tbl_productos_configuracion_contable.Id_Empresa AND
                      dbo.Tbl_Productos.Id_Producto = dbo.Tbl_productos_configuracion_contable.Id_Producto
						where dbo.Tbl_Cab_Facturacion.status <>3





GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
-- VIEW: vw_ventas_por_cliente_producto
create view vw_ventas_por_cliente_producto as
select d.Autorizacion ,
c.Serie,
c.Id_Tipo,
c.Numero ,
c.Fecha_Factura ,
c.Facturar_a ,
d.Id_Producto ,
d.Descripcion_Corta ,
d.Cantidad 
from Tbl_Cab_Facturacion c inner join Tbl_Det_Facturacion d
on c.Id_Empresa=d.Id_Empresa and
c.Autorizacion =d.Autorizacion and
c.Serie =d.Serie and
c.Numero =d.Numero 
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
-- VIEW: vw_ventas_por_departamento_detallado

CREATE view vw_ventas_por_departamento_detallado as
SELECT     dbo.Tbl_Cab_Facturacion.Id_Empresa, dbo.empresas.Nombre_Empresa, dbo.Tbl_Productos.Id_Depto, dbo.Tbl_departamentos.Nombre, dbo.Tbl_Linea.Id_Linea, 
                      dbo.Tbl_Linea.Nombre_Linea, dbo.Tbl_Cab_Facturacion.Fecha_Factura, dbo.Tbl_Det_Facturacion.Id_Producto, dbo.Tbl_Productos.Descripcion, 
                      dbo.Tbl_Det_Facturacion.Cantidad, dbo.Tbl_Det_Facturacion.Precio, dbo.Tbl_Det_Facturacion.Precio_Descuento, dbo.empresas.Porcentaje_Iva_Anterior, 
                      dbo.empresas.Porcentaje_iva, dbo.empresas.apartirde, dbo.Tbl_Cab_Facturacion.Descuento AS descuentofactura
FROM         dbo.Tbl_Cab_Facturacion INNER JOIN
                      dbo.Tbl_Det_Facturacion ON dbo.Tbl_Cab_Facturacion.Id_Empresa = dbo.Tbl_Det_Facturacion.Id_Empresa AND 
                      dbo.Tbl_Cab_Facturacion.Id_Caja = dbo.Tbl_Det_Facturacion.Id_Caja AND dbo.Tbl_Cab_Facturacion.Autorizacion = dbo.Tbl_Det_Facturacion.Autorizacion AND 
                      dbo.Tbl_Cab_Facturacion.Serie = dbo.Tbl_Det_Facturacion.Serie AND dbo.Tbl_Cab_Facturacion.Id_Tipo = dbo.Tbl_Det_Facturacion.Id_Tipo AND 
                      dbo.Tbl_Cab_Facturacion.Numero = dbo.Tbl_Det_Facturacion.Numero INNER JOIN
                      dbo.Tbl_Productos ON dbo.Tbl_Det_Facturacion.Id_Empresa = dbo.Tbl_Productos.Id_Empresa AND 
                      dbo.Tbl_Det_Facturacion.Id_Producto = dbo.Tbl_Productos.Id_Producto INNER JOIN
                      dbo.Tbl_departamentos ON dbo.Tbl_Productos.Id_Empresa = dbo.Tbl_departamentos.Id_Empresa AND 
                      dbo.Tbl_Productos.Id_Depto = dbo.Tbl_departamentos.Id_depto INNER JOIN
                      dbo.empresas ON dbo.Tbl_departamentos.Id_Empresa = dbo.empresas.Id_Empresa INNER JOIN
                      dbo.Tbl_Linea ON dbo.Tbl_Productos.Id_Empresa = dbo.Tbl_Linea.Id_Empresa AND dbo.Tbl_Productos.Id_Linea = dbo.Tbl_Linea.Id_Linea AND 
                      dbo.Tbl_Productos.Id_Depto = dbo.Tbl_Linea.Id_Depto
WHERE     (dbo.Tbl_Cab_Facturacion.Status <> 3) AND
                          ((SELECT     SUM(Cantidad * Precio) - SUM(Cantidad * Precio_Descuento) AS Expr1
                              FROM         dbo.Tbl_Det_Facturacion AS j
                              WHERE     (Id_Empresa = dbo.Tbl_Cab_Facturacion.Id_Empresa) AND (Id_Caja = dbo.Tbl_Cab_Facturacion.Id_Caja) AND 
                                                    (Autorizacion = dbo.Tbl_Cab_Facturacion.Autorizacion) AND (Serie = dbo.Tbl_Cab_Facturacion.Serie) AND (Id_Tipo = dbo.Tbl_Cab_Facturacion.Id_Tipo) 
                                                    AND (Numero = dbo.Tbl_Cab_Facturacion.Numero)) = dbo.Tbl_Cab_Facturacion.Descuento)
GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
-- VIEW: vwcontabiliza_Facturasinv
CREATE VIEW dbo.vwcontabiliza_Facturasinv
AS
SELECT     dbo.Tbl_Cargos.Id_Empresa, dbo.Tbl_Cargos.Nit, dbo.Tbl_Cargos.Tipo_Cargo, dbo.Tbl_Cargos.Numero_Factura, dbo.Tbl_Cargos.Sistema, 
                      dbo.Tbl_Detalle_movimientos.Id_Producto, dbo.Tbl_productos_configuracion_contable.Id_Cuenta_vta, dbo.Tbl_productos_configuracion_contable.Id_Auxiliar_vta, 
                      dbo.Tbl_productos_configuracion_contable.Id_Depto_vta
FROM         dbo.Tbl_Cargos INNER JOIN
                      dbo.Tbl_cabecera_movimientos ON dbo.Tbl_Cargos.Id_Empresa = dbo.Tbl_cabecera_movimientos.Id_Empresa AND 
                      dbo.Tbl_Cargos.Numero_Factura = dbo.Tbl_cabecera_movimientos.Numero AND dbo.Tbl_Cargos.Nit = dbo.Tbl_cabecera_movimientos.Nit INNER JOIN
                      dbo.Tbl_Detalle_movimientos ON dbo.Tbl_cabecera_movimientos.Id_Empresa = dbo.Tbl_Detalle_movimientos.Id_Empresa AND 
                      dbo.Tbl_cabecera_movimientos.Periodo = dbo.Tbl_Detalle_movimientos.Periodo AND 
                      dbo.Tbl_cabecera_movimientos.Id_Bodega = dbo.Tbl_Detalle_movimientos.Id_Bodega AND 
                      dbo.Tbl_cabecera_movimientos.Id_Tipo = dbo.Tbl_Detalle_movimientos.Id_Tipo AND 
                      dbo.Tbl_cabecera_movimientos.Numero = dbo.Tbl_Detalle_movimientos.Numero AND 
                      dbo.Tbl_cabecera_movimientos.Nit = dbo.Tbl_Detalle_movimientos.Nit INNER JOIN
                      dbo.Tbl_productos_configuracion_contable ON dbo.Tbl_Detalle_movimientos.Id_Empresa = dbo.Tbl_productos_configuracion_contable.Id_Empresa AND 
                      dbo.Tbl_Detalle_movimientos.Id_Producto = dbo.Tbl_productos_configuracion_contable.Id_Producto
WHERE     (dbo.Tbl_Cargos.Sistema = 6)

GO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

(21 rows affected)
