# Memoria — Reglas de Negocio

## Flujo principal
```
Cliente → Vehículo → [Presupuesto →] Orden de Servicio → Facturación → Reportes/Comisiones
```
El presupuesto es opcional; una orden de servicio puede crearse directamente.

---

## Clientes
- El NIT es la clave primaria y es **inmutable** después de creado
- Solo se habilita para edición en modo "Nuevo registro"
- El porcentaje de descuento solo se activa si el cliente tiene tarjeta registrada
- `sp_buscar_cliente` solo devuelve clientes con `estado=1` (activos)
- Cada campo financiero tiene control de privilegio independiente (ver `session-model.md`)

## Vehículos
- El combo de líneas se recarga filtrado por marca al cambiar la marca
- El color es **obligatorio** — validación explícita antes de guardar
- Un vehículo pertenece a un cliente vía NIT (FK)
- Se puede agregar un color nuevo sin salir del formulario de vehículo

## Presupuestos
- Existen **dos versiones** en el sistema; la activa es `frm_presupuestos_new`
- El ID es un `IDENTITY` de SQL Server — se obtiene con `IDENT_CURRENT()` después del INSERT
- Cada ítem del detalle puede marcarse como `autorizado=1` o `autorizado=0` por el cliente
- Para convertir a Orden de Servicio, el presupuesto debe estar `status=2` (cerrado)
- La conversión solo incluye ítems con `autorizado=1`

## Órdenes de Servicio
**Ciclo de vida:**
```
status=1 (Abierta)
  → agregar servicios + insumos
  → validar: nit, num_placa, recibe_orden no vacíos AND total > 0
status=2 (Cerrada)
  → registra fecha_cierre
  → [facturación externa] → numero > 0, fecha_facturacion SET
```

**Reversa de cierre:**
- Solo se puede revertir si: `status=2 AND numero=0 AND fecha_facturacion IS NULL`
- Si ya tiene número de factura (`numero > 0`), no se puede revertir

**Numeración:**
- El número de orden se toma de `empresas.sig_orden_servicio` (autoincrementa)
- Hay un límite de líneas por documento configurado en `empresas.total_detalle_lineas`
- Se valida con `dbo.total_lineas_orden(empresa, orden)`

**Servicios en la orden:**
- Cada servicio requiere un **mecánico asignado** (`id_empleado`)
- Tipo servicio: `tbl_productos WHERE es_servicio=1`

**Insumos en la orden:**
- Cada insumo requiere **bodega de origen** (`id_bodega`) — obligatorio
- Campo `se_cobra` ('S'/'N') indica si el insumo se cobra al cliente o es costo del taller
- El campo `periodo` se asigna desde `cPeriodo` (período contable activo)

## Comisiones
- Tipo 1 = valor fijo (`valor_comision`)
- Tipo 2 = porcentaje (`porcentaje_comision`)
- Se asignan por servicio, no por mecánico
- Los servicios son `tbl_productos WHERE es_servicio=1`
- Los reportes filtran por empleado y rango de fechas; opción "TODOS" = todos los mecánicos

## Facturación
- La facturación es un módulo **externo** al sistema VFP actual
- El sistema solo ve el resultado: `numero > 0` y `fecha_facturacion SET`
- Las series de facturación tienen correlativo con rango `del`/`al`/`actual`
- La caja activa (`ncaja`) es requerida para reportes de historial

## Avisos de mantenimiento
- Se generan en `frm_reporte_avisos` filtrando por rango de fechas de servicio y fecha sugerida de próximo servicio
- El campo `proximo_servicio` (lectura/km) en la OS registra cuándo debe volver el vehículo

## Reglas de estado por entidad
| Entidad | Campo | Valores y significado |
|---------|-------|----------------------|
| Cliente | estado | 1=activo, 0=inactivo |
| Orden Servicio | status | 1=Abierta, 2=Cerrada |
| Orden Servicio | numero | 0=sin facturar, >0=número factura |
| Presupuesto | status | 1=Abierto, 2=Cerrado |
| Detalle Presupuesto | autorizado | 0=no autorizado, 1=autorizado |
| Serie | status | "Alta"=activa, "Baja"=inactiva |
| Vendedor/Empleado | status | "A"=Activo, "B"=Baja |
| Insumo OS | se_cobra | "S"=cobra al cliente, "N"=costo del taller |
