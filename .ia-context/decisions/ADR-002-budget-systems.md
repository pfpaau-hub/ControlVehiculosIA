# ADR-002 — Dos Sistemas de Presupuestos Paralelos

**Estado:** Decisión pendiente de confirmar con el usuario
**Fecha:** 2026-06-17

## Contexto
El sistema tiene **dos implementaciones de presupuestos** que coexisten:

**Sistema A (antiguo) — `frm_presupuestos`:**
- Usa tablas: `presupuesto_ordenes`, `presupuesto_ordenes_detalle`, `presupuesto_ordenes_detalle_integracion`
- Reutiliza alias VFP de órdenes de servicio (`orden_servicio`, `detalle_servicios`) apuntando a tablas de presupuesto — muy confuso
- Misma estructura 3 niveles que una OS (cabecera + servicios + insumos)
- Reporte: `rpt_presupuestos.rpt` con parámetro tipo='P'
- Acceso: No está en el menú principal actual

**Sistema B (nuevo/activo) — `frm_presupuestos_new`:**
- Usa tablas: `tbl_presupuesto_servicio`, `tbl_presupuesto_servicio_detalle`
- Estructura más simple: cabecera + detalle con texto libre y valor
- El detalle tiene campo `autorizado` (checkbox por ítem)
- Reporte: `rpt_presupuesto_new.rpt`
- Acceso: Es el que llama `frm_menu_principal`
- ID via `IDENTITY` de SQL Server

## Decisión recomendada
**Usar solo el Sistema B** para la recreación. El Sistema A parece haber sido reemplazado.

Razones:
- El menú principal ya no llama al Sistema A
- El Sistema B tiene una estructura más limpia (sin alias confusos)
- La conversión `sp_genera_orden_servicio` trabaja con el Sistema B
- Los ítems con campo `autorizado` permiten un flujo de aprobación por ítem

## Pendiente confirmar
- ¿Existe data de presupuestos antiguos en las tablas del Sistema A que deba migrarse?
- ¿El Sistema A sigue siendo usado por algún usuario de alguna manera?
- ¿La conversión presupuesto→OS del Sistema A (diferente estructura) está siendo usada?

## Consecuencias si se acepta
- Solo implementar el Sistema B en el nuevo sistema
- Migrar datos de `presupuesto_ordenes*` a `tbl_presupuesto_servicio*` si existen registros
- Eliminar el Sistema A de la base de datos
