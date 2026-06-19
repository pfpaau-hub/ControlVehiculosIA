# Formularios — Configuración del Sistema

## frm_empresas
**Tipo:** Formulario de configuración
**Tabla:** `empresas`

| Campo | Reglas en UI |
|-------|-------------|
| nombre_empresa | Solo lectura |
| sig_orden_servicio | Editable — siguiente número de OS a asignar |
| id_bodega_facturacion | Combo de bodegas — bodega por defecto para facturación |
| total_detalle_lineas | Spinner — límite de líneas por documento |
| periodo | Período contable activo (MM/AAAA) |

**Nota:** `sig_numero_presupuesto` se gestiona automáticamente, no aparece en la UI.

---

## frm_series
**Tipo:** CRUD
**Tabla:** `series`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| autorizacion | varchar(20) | Número de autorización SAT/fiscal |
| serie | varchar(10) | Serie del correlativo |
| id_tipo | int | Tipo de documento |
| del | int | Correlativo inicial del rango |
| al | int | Correlativo final del rango |
| actual | int | Correlativo actual (se incrementa al emitir) |
| fecha_ingreso | datetime | |
| descripcion | varchar(100) | |
| status | varchar(10) | 'Alta'=activa, 'Baja'=inactiva |

**Regla:** Solo las series con `status='Alta'` están disponibles para emitir documentos.

---

## frm_cajas
**Tipo:** CRUD con detalle
**Tablas:** `cajas` (padre) + `cajas_series` (detalle)

| Tabla | Campos |
|-------|--------|
| cajas | id_caja (PK), observaciones |
| cajas_series | id_caja (FK), autorizacion, serie, id_tipo |

**Uso:** La variable de sesión `ncaja` identifica la caja activa del usuario actual.

---

## frm_cajeros
**Tipo:** CRUD simple
**Tabla:** `cajeros`

| Campo | Tipo |
|-------|------|
| id_cajero | int PK |
| nombre | varchar |

---

## frm_existencia_bodega
**Tipo:** Popup de solo lectura
**Tabla:** `existencias_producto` (NoDataOnLoad — se carga al abrir)

| Campo mostrado | Descripción |
|---------------|-------------|
| id_bodega | FK bodega |
| nombre | Nombre de la bodega |
| existencia | Cantidad disponible |

**Se abre desde:** `frm_orden_servicios` al agregar un insumo (para ver disponibilidad antes de seleccionar bodega).
