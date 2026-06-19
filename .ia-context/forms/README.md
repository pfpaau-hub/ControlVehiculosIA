# Formularios — Índice

40 formularios VFP analizados. Los archivos .scx son binarios; el código fuente real está en los .SCT.

## Mapa de archivos de este directorio
| Archivo | Formularios que cubre |
|---------|----------------------|
| clientes.md | frm_clientes, frm_clientes_children |
| vehiculos.md | frm_vehiculos, frm_historial_vehiculos, frm_mas_datos, frm_mas_datos1 |
| ordenes-servicio.md | frm_orden_servicios, frm_genera_orden_servicio, frm_anular_ordenes_servicio, frm_cambia_porcentaje_ordenes |
| presupuestos.md | frm_presupuestos_new, frm_presupuestos (deprecado), rpt_presupuesto_por_autorizar |
| catalogos.md | frm_marcas_vehiculos, frm_tipos_vehiculos, frm_colores_vehiculos, frm_colores_vehiculos2, frm_vendedores, frm_bancos, frm_casas_credito, frm_mantenimiento_servicios_comisiones |
| configuracion.md | frm_empresas, frm_series, frm_cajas, frm_cajeros, frm_existencia_bodega |
| reportes.md | frm_historial_facturas, frm_reporte_servicios, frm_reporte_ordenes_trabajadas, frm_reporte_avisos, frm_reporte_productos_no_facturados, rpt_clientes_mov, rpt_comisiones, rpt_comisiones_facturacion |
| utilitarios.md | frm_menu_principal, frm_selecciona_empresas, frm_pantalla_busqueda, frm_consulta_servicios |
| deprecated.md | frm_pruebas, frm_orden_serviciosbackup, frm_presupuestos (alias confusos) |

## Resumen rápido de todos los formularios

| Formulario | Módulo | Tipo | Notas |
|-----------|--------|------|-------|
| frm_clientes | Clientes | CRUD | NIT inmutable, privilegios por campo |
| frm_clientes_children | Clientes | Modal | Datos financieros (tarjeta, descuento, crédito) |
| frm_vehiculos | Vehículos | CRUD | Combo líneas filtra por marca |
| frm_historial_vehiculos | Vehículos | Solo lectura | Hijo de frm_vehiculos |
| frm_mas_datos | Vehículos | Info | Datos vehículo en contexto de OS |
| frm_mas_datos1 | Vehículos | Info modal | Mismos datos, versión modal |
| frm_presupuestos_new | Presupuestos | CRUD | **Versión ACTIVA** |
| frm_presupuestos | Presupuestos | CRUD | **DEPRECADO** — alias confusos |
| frm_genera_orden_servicio | OS | Proceso | Convierte presupuesto→OS |
| frm_orden_servicios | OS | CRUD | Formulario CENTRAL del sistema |
| frm_orden_serviciosbackup | OS | CRUD | **BACKUP** — no en menú |
| frm_anular_ordenes_servicio | OS | Admin | Revierte cierre (si no facturada) |
| frm_cambia_porcentaje_ordenes | OS | Admin | Resetea descuento |
| frm_marcas_vehiculos | Catálogos | CRUD | Padre-hijo con líneas |
| frm_tipos_vehiculos | Catálogos | CRUD | Estilo de vehículo |
| frm_colores_vehiculos | Catálogos | CRUD | |
| frm_colores_vehiculos2 | Catálogos | Modal | Se abre desde frm_vehiculos |
| frm_vendedores | Catálogos | CRUD | Empleados/mecánicos con % comisión |
| frm_bancos | Catálogos | CRUD | |
| frm_casas_credito | Catálogos | CRUD | Tarjetas de crédito |
| frm_mantenimiento_servicios_comisiones | Catálogos | CRUD | Comisión por tipo de servicio |
| frm_empresas | Config | Config | Contadores, período, bodega, límite líneas |
| frm_series | Config | CRUD | Series de facturación |
| frm_cajas | Config | CRUD | Cajas con series |
| frm_cajeros | Config | CRUD | |
| frm_existencia_bodega | Inventario | Solo lectura | Existencia por bodega |
| frm_historial_facturas | Reportes | Filtros | Rango fechas + caja |
| frm_reporte_servicios | Reportes | Filtros | Por número de orden |
| frm_reporte_ordenes_trabajadas | Reportes | Filtros | Por mecánico + fechas |
| frm_reporte_avisos | Reportes | Filtros | Avisos de mantenimiento |
| frm_reporte_productos_no_facturados | Reportes | Filtros | Sin facturar |
| rpt_clientes_mov | Reportes | Filtros | Clientes activos en rango |
| rpt_comisiones | Reportes | Filtros | Comisiones mecánicos |
| rpt_comisiones_facturacion | Reportes | Filtros | Comisiones por factura |
| rpt_presupuesto_por_autorizar | Reportes | Filtros | Para firma cliente |
| frm_menu_principal | Utilitarios | Menú | Menú gráfico principal |
| frm_selecciona_empresas | Utilitarios | Login | Define sesión global |
| frm_pantalla_busqueda | Utilitarios | Genérico | Buscador parametrizable |
| frm_consulta_servicios | Utilitarios | OLAP | ContourCubeLite |
| frm_pruebas | Deprecated | Dev | **NO PRODUCTIVO** |
