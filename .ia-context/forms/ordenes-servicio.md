# Formularios — Órdenes de Servicio

## frm_orden_servicios
**Tipo:** CRUD central — formulario más complejo del sistema
**Niveles:** 3 (cabecera + detalle servicios + insumos)

### Cursores / DataEnvironment
| Cursor | Tabla real | BufferMode |
|--------|-----------|-----------|
| orden_servicio | tbl_orden_servicio | - |
| vendedores | vendedores | - |
| detalle_servicios | detalle_servicios | 5 (optimistic row) |
| servicios | tbl_productos (es_servicio=1) | - |
| clientes | clientes | - |
| vehiculos | vehiculos | - |
| ordenes_servicio_integracion | ordenes_servicio_integracion | 5 |
| productos | tbl_productos (es_servicio=0) | - |
| bodegas | bodegas | - |
| existencias_producto | existencias | NoDataOnLoad=.T. |
| empresas | empresas | filtro: Id_Empresa=nEmpresa |

### Campos cabecera
| Campo | Reglas |
|-------|--------|
| id_orden | Máscara "9999999999", requerido, de empresas.sig_orden_servicio |
| nit | Combo cbonit (por NIT), requerido |
| num_placa | Combo cboplacas (filtrado por nit), requerido |
| facturar_a | Se carga del cliente, editable |
| fecha | Fecha apertura |
| recibe_orden | Combo cborecibe (vendedores), requerido |
| fecha_cierre | Solo lectura |
| status | 1=Abierta, 2=Cerrada |
| tarjeta | Del cliente |
| proximo_servicio | Máscara "9999999999" — km/lectura próximo servicio |
| lectura_actual | Máscara "9999999999" — km/lectura actual |

### Campos detalle servicios (grilla)
| Campo | Tipo | Reglas |
|-------|------|--------|
| linea | int | Autoincremental, no editable |
| id_servicio | int | FK tbl_productos, selector con quickfind por descripcion_corta |
| id_empleado | int | FK vendedores (mecánico), requerido |
| fosa | varchar | Fosa asignada |
| cantidad | decimal(28,2) | |
| precio | decimal(18,2) | |
| precio_descuento | decimal(18,2) | |
| otros | decimal(18,2) | Calculado: subtotal insumos |
| otros_descuento | decimal(18,2) | Calculado |
| total_linea | decimal(18,2) | Calculado |
| total_linea_descuento | decimal(18,2) | Calculado |

### Campos insumos/integración (segunda grilla)
| Campo | Tipo | Reglas |
|-------|------|--------|
| linea_det | int | Autoincremental |
| id_producto | int | FK tbl_productos (es_servicio=0) |
| id_bodega | int | FK bodegas, requerido |
| se_cobra | varchar(1) | "S"/"N" |
| cantidad | decimal(28,2) | |
| precio | decimal(18,2) | |
| precio_descuento | decimal(18,2) | |
| total_linea | decimal(18,2) | |
| total_linea_descuento | decimal(18,2) | |
| periodo | varchar(7) | = cPeriodo global |

### SQL directo desde este formulario
```sql
-- Validación de duplicado en FieldValid del campo id_orden:
SELECT Id_Orden FROM Tbl_Orden_Servicio
WHERE Id_Empresa = ?nEmpresa
  AND Id_Orden = ?nOrden
  AND status = 2

-- Función escalar para contar líneas:
SELECT dbo.total_lineas_orden(?nempresa, ?nOrden)
```

### Reglas de negocio críticas
1. **Validación al cerrar:** `nit`, `num_placa`, `recibe_orden` no vacíos AND total > 0
2. **Límite de líneas:** `dbo.total_lineas_orden(empresa, orden)` ≤ `empresas.total_detalle_lineas`
3. **Cierre:** cambia `status=2`, registra `fecha_cierre`
4. **Reporte:** `rpt_servicios.rpt(nEmpresa, id_orden, 'O')`
5. El campo `loverwrite=.T.` permite sobrescribir sin conflicto de concurrencia

---

## frm_genera_orden_servicio
**Tipo:** Diálogo modal — proceso de conversión
**Precondición:** Presupuesto con status=2

### Flujo
```
1. Usuario ingresa número de orden destino
2. Verifica que la orden no exista:
   SELECT * FROM tbl_orden_servicio
   WHERE id_empresa = ?nempresa AND id_orden = ?norden
3. Ejecuta conversión:
   EXEC sp_genera_orden_servicio ?nempresa, ?npresupuesto, ?norden
```
**Nota:** Solo convierte ítems con `autorizado=1` del presupuesto.

---

## frm_anular_ordenes_servicio
**Tipo:** Diálogo administrativo

### SQL
```sql
-- Carga combo de órdenes reversibles:
SELECT * FROM tbl_orden_servicio
WHERE id_empresa = ?nEmpresa
  AND status = 2
  AND fecha_facturacion IS NULL

-- Revierte:
UPDATE tbl_orden_servicio
SET status = 1
WHERE id_Empresa = ?nEmpresa
  AND id_orden = ?cOrden
  AND status = 2
  AND numero = 0   -- ← CLAVE: solo si no facturada
```

---

## frm_cambia_porcentaje_ordenes
**Tipo:** Herramienta administrativa (acción destructiva/irreversible)

### SP
```sql
EXEC sp_cambia_descuento_ordenes ?nempresa, ?norden, ?naplica_descuento
-- naplica_descuento: 0 = no aplica descuento, 1 = aplica descuento
```
