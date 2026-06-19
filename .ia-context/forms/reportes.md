# Formularios — Reportes

Todos los formularios de reporte siguen el mismo patrón:
1. El usuario selecciona filtros (fechas, empleado, empresa, etc.)
2. Se llama al archivo `.rpt` de Crystal Reports con los parámetros
3. Se muestra vista previa o se imprime directamente

---

## frm_historial_facturas
**Filtros:** fecha_inicial, fecha_final
**Reporte:** `rpt_historial_facturas.rpt(nEmpresa, ncaja, fecha_inicial, fecha_final)`
**Nota:** Requiere `ncaja` (variable global — login de cajero)

---

## frm_reporte_servicios
**Filtros:** Combo de órdenes
**SQL para poblar el combo:**
```sql
SELECT Id_Orden, Facturar_a, num_placa
FROM tbl_orden_Servicio
WHERE ID_EMPRESA = ?NEMPRESA
```
**Reporte:** `rpt_servicios.rpt(nEmpresa, id_orden)`

---

## frm_reporte_ordenes_trabajadas
**Filtros:** vendedor (combo de empleados o "TODO"), fecha_inicial, fecha_final
**Reporte:** `rpt_ordenes_trabajadas.rpt(nEmpresa, id_empleado|'TODO', fecha_ini, fecha_fin)`
**Caso "TODOS":** Se pasa el string literal `'TODO'` (4 chars)

---

## frm_reporte_avisos
**Filtros:** fecha (inicio rango OS), fechaal (fin rango OS), fechasugerida (próximo servicio)
**Reporte:** `rpt_avisos.rpt(nEmpresa, fecha, fechaal, fechasugerida)`
**Uso:** Genera recordatorios para clientes cuyo vehículo necesita mantenimiento

---

## frm_reporte_productos_no_facturados
**Filtros:** Solo empresa (nEmpresa implícito)
**Reporte:** `productos_ordenados_nofacturados.rpt(nEmpresa)`

---

## rpt_clientes_mov
**Privilegio requerido:** `rpt_clientes_con_movimiento`
**Filtros:** fecha_inicial, fecha_final
**Herramienta:** Crystal Reports v9

---

## rpt_comisiones
**Filtros:** vendedor/mecánico (combo o "TOD"), fecha_inicial, fecha_final
**Reporte:** `rpt_comisiones_mecanicos.rpt(nEmpresa, id_empleado|'TOD', fecha_ini, fecha_fin)`
**Caso "TODOS":** Se pasa el string `'TOD'` (3 chars — diferente a frm_reporte_ordenes_trabajadas)

---

## rpt_comisiones_facturacion
**Idéntico en estructura a rpt_comisiones.**
Misma clase `frmcomisiones` — formulario duplicado.
Diferencia conceptual: uno es por servicios realizados, este por servicios facturados.
**Reporte:** Mismo archivo .rpt pero diferente parámetro implícito.

---

## rpt_presupuesto_por_autorizar
**Filtros:** Número de presupuesto (máscara "99999999")
**Reporte:** `rpt_presupuesto_por_autorizar.rpt(nEmpresa, id_presupuesto)`
**Uso:** Se imprime para que el cliente firme cada ítem que autoriza

---

## Tabla resumen de parámetros "TODOS"
Los reportes de filtro por empleado usan strings distintos para "todos":
| Reporte | String para "todos" |
|---------|-------------------|
| rpt_ordenes_trabajadas | `'TODO'` (4 chars) |
| rpt_comisiones_mecanicos | `'TOD'` (3 chars) |
En el nuevo sistema: **estandarizar** a `null` o un valor consistente.
