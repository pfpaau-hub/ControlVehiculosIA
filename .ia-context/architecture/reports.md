# Arquitectura — Reportes

## Herramienta original
Crystal Reports v9 — archivos `.rpt` referenciados desde `_screen.cReportes`

## Todos los reportes del sistema

| Archivo .rpt | Formulario que lo llama | Parámetros | Descripción |
|-------------|------------------------|-----------|-------------|
| `rpt_servicios.rpt` | frm_reporte_servicios, frm_historial_vehiculos, frm_orden_servicios | `(nEmpresa, id_orden, tipo)` tipo='O' orden / 'P' presupuesto | Imprime una orden de servicio o presupuesto |
| `rpt_presupuesto_new.rpt` | frm_presupuestos_new | `(id_empresa, id_presupuesto, autorizado)` autorizado=0 todos / 1 solo autorizados | Presupuesto nuevo formato |
| `rpt_presupuesto_por_autorizar.rpt` | rpt_presupuesto_por_autorizar | `(nEmpresa, id_presupuesto)` | Presupuesto para firma del cliente |
| `rpt_historial_facturas.rpt` | frm_historial_facturas | `(nEmpresa, ncaja, fecha_inicial, fecha_final)` | Historial de facturas por caja y fechas |
| `rpt_ordenes_trabajadas.rpt` | frm_reporte_ordenes_trabajadas | `(nEmpresa, id_empleado/'TODO', fecha_ini, fecha_fin)` | Servicios por mecánico |
| `rpt_avisos.rpt` | frm_reporte_avisos | `(nEmpresa, fecha, fechaal, fechasugerida)` | Avisos de mantenimiento próximo |
| `rpt_comisiones_mecanicos.rpt` | rpt_comisiones | `(nEmpresa, id_empleado/'TOD', fecha_ini, fecha_fin)` | Comisiones por mecánico |
| `rpt_comisiones_mecanicos.rpt` | rpt_comisiones_facturacion | `(nEmpresa, id_empleado/'TOD', fecha_ini, fecha_fin)` | Comisiones por facturación |
| `productos_ordenados_nofacturados.rpt` | frm_reporte_productos_no_facturados | `(nEmpresa)` | Productos en OS sin facturar |
| `rpt_presupuestos.rpt` | frm_presupuestos (deprecado) | `(nEmpresa, id_orden, 'P')` | Presupuesto versión antigua |

## Nota sobre el parámetro "TODOS / TOD"
Los reportes de comisiones y órdenes trabajadas tienen la opción de filtrar por un mecánico específico o por todos. En el código VFP:
- Se pasa el string `'TODO'` o `'TOD'` (3 caracteres) cuando se selecciona "Todos"
- El reporte Crystal Reports maneja este caso especial internamente

## En el nuevo sistema
Reemplazar Crystal Reports con generación de PDF moderna:
- **Backend**: Librería de PDF (JasperReports, iText, Puppeteer, WeasyPrint, etc.)
- **Frontend**: Vista previa en el navegador antes de imprimir
- Mantener los mismos parámetros lógicos de cada reporte
- Considerar exportación a Excel además de PDF
