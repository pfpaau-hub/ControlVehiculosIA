# Formularios — Presupuestos

## IMPORTANTE: Dos sistemas paralelos
Ver ADR-002 para la decisión. El sistema activo es `frm_presupuestos_new`.

---

## frm_presupuestos_new ← VERSIÓN ACTIVA
**Tipo:** CRUD
**Tablas:** `tbl_presupuesto_servicio` (cabecera) + `tbl_presupuesto_servicio_detalle` (ítems)
**Acceso:** Desde frm_menu_principal (botón "Presupuesto Servicio")

### Campos cabecera
| Campo | Tipo | Reglas |
|-------|------|--------|
| id_presupuesto | int IDENTITY | PK — obtenido con IDENT_CURRENT() después del INSERT |
| id_empresa | int | FK empresa |
| nit | varchar(20) | FK cliente, requerido |
| num_placa | varchar(10) | FK vehículo (filtrado por nit) |
| tarjeta | varchar(20) | Del cliente |
| fecha | datetime | |
| observaciones | varchar(200) | |
| status | int | 1=Abierto, 2=Cerrado (para convertir a OS) |

### Campos detalle
| Campo | Tipo | Reglas |
|-------|------|--------|
| id_detalle | int | PK IDENTITY |
| id_presupuesto | int | FK cabecera |
| descripcion | varchar(250) | Texto libre |
| valor | decimal(18,2) | |
| autorizado | bit | Checkbox — cliente aprueba o no cada ítem |

### SQL directo
```sql
-- Obtener ID generado después de insertar:
SELECT ISNULL(IDENT_CURRENT('TBL_PRESUPUESTO_SERVICIO'), 0) AS ultimo
```

### Búsqueda de placa
- Filtra por cursor `placascontarjeta` (vehículos con tarjeta registrada: NUM_PLACA, NIT, TARJETA)

### Reportes
- `rpt_presupuesto_new.rpt(id_empresa, id_presupuesto, 0)` → todos los ítems
- `rpt_presupuesto_new.rpt(id_empresa, id_presupuesto, 1)` → solo autorizados

### Regla de conversión a OS
1. Presupuesto debe estar con `status=2` (cerrado)
2. Desde `frm_genera_orden_servicio`, llamar `sp_genera_orden_servicio`
3. Solo pasan ítems con `autorizado=1`

---

## frm_presupuestos — DEPRECADO
**Tablas:** `presupuesto_ordenes*` con alias de órdenes (confuso)
**Acceso:** No está en el menú principal actual

### El problema de alias
```
Alias VFP            → Tabla real en BD
orden_servicio       → presupuesto_ordenes
detalle_servicios    → presupuesto_ordenes_detalle
ordenes_servicio_integracion → presupuesto_ordenes_detalle_integracion
```
El código usa los mismos alias que el formulario de órdenes pero apunta a tablas de presupuesto.
Esto causó mucha confusión en el análisis y probablemente en el desarrollo también.

**En nuevo sistema: NO recrear este formulario. Usar solo frm_presupuestos_new como referencia.**

---

## rpt_presupuesto_por_autorizar
**Tipo:** Formulario de selección de reporte
**Campo:** Número de presupuesto (máscara "99999999")
**Reporte:** `rpt_presupuesto_por_autorizar.rpt(nEmpresa, id_presupuesto)`
**Uso:** Imprime el presupuesto para que el cliente firme la autorización
