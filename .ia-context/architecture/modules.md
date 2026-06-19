# Arquitectura — Módulos del Sistema

## Mapa de módulos

```
┌─────────────────────────────────────────────────────────┐
│                    MENÚ PRINCIPAL                        │
│                  frm_menu_principal                      │
└───────┬─────────────┬──────────────┬────────────────────┘
        │             │              │
   ┌────▼────┐  ┌─────▼─────┐  ┌───▼────────────────┐
   │MAESTROS │  │OPERATIVO  │  │   REPORTES          │
   └────┬────┘  └─────┬─────┘  └───┬────────────────┘
        │             │             │
   Clientes      Presupuestos  Comisiones mecánicos
   Vehículos     Órdenes OS    Comisiones facturación
   Catálogos     Facturación   Órdenes trabajadas
   Configuración              Clientes con movimiento
                              Avisos mantenimiento
                              Productos no facturados
```

---

## Módulo 1 — Gestión de Clientes
**Formularios:** `frm_clientes`, `frm_clientes_children`
**Responsabilidades:**
- CRUD de clientes
- Gestión de datos financieros (tarjeta, descuento, tipo precio) con control de privilegios
- Vista de vehículos asignados al cliente

**Inputs:** NIT (usuario)
**Outputs:** Registro de cliente disponible para presupuestos y órdenes

---

## Módulo 2 — Gestión de Vehículos
**Formularios:** `frm_vehiculos`, `frm_historial_vehiculos`, `frm_mas_datos`, `frm_mas_datos1`
**Responsabilidades:**
- CRUD de vehículos vinculados a clientes
- Datos técnicos del vehículo (motor, combustible, presión llantas)
- Historial de órdenes de servicio por placa

**Dependencias:** Cliente (por NIT), Marca, Línea, Tipo, Color

---

## Módulo 3 — Catálogos de Vehículos
**Formularios:** `frm_marcas_vehiculos`, `frm_tipos_vehiculos`, `frm_colores_vehiculos`, `frm_colores_vehiculos2`
**Responsabilidades:**
- Mantenimiento de catálogos que dependen los vehículos
- Marcas → Líneas (relación padre-hijo)
- `frm_colores_vehiculos2` es una versión modal que se abre desde el registro de vehículo

---

## Módulo 4 — Presupuestos
**Formularios:** `frm_presupuestos_new` (activo), `frm_presupuestos` (deprecado)
**Responsabilidades:**
- Crear presupuestos por cliente/vehículo
- Agregar ítems con texto libre y valor
- Marcar ítems como autorizados/no autorizados
- Imprimir presupuesto (con o sin autorizados)
- Cerrar presupuesto para conversión

**Salida:** Presupuesto status=2 listo para convertir a OS

---

## Módulo 5 — Conversión Presupuesto → Orden de Servicio
**Formulario:** `frm_genera_orden_servicio`
**Responsabilidades:**
- Validar que el presupuesto esté cerrado (status=2)
- Verificar que el número de orden destino no exista
- Ejecutar `sp_genera_orden_servicio` (solo ítems autorizados)

**Es un proceso puntual, no un formulario de navegación**

---

## Módulo 6 — Órdenes de Servicio (CENTRAL)
**Formularios:** `frm_orden_servicios`, `frm_anular_ordenes_servicio`, `frm_cambia_porcentaje_ordenes`
**Responsabilidades:**
- Gestión completa del ciclo de vida de una orden
- Registro de servicios con mecánico asignado
- Registro de insumos/repuestos con bodega de origen
- Control del límite de líneas por documento
- Cierre de orden (status 1→2)
- Reversión de cierre (solo si no facturada)
- Ajuste de descuentos

**Este es el formulario más complejo del sistema (3 niveles: cabecera + servicios + insumos)**

---

## Módulo 7 — Comisiones
**Formularios:** `frm_mantenimiento_servicios_comisiones`, `rpt_comisiones`, `rpt_comisiones_facturacion`
**Responsabilidades:**
- Configurar comisión por tipo de servicio (valor fijo o porcentaje)
- Reportar comisiones por mecánico y rango de fechas
- Reportar comisiones vinculadas a facturación

---

## Módulo 8 — Configuración de Empresa
**Formularios:** `frm_empresas`, `frm_series`, `frm_cajas`, `frm_cajeros`
**Responsabilidades:**
- Configurar parámetros de la empresa (contadores, bodega por defecto, límite líneas, período)
- Administrar series de facturación (correlativo del/al/actual)
- Asociar series a cajas
- Mantener catálogo de cajeros

---

## Módulo 9 — Entidades de Negocio
**Formularios:** `frm_vendedores`, `frm_bancos`, `frm_casas_credito`
**Responsabilidades:**
- Catálogo de vendedores/empleados con porcentaje de comisión
- Catálogo de bancos (para pagos)
- Catálogo de casas de crédito (tarjetas de crédito)

---

## Módulo 10 — Inventario / Bodega
**Formularios:** `frm_existencia_bodega`
**Responsabilidades:**
- Consulta de existencia de productos por bodega
- Solo lectura — la gestión de inventario es un módulo externo (sistema de inventarios)

**Nota:** El sistema se conecta a una BD llamada `inventarios` / `db_inventario_pfp`

---

## Módulo 11 — Reportes
**Formularios:** `frm_historial_facturas`, `frm_reporte_servicios`, `frm_reporte_ordenes_trabajadas`, `frm_reporte_avisos`, `frm_reporte_productos_no_facturados`, `rpt_clientes_mov`

| Reporte | Filtros | Salida |
|---------|---------|--------|
| Historial facturas | empresa, caja, fecha_ini, fecha_fin | Facturas emitidas |
| Órdenes de servicio | empresa, id_orden | Una OS impresa |
| Órdenes trabajadas | empresa, empleado/TODOS, fecha_ini, fecha_fin | Por mecánico |
| Avisos mantenimiento | empresa, rango fechas servicio, fecha sugerida | Recordatorios |
| Productos no facturados | empresa | Productos en OS sin facturar |
| Clientes con movimiento | empresa, fecha_ini, fecha_fin | Clientes activos |
| Comisiones mecánicos | empresa, empleado/TODOS, fecha_ini, fecha_fin | Comisiones |
| Comisiones facturación | empresa, empleado/TODOS, fecha_ini, fecha_fin | Por factura |
| Presupuesto por autorizar | empresa, id_presupuesto | Para firma cliente |

---

## Módulo 12 — Consulta OLAP
**Formulario:** `frm_consulta_servicios`
**Responsabilidades:**
- Análisis multidimensional de órdenes de servicio
- Usa control OLE ContourCubeLite (propietario)
- SP: `co_ordenes_servicio` (parámetro hardcoded = 1)

**En nuevo sistema:** Reemplazar con herramienta BI moderna

---

## Módulo 13 — Utilitarios
**Formularios:** `frm_pantalla_busqueda`, `frm_selecciona_empresas`
- `frm_pantalla_busqueda`: Buscador genérico parametrizable reutilizado en múltiples módulos
- `frm_selecciona_empresas`: Login y selección de empresa — define sesión global
