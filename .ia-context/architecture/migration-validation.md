# Validación de Migración — ControlVehiculosIA

> Análisis generado: 2026-06-18
> Fuentes analizadas: `extracted/inventario/06-stored-procedures.sql` (275 SPs), `08-triggers.sql` (119 triggers), `07-vistas.sql` (21 vistas), DDL completo, formularios documentados en `.ia-context/forms/`, y reglas de negocio en `.ia-context/memory/`.

---

## 1. Inventario de Lógica por Módulo

### Módulo: Clientes

**SPs que cubren este módulo:**
| SP | Qué hace |
|----|----------|
| `Clintes_tarjeta_beneficio` | Lista clientes con tarjeta registrada (`tarjeta <> ' '`) — usado para búsqueda de vehículos por tarjeta |
| `rpt_catalogo_clientes` | Reporte de catálogo de clientes |
| `rpt_Clintes_tarjeta_beneficio` | Versión reporte del SP anterior |
| `sp_lista_nit_seleccion` | Lista NITs para combo de selección |
| `sp_crea_proveedores_nuevos` | Crea nuevo cliente/proveedor (en `Tbl_Proveedores`) |
| `sp_documentos_cliente` | Documentos pendientes de un cliente |
| `sp_verifica_credito_cl` | Verifica límite de crédito del cliente |

**Triggers en tablas de clientes:**
- `T_I_Tbl_Proveedores` (INSERT) — registra nueva entrada, valida integridad
- `T_U_Tbl_Proveedores` (UPDATE) — actualiza `fecha_ult_mov` implícitamente; mantiene integridad referencial
- `T_D_Tbl_Proveedores` (DELETE) — impide borrado si hay referencias en OS, vehículos u otros documentos

**Cobertura de business-rules:**
- NIT inmutable después de creado: la lógica es del formulario VFP (readonly en modo edición). **NO está en SPs ni triggers.**
- `sp_buscar_cliente` documentado en business-rules como `estado=1`: **NO EXISTE** en el listado real de SPs. Los formularios VFP consultan directamente la tabla con filtros inline.
- Porcentaje de descuento activo solo con tarjeta: lógica VFP pura, no en BD.
- Privilegios por campo (tarjeta, descuento, forma de pago, tipo precio, dias_credito): lógica VFP pura.

---

### Módulo: Vehículos

**SPs que cubren este módulo:**
| SP | Qué hace |
|----|----------|
| `rpt_vehiculos` | Lista vehículos de la empresa — **ATENCIÓN: tiene filtro hardcodeado** `WHERE marca='honda' AND color='azul'`, parece SP de prueba |
| `rpt_marcas` | Lista de marcas |
| `rpt_colores` | Lista de colores |

**Triggers:**
- `t_d_tbl_vehiculos` (DELETE) — protege integridad referencial; impide borrar vehículos con OS asociadas
- No hay trigger INSERT ni UPDATE en `Tbl_Vehiculos`

**SPs notablemente AUSENTES:**
- `sp_insertavehiculo` — documentado en technical-debt (BUG-001 del campo Puertas). **No aparece en el listado real de SPs**. O el VFP hace inserts directos, o el SP fue eliminado.
- `sp_buscar_vehiculo` — no existe. Los combos VFP consultan la tabla directamente.

**Cobertura de business-rules:**
- Color obligatorio: validación en formulario VFP. No hay constraint NOT NULL verificable ni trigger.
- Recarga combo líneas por marca: lógica de UI pura, VFP.
- Agregar color nuevo inline: abre formulario hijo en VFP, insert directo a `Tbl_colores`.
- BUG-001 (Puertas mapeado como Modelo): si `sp_insertavehiculo` no existe, este bug puede estar en el formulario VFP como XML parseado — **necesario confirmar con código VFP**.

---

### Módulo: Presupuestos

**SPs que cubren este módulo:**
| SP | Qué hace |
|----|----------|
| `rpt_presupuesto_new` | Imprime presupuesto usando `vw_presupuesto_new` + JOIN a `Tbl_Proveedores` + `empresas` |
| `sp_genera_orden_servicio` | Convierte presupuesto → OS (ver análisis detallado en Sección 2) |
| `rpt_Orden_servicio` | Con `@tipo='P'` imprime desde tablas de presupuesto (`Tbl_Presupuesto_Orden_Servicio`) |

**Vistas relacionadas:**
- `vw_presupuesto_new` — usada por `rpt_presupuesto_new` (definición completa en `07-vistas.sql`)

**Triggers:**
- `T_I_Tbl_Presupuesto_Orden_Servicio` (INSERT) — validación de integridad al insertar cabecera
- `T_U_Tbl_Presupuesto_Orden_Servicio` (UPDATE) — mantiene integridad al actualizar
- `T_D_Tbl_Presupuesto_Orden_Servicio` (DELETE) — protege integridad referencial
- `T_D_Tbl_presupuesto_Orden_Servicio_Detalle` (DELETE) — protege integridad del detalle

**Cobertura de business-rules:**
- ID IDENTITY obtenido con `IDENT_CURRENT()`: lógica VFP. En nuevo sistema usar `SCOPE_IDENTITY()` o EF.
- `status=2` antes de convertir: validación en formulario `frm_genera_orden_servicio`. **No hay SP que lo valide**.
- Checkbox `autorizado` por ítem: presente en `tbl_presupuesto_orden_servicio_detalle.Autorizado`. Correcto.
- Sistema legacy `tbl_presupuesto_servicio*`: los SPs de presupuesto activo apuntan a `Tbl_Presupuesto_Orden_Servicio`. Las tablas legacy deben ignorarse.

---

### Módulo: Órdenes de Servicio

**SPs que cubren este módulo:**
| SP | Qué hace |
|----|----------|
| `sp_genera_orden_servicio` | Conversión presupuesto → OS (ver Sección 2) |
| `sp_cambia_descuento_ordenes` | Aplica/quita descuento a una OS completa — **referenciado en forms pero NO está en sp-nombres.txt** |
| `rpt_Orden_servicio` | Imprime OS individual (servicios + insumos, tipo 'O' o 'P') |
| `rpt_ordenes_trabajadas` | OS trabajadas en rango fechas, filtrables por mecánico |
| `rpt_detalle_orden_servicio_cliente` | OS pendientes de facturar para un NIT |
| `rpt_productos_no_facturados` | Productos en OS pendientes de facturar |
| `rpt_costo_ventas_servicios_detallado` | Costo vs precio de servicios e insumos por OS |
| `rpt_costo_ventas_servicios_detallado_producto` | Igual pero agrupado por producto |
| `rpt_Integracion_Insumos` | Lista insumos integrados a una OS y línea específica |
| `rpt_estadistica_ventas` | Estadística cruzando OS + facturas + clientes + artículos |
| `co_ordenes_servicio` | OLAP: OS facturadas con costos, utilidad, mecánico y marca |
| `sp_lista_vendedores` | Lista mecánicos/vendedores para combo |

**Triggers:**
- `T_I_Tbl_Orden_Servicio` (INSERT) — validación al crear OS
- `T_U_Tbl_Orden_Servicio` (UPDATE) — mantiene integridad al actualizar OS
- `T_D_Tbl_Orden_Servicio` (DELETE) — protege borrado de OS con dependencias
- `T_I_Tbl_Orden_Servicio_Detalle_Integracion` (INSERT) — actualiza `fecha_ult_mov` en la tabla (campo `Declare @Fecha_ult_Movimiento`)
- `T_u_Tbl_Orden_Servicio_Detalle_Integracion` (UPDATE) — desactualiza totales al cambiar un insumo

**Cobertura de business-rules:**
- Número de orden de `empresas.sig_orden_servicio`: lógica en formulario VFP. No hay SP dedicado.
- Validación `total > 0` antes de cerrar: formulario VFP.
- `dbo.total_lineas_orden(empresa, orden)`: **la función escalar NO está en el listado de SPs**. Está referenciada en el formulario VFP y en business-rules, pero no aparece en `sp-nombres.txt` ni en el archivo de SPs. Debe estar como `CREATE FUNCTION` (scalar-valued) en la BD pero no fue extraída — el archivo de extracción solo captura stored procedures, no funciones.
- Reversa de cierre (anulación): el formulario `frm_anular_ordenes_servicio` hace UPDATE directo con `status=1 WHERE numero=0`. No hay SP dedicado para reversa.
- `sp_cambia_descuento_ordenes`: referenciado en `frm_cambia_porcentaje_ordenes` pero ausente del catálogo. Posiblemente fue eliminado o renombrado.

---

### Módulo: Comisiones

**SPs que cubren este módulo:**
| SP | Qué hace |
|----|----------|
| `rpt_reporte_comisiones_mecanicos` | Comisiones por mecánico: cruza OS + detalle + vendedores + productos, filtrable por empleado y fechas. Solo OS con `numero<>0` (facturadas). |
| `rpt_comisiones_facturacion` | Comisiones de facturas POS (módulo más amplio, no solo taller) |

**Cobertura de business-rules:**
- Tipo 1 (valor fijo) y Tipo 2 (porcentaje): los campos `Valor_comision` y `Porcentaje_comision` están en `Tbl_Orden_Servicio_Detalle`. `rpt_reporte_comisiones_mecanicos` hace `SELECT *` sobre el join, incluyendo ambos campos. La lógica de cuál aplicar (tipo 1 vs 2) parece estar en el Crystal Report, no en el SP.
- Filtro "TODOS": implementado con `CASE WHEN @Id_Empleado='TOD' THEN d.id_empleado ELSE @Id_empleado END`. Correcto.

---

### Módulo: Facturación

**SPs que cubren este módulo (taller):**
| SP | Qué hace |
|----|----------|
| `rpt_resumen_servicios_facturados` | Resumen de servicios facturados, agrupados por servicio |
| `rpt_Integracion_Insumos` | Insumos cobrados en OS facturadas |

**Nota crítica:** La facturación es un módulo **externo** al taller. El sistema de taller solo actualiza `Autorizacion`, `Serie`, `tipo`, `Numero` en `Tbl_Orden_Servicio`. Los SPs de facturación POS (`sp_factura`, `rpt_factura`, etc.) son el módulo externo ya en producción.

---

### Módulo: Avisos de Mantenimiento

**SPs que cubren este módulo:**
| SP | Qué hace |
|----|----------|
| `rpt_avisos` | Clientes con vehículos próximos a servicio: filtra por `fecha_ult_mov` en `Tbl_Proveedores` y `tipo='C'`. **Importante:** el filtro usa `datediff(day, p.fecha_ult_mov, @fecha_al)`, no `Proximo_Servicio` de la OS. |

**Hallazgo:** `rpt_avisos` usa `fecha_ult_mov` del cliente, no el campo `Proximo_Servicio` de la OS como indica la documentación. Esto sugiere que la lógica de aviso por km/lectura está en otro reporte Crystal Reports no extraído, o que el SP está incompleto.

---

### Módulo: Configuración / Catálogos

**SPs que cubren este módulo:**
| SP | Qué hace |
|----|----------|
| `rpt_marcas` | Lista de marcas |
| `rpt_colores` | Lista de colores |
| `rpt_series` | Lista de series de facturación |
| `sp_lista_empresa` | Lista empresas |
| `sp_lista_empresa_seleccion` | Empresas para selector |
| `sp_lista_caja` | Lista cajas activas |
| `sp_lista_vendedores` | Lista mecánicos/vendedores |
| `rpt_bodegas` | Lista de bodegas |

---

## 2. Lógica Crítica en SPs — Análisis Detallado

### `sp_genera_orden_servicio` (LÍNEAS 12637-12835)

**Firma:** `sp_genera_orden_servicio @Id_empresa int, @Id_Presupuesto int, @Id_orden int`

**Lógica completa:**
1. Inicia transacción explícita `t1`
2. INSERT en `tbl_orden_servicio` copiando desde `tbl_presupuesto_orden_servicio` todos los campos de cabecera: `Id_empresa`, `@Id_orden` (nuevo número), `Num_Placa`, `Facturar_a`, `observaciones`, `Recibe_orden`, `Encargado`, `tarjeta`, `fecha`, `status`, `nit`, `lectura_actual`, `Proximo_servicio` — más valores fijos: `fecha_cierre=NULL`, `fecha_facturacion=NULL`, `numero=0`, `Autorizacion=''`, `Serie=''`, `tipo=''`, `Anticipo=0`
3. CURSOR `servicios` sobre `tbl_presupuesto_orden_servicio_detalle WHERE autorizado=1`: itera e inserta en `tbl_orden_servicio_detalle` — copia Linea, Id_servicio, Descripcion, Id_Empleado, Fosa, Precio, otros, Total_linea, cantidad, precio_descuento, total_linea_descuento, otros_descuento, costo, valor_comision, porcentaje_comision
4. CURSOR `insumos` sobre `tbl_presupuesto_orden_servicio_detalle_integracion WHERE autorizado=1`: itera e inserta en `tbl_orden_servicio_detalle_integracion` — agrega `getdate()` como fecha de integración
5. Si cualquier INSERT falla → `ROLLBACK` inmediato
6. Commit implícito al finalizar

**Puntos críticos para reescritura:**
- El SP **no actualiza** `empresas.sig_orden_servicio` — eso lo hace el formulario VFP antes de llamar al SP
- Usa `tbl_presupuesto_orden_servicio`, NO `tbl_presupuesto_servicio` (la legacy)
- El cursor de insumos agrega `getdate()` como campo extra que el de servicios no tiene
- **No valida** que el presupuesto tenga `status=2` — esa validación es del formulario VFP

---

### SP de Cierre/Apertura de OS

**No existe un SP dedicado.** El formulario VFP ejecuta SQL directo:

**Cierre:** UPDATE inline en el DataEnvironment buffered + TableUpdate() con `status=2, fecha_cierre=getdate()`

**Reversa (anulación):**
```sql
UPDATE tbl_orden_servicio
SET status = 1
WHERE id_Empresa = @nEmpresa
  AND id_orden = @cOrden
  AND status = 2
  AND numero = 0
```
Ejecutado desde `frm_anular_ordenes_servicio` vía `SQLExec()`. No hay SP.

---

### SPs de Comisiones

**`rpt_reporte_comisiones_mecanicos`** (LÍNEAS 7603-7641)
**Firma:** `@Id_empresa int, @Id_Empleado char(10), @Fecha_inicial datetime, @Fecha_final datetime`

**Lógica:** `SELECT *` de `tbl_orden_servicio o, tbl_orden_servicio_detalle d, tbl_vendedores v, tbl_productos p` con joins implícitos (old-style) + nombre de empresa como columna extra. Filtra por `fecha_facturacion` (no `fecha`), solo OS con `numero<>0`. El filtro de empleado usa `CASE WHEN @Id_Empleado='TOD'`. Devuelve todos los campos de las 4 tablas — la lógica de tipo de comisión (fijo vs porcentaje) la aplica el Crystal Report al presentar.

**`rpt_comisiones_facturacion`** (LÍNEA 2753): SP de comisiones del módulo POS, no específico del taller.

---

### SPs de Reportes `rpt_*` del Taller

| SP | Firma | Lógica resumida |
|----|-------|-----------------|
| `rpt_Orden_servicio` | `@Id_Empresa int, @Id_Orden int, @tipo char(1)` | `@tipo='O'`: JOIN OS + detalle servicios + detalle insumos + proveedores. `@tipo='P'`: igual pero desde tablas de presupuesto. Dos UNIONs internos (servicios + insumos). |
| `rpt_ordenes_trabajadas` | `@Id_Empresa int, @Id_Empleado char(4), @Fecha_Inicial datetime, @Fecha_Final datetime` | JOIN `tbl_cab_facturacion` → OS → detalle → vendedores. Vinculación por 4 campos: Autorizacion+Serie+id_tipo+numero. |
| `rpt_reporte_comisiones_mecanicos` | `@Id_empresa int, @Id_Empleado char(10), @Fecha_inicial datetime, @Fecha_final datetime` | Join OS+detalle+vendedores+productos, filtra por `fecha_facturacion`, solo facturadas. |
| `rpt_avisos` | `@id_empresa int, @fecha datetime, @fecha_al datetime, @fecha_Sugerida datetime` | JOIN `tbl_proveedores` + `tbl_vehiculos` por NIT. Filtra clientes tipo 'C' y `datediff(day, fecha_ult_mov, @fecha_al)`. |
| `rpt_vehiculos` | `@Id_Empresa int` | SELECT * de `tbl_vehiculos` con filtro hardcodeado `marca='honda' AND color='azul'` — **SP ROTO/DE PRUEBA**. |
| `rpt_marcas` | `@Id_Empresa int` | SELECT desde `Tbl_Marcas`. |
| `rpt_colores` | `@Id_Empresa int` | SELECT desde `Tbl_colores`. |
| `rpt_series` | `@Id_empresa int` | SELECT desde tabla de series. |
| `rpt_presupuesto_new` | `@Id_empresa int, @Id_presupuesto int` | SELECT desde `vw_presupuesto_new` + empresas + Tbl_Proveedores. |
| `rpt_costo_ventas_servicios_detallado` | `@Id_Empresa int, @Fecha_inicial datetime, @Fecha_final datetime, @Id_orden int, @Tipo_reporte char(10)` | UNION servicios + insumos. Descuenta insumos `se_cobra='N'` del costo del servicio. Aplica IVA histórico usando `Porcentaje_iva_anterior` y campo `apartirde` de empresa. |
| `rpt_detalle_orden_servicio_cliente` | `@Id_empresa int, @nit char(20)` | OS pendientes de facturar (`Numero=0 AND serie='' AND tipo=''`) para un NIT. UNION insumos + servicios. |
| `rpt_estadistica_ventas` | `@Id_empresa int` | UNION OS facturadas + facturas POS. Agrupa por año, NIT, artículo. Aplica IVA histórico. |
| `rpt_Integracion_Insumos` | `@Id_Empresa int, @Id_Orden int, @Linea int` | Insumos de una línea específica de una OS. |

---

### Función `total_lineas_orden`

**La función escalar `dbo.total_lineas_orden(empresa, orden)` NO fue extraída.** El archivo `sp-nombres.txt` lista solo stored procedures (tipo 'P'), no funciones escalares (tipo 'FN'). La función existe en producción (referenciada en los formularios) pero está ausente de los archivos extraídos. Es una función crítica que controla el límite de líneas por OS.

**Lógica probable:** `SELECT COUNT(*) FROM tbl_orden_servicio_detalle WHERE Id_Empresa=@empresa AND Id_Orden=@orden` (o con insumos también). Debe re-implementarse en el nuevo sistema como validación de servicio.

---

## 3. Triggers — Lógica Implícita

### Triggers sobre tablas del módulo taller

| Trigger | Tabla | Evento | Qué hace | ¿Migrar explícitamente? |
|---------|-------|--------|----------|------------------------|
| `T_I_Tbl_Orden_Servicio` | Tbl_Orden_Servicio | INSERT | Validación de integridad al crear OS (el cuerpo está truncado en el archivo extraído — estructura declarada pero sin lógica visible) | SÍ — recrear como validación en capa de servicio |
| `T_U_Tbl_Orden_Servicio` | Tbl_Orden_Servicio | UPDATE | Mantiene integridad al actualizar cabecera; probablemente actualiza `fecha_ult_mov` en Proveedores | SÍ — recrear en eventos de dominio |
| `T_D_Tbl_Orden_Servicio` | Tbl_Orden_Servicio | DELETE | Impide borrado de OS con dependencias (detalle, insumos, referencias) | SÍ — recrear como validación antes de DELETE |
| `T_D_Tbl_Orden_Servicio_Detalle` | Tbl_Orden_Servicio_Detalle | DELETE | Impide borrado de líneas de servicio con dependencias | SÍ |
| `T_I_Tbl_Orden_Servicio_Detalle_Integracion` | Tbl_Orden_Servicio_Detalle_Integracion | INSERT | Actualiza `@Fecha_ult_Movimiento` (fragmento visible: `Declare @Fecha_ult_Movimiento`) — probablemente actualiza `fecha_ult_mov` en vehículo o cliente | SÍ — lógica de negocio crítica |
| `T_u_Tbl_Orden_Servicio_Detalle_Integracion` | Tbl_Orden_Servicio_Detalle_Integracion | UPDATE | `------desactualizando` (fragmento visible) — revierte totales al cambiar un insumo | SÍ — lógica de totales |
| `T_D_Tbl_Orden_Servicio_Detalle_Integracion` | Tbl_Orden_Servicio_Detalle_Integracion | DELETE | Manejo de `Costo_Tot` (fragmento: `Declare @Costo_Tot`) — probablemente actualiza totales del servicio padre | SÍ — lógica de totales |
| `T_I_Tbl_Presupuesto_Orden_Servicio` | Tbl_Presupuesto_Orden_Servicio | INSERT | Validación de integridad al crear presupuesto | SÍ |
| `T_U_Tbl_Presupuesto_Orden_Servicio` | Tbl_Presupuesto_Orden_Servicio | UPDATE | Mantiene integridad al actualizar presupuesto | SÍ |
| `T_D_Tbl_Presupuesto_Orden_Servicio` | Tbl_Presupuesto_Orden_Servicio | DELETE | Protege integridad del presupuesto | SÍ |
| `T_D_Tbl_presupuesto_Orden_Servicio_Detalle` | tbl_presupuesto_orden_servicio_detalle | DELETE | Protege integridad del detalle del presupuesto | SÍ |
| `T_I_Tbl_Proveedores` | Tbl_Proveedores | INSERT | Valida nuevo cliente/proveedor | SÍ |
| `T_U_Tbl_Proveedores` | Tbl_Proveedores | UPDATE | Mantiene `fecha_ult_mov` y validaciones de cliente | SÍ |
| `T_D_Tbl_Proveedores` | Tbl_Proveedores | DELETE | Impide borrar clientes con OS o vehículos asociados | SÍ |
| `t_d_tbl_vehiculos` | Tbl_Vehiculos | DELETE | Impide borrar vehículos con OS asociadas | SÍ |
| `T_D_COLORES` | Tbl_colores | DELETE | Protege integridad referencial de colores | SÍ si se usan colores como FK |

**Advertencia crítica:** Los triggers están truncados en el archivo `08-triggers.sql`. El extractor capturó los headers pero no el cuerpo completo de la mayoría. La lógica real dentro de cada trigger es desconocida en detalle. Esto es un gap de información.

---

## 4. Gaps Identificados

### Gap A — Lógica en Formularios VFP (no tenemos el código)

Las siguientes reglas de negocio están casi con certeza **solo en el código VFP** y no en SPs ni triggers:

1. **Numeración de OS** (`empresas.sig_orden_servicio`): el formulario VFP lee el próximo número, muestra en campo `id_orden`, y en algún punto incrementa el campo en `empresas`. No hay SP para esto.

2. **Validación de cierre de OS** (`nit + num_placa + recibe_orden` no vacíos AND `total > 0`): validación en evento `FieldValid` / método `QueryUnload` del formulario VFP. Totalmente del lado cliente.

3. **Validación de conversión presupuesto → OS** (presupuesto debe tener `status=2`): el formulario `frm_genera_orden_servicio` verifica esto antes de llamar al SP. El SP en sí no valida el status.

4. **Límite de líneas** (`dbo.total_lineas_orden`): el formulario llama a esta función escalar. La función NO fue extraída — necesitamos extraerla de la BD de producción.

5. **NIT inmutable** en clientes: propiedad `ReadOnly` del control VFP. Sin validación en BD.

6. **Porcentaje de descuento activo solo con tarjeta**: evento `When` del control VFP. Sin constraint en BD.

7. **Recarga de combo líneas al cambiar marca**: evento `Valid`/`InteractiveChange` del combo VFP. Pura UI.

8. **Cálculo de `otros` (subtotal insumos) en grilla de servicios**: campo calculado en el formulario. El SP de conversión copia el valor pre-calculado; no lo recalcula.

9. **Control de privilegios por campo** (tarjeta, descuento, tipo_precio, dias_credito, forma_pago): el sistema VFP usa variables de sesión `nPrivilegios`. No hay nada equivalente en la BD que haya sobrevivido — `SYS_SECURITY` está vacía.

10. **Actualización de `empresas.sig_orden_servicio`** al crear una OS: UPDATE directo desde VFP. Sin SP.

11. **Historial de vehículos**: `frm_vehiculos` hace `SQLCONNECT("inventarios","sa","")` + query a `tbl_orden_servicio` para mostrar historial. Lógica de conexión en el formulario.

---

### Gap B — Reportes

**9 reportes Crystal Reports documentados en business-rules y forms:**

| Reporte Crystal (.rpt) | SP de datos disponible | Estado |
|------------------------|------------------------|--------|
| Orden de Servicio individual | `rpt_Orden_servicio` | Cubierto |
| Presupuesto nuevo | `rpt_presupuesto_new` (usa `vw_presupuesto_new`) | Cubierto |
| Presupuesto por autorizar | `rpt_presupuesto_new` (parámetro 0 vs 1) | Cubierto |
| Órdenes trabajadas por mecánico | `rpt_ordenes_trabajadas` | Cubierto |
| Comisiones mecánicos | `rpt_reporte_comisiones_mecanicos` | Cubierto |
| Avisos de mantenimiento | `rpt_avisos` (con caveat — ver hallazgo en Sección 1) | Parcial |
| Costo vs venta de servicios | `rpt_costo_ventas_servicios_detallado` | Cubierto |
| Estadística de ventas | `rpt_estadistica_ventas` | Cubierto |
| OS pendientes de facturar por cliente | `rpt_detalle_orden_servicio_cliente` | Cubierto |

**Reportes con SP pero con problemas conocidos:**
- `rpt_vehiculos`: tiene filtro hardcodeado `marca='honda' AND color='azul'` — es un SP de prueba, no funcional. Para el reporte real de vehículos se necesita reescribir.
- `rpt_avisos`: usa `fecha_ult_mov` del cliente en lugar de `Proximo_Servicio` de la OS. La lógica de aviso por km/lectura puede estar en el Crystal Report calculando la diferencia.

**No existe SP para:**
- Listado de mecánicos (usa `sp_lista_vendedores` que es simple SELECT)
- Configuración de empresa (consulta directa a tabla `empresas`)

---

### Gap C — Autenticación y Permisos

**La BD tiene DOS sistemas de seguridad:**

1. **Sistema legacy VFP** (`SYS_SECURITY` — vacía, `session-model.md` con `nPrivilegios`): privilegios granulares por campo, por módulo, por usuario. **Completamente en el ejecutable VFP**, no replicable desde la BD. Credenciales hardcodeadas `SQLCONNECT("inventarios","sa","")`.

2. **Sistema nuevo ASP.NET Core** (`AspNetUsers`, `AspNetRoles`, `TblOpcion`, `TblRolOpcion`): ya en producción con 4 usuarios, 3 roles, 39 opciones de menú. El modelo es **rol-based por opción de menú**, no por campo individual.

**Gap concreto:** Los privilegios VFP por campo (ej: solo ciertos usuarios pueden ver/editar `tarjeta`, `porcentaje_descuento`, `dias_credito`) no tienen equivalente en la BD nueva. El nuevo sistema debe implementar claims o políticas de autorización a nivel campo en la capa de aplicación. La BD provee la estructura (AspNet*) pero no las reglas finas.

---

### Gap D — Integraciones Externas

**Inventarios:** `frm_vehiculos` hace `SQLCONNECT("inventarios","sa","")` para el historial de vehículos. Varios SPs también usan `db_inventario_pfp.dbo.*` como referencia cross-database (ej: `sp_genera_orden_servicio` inserta directamente `INTO db_inventario_pfp.dbo.tbl_orden_servicio`). Esto implica que la BD de taller y la BD de inventario son la **misma instancia** (`db_inventario_pfp`), no bases separadas. La integración es interna a la misma BD.

**OLAP:** `co_ordenes_servicio` es el SP para el cubo analítico. El formulario `frm_consulta_servicios` se conecta vía ADO con `Provider=MSDASQL.1;...Data Source=inventarios;Initial Catalog=db_inventario_pfp`. La conexión hardcodeada con credenciales de sa (SEC-002) es el único mecanismo de acceso OLAP.

**FEL (Factura Electrónica Guatemalteca):** La tabla `Tbl_Ente_facturador` (4 registros) y `Tbl_contrasenas` (10 registros de DTE/SAT) indican integración FEL activa. Los SPs `rpt_contrasena_pago` y `rpt_contrasenas_facturas` gestionan esto. Es un módulo de facturación externo al taller que el nuevo sistema debe respetar.

**Contabilidad:** Varios SPs referencian `db_contabilidad_pfp.dbo.cuentas` (ej: `rpt_integracion_poliza_provision_cxp`). Esta BD de contabilidad es externa y no fue extraída.

---

## 5. Riesgos de Migración

### RIESGO-1: Lógica de triggers desconocida en detalle
**Descripción:** 119 triggers existen en la BD pero el archivo extraído está truncado — solo muestra headers, no el cuerpo completo. Los 7 triggers sobre tablas de OS/presupuesto pueden contener lógica de negocio crítica (actualización de totales, `fecha_ult_mov`, validaciones) que no está documentada.
**Probabilidad:** Alta — los triggers de insumos (`T_I_Tbl_Orden_Servicio_Detalle_Integracion`) muestran fragmentos que claramente actualizan campos. Lo que hacen exactamente es desconocido.
**Mitigación:** Re-extraer los triggers con `sp_helptext` o directamente desde `sys.sql_modules` antes de comenzar el desarrollo. Sin esto, el nuevo sistema puede omitir actualizaciones implícitas.

---

### RIESGO-2: Función `total_lineas_orden` no extraída
**Descripción:** La función escalar `dbo.total_lineas_orden(empresa, orden)` existe en producción y controla el límite de líneas por OS (comparado contra `empresas.total_detalle_lineas`). No fue capturada por el extractor porque solo extrajo SPs, no funciones. Si se recrea incorrectamente, documentos con muchas líneas fallarán silenciosamente o sin control.
**Probabilidad:** Alta — la función es usada activamente en el formulario de OS.
**Mitigación:** Ejecutar `SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.total_lineas_orden'))` en la BD de producción para obtener el cuerpo. Es una función probablemente de 3-4 líneas.

---

### RIESGO-3: `sp_cambia_descuento_ordenes` ausente
**Descripción:** El formulario `frm_cambia_porcentaje_ordenes` llama a `EXEC sp_cambia_descuento_ordenes ?nempresa, ?norden, ?naplica_descuento` pero este SP no aparece en el catálogo real. Puede haber sido eliminado, estar en otra BD, o el formulario está roto.
**Probabilidad:** Media — si el formulario está en producción, la funcionalidad puede estar rota actualmente o el SP fue renombrado.
**Mitigación:** Confirmar con el cliente si `frm_cambia_porcentaje_ordenes` está activo en producción. Si sí, extraer el SP manualmente desde la BD.

---

### RIESGO-4: BUG-001 propagado a datos existentes
**Descripción:** Si `sp_insertavehiculo` (con el bug Puertas→Modelo) fue usado en otra instancia de BD con datos reales, los datos de `Modelo` y `Puertas` están corruptos. En la BD extraída `Tbl_Vehiculos` tiene 0 registros, pero puede haber otra instancia de producción con datos afectados.
**Probabilidad:** Alta — el sistema está en producción según el contexto.
**Mitigación:** Al migrar datos, ejecutar limpieza manual. El campo en la BD real es texto libre (no FK), así que la corrección es una migration de datos. Verificar con el cliente qué instancia tiene los datos reales.

---

### RIESGO-5: Dos instancias de BD — datos reales en otra BD
**Descripción:** La BD extraída (`db_inventario_pfp`) tiene 0 registros en todas las tablas del módulo taller. Los datos reales están en otra instancia. Esto significa que el análisis se basa en estructura pero no en datos reales. Pueden existir datos inconsistentes, registros huérfanos, o uso no documentado de campos.
**Probabilidad:** Alta — confirmado por real-schema-findings.md.
**Mitigación:** Solicitar acceso de lectura a la BD de producción real para revisar distribución de datos. Como mínimo, obtener conteo de registros por tabla.

---

### RIESGO-6: Tabla `Tbl_Proveedores` como maestro unificado
**Descripción:** Los clientes no son una tabla separada — están en `Tbl_Proveedores` con campo `Tipo char(1)`. El formulario VFP trabaja con la vista de "cliente" (`Tipo='C'`), pero la tabla tiene 40+ campos que el sistema VFP no expone. El nuevo sistema debe decidir si unificar o separar Clientes/Proveedores. Si se separa, se pierde la FK natural desde OS y vehículos.
**Probabilidad:** Media — es una decisión de arquitectura, no un bug.
**Mitigación:** Mantener `Tbl_Proveedores` como tabla maestra en el nuevo sistema (renombrándola `Personas` o `Terceros`), añadir la columna `Tipo` como discriminador. No crear tabla `Clientes` separada a menos que sea negocio critical.

---

### RIESGO-7: `rpt_vehiculos` tiene filtro hardcodeado de prueba
**Descripción:** `rpt_vehiculos` tiene `WHERE marca='honda' AND color='azul'` — devuelve solo vehículos honda azules. Si hay un Crystal Report que llama a este SP como reporte de listado de vehículos, el reporte está roto en producción.
**Probabilidad:** Media — el SP puede simplemente no usarse en producción.
**Mitigación:** Confirmar con el cliente si el reporte de listado de vehículos funciona. El SP debe reescribirse sin el filtro hardcodeado.

---

### RIESGO-8: Dependencias de base de datos cruzadas
**Descripción:** El SP `sp_genera_orden_servicio` inserta directamente con `INSERT db_inventario_pfp.dbo.tbl_orden_servicio` — referencia explícita a la base de datos por nombre. Otros SPs referencian `db_contabilidad_pfp.dbo.cuentas`. En el nuevo sistema si la BD cambia de nombre o se migra a otro servidor, estas referencias rompen.
**Probabilidad:** Alta — cualquier cambio de nombre de BD rompe todos los SPs con referencias cruzadas.
**Mitigación:** En el nuevo sistema, nunca usar referencias cross-database en código de aplicación. Usar el ORM (EF Core) para todas las operaciones. Los SPs de reportes que referencien `db_contabilidad_pfp` deben ser reemplazados por APIs o servicios propios.

---

## 6. Veredicto Final

### ¿Es suficiente lo que tenemos para recrear el sistema?

**Respuesta: SÍ para el core del taller — PARCIALMENTE para detalles críticos.**

**Lo que tenemos es suficiente para:**
- Recrear el modelo de datos completo (estructura de tablas documentada y extraída)
- Recrear el flujo principal Cliente → Vehículo → Presupuesto → OS → Reportes
- Implementar `sp_genera_orden_servicio` con lógica completa (está completamente extraído)
- Implementar todos los reportes del taller (SPs completos disponibles)
- Diseñar el sistema de permisos (usando ASP.NET Identity ya en producción)
- Identificar y corregir los bugs documentados (BUG-001 a BUG-004)

**Lo que es imprescindible obtener ANTES de empezar:**

1. **Cuerpo completo de los 7 triggers del módulo taller** — ejecutar en BD de producción:
   ```sql
   SELECT OBJECT_NAME(object_id) as trigger_name, OBJECT_DEFINITION(object_id) as cuerpo
   FROM sys.triggers
   WHERE OBJECT_NAME(parent_id) IN ('Tbl_Orden_Servicio','Tbl_Orden_Servicio_Detalle',
     'Tbl_Orden_Servicio_Detalle_Integracion','Tbl_Presupuesto_Orden_Servicio',
     'tbl_presupuesto_orden_servicio_detalle','Tbl_Proveedores','Tbl_Vehiculos')
   ```

2. **Función escalar `dbo.total_lineas_orden`** — ejecutar:
   ```sql
   SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.total_lineas_orden'))
   ```

3. **SP `sp_cambia_descuento_ordenes`** — verificar si existe en BD producción:
   ```sql
   SELECT OBJECT_DEFINITION(OBJECT_ID('sp_cambia_descuento_ordenes'))
   ```

4. **Acceso de lectura a la BD de producción real** con datos para validar tipos de datos, volumetría y registros especiales (ej: NIT `XXXXXXXXXXXXXXXXXXXX` referenciado en forms).

5. **Código de los formularios VFP** (idealmente los 8 formularios del módulo taller) para confirmar la lógica de validaciones de cierre, cálculo de totales y manejo de `sig_orden_servicio`.

---

## Semáforo de Migración por Módulo

| Módulo | Estado | Qué hace falta |
|--------|--------|----------------|
| Clientes | 🟡 Parcial | Lógica de privilegios por campo (VFP puro); `sp_buscar_cliente` no existe en BD; `estado` activo/inactivo no está en `Tbl_Proveedores` |
| Vehículos | 🟡 Parcial | Cuerpo del trigger DELETE; `sp_insertavehiculo` ausente (BUG-001 sin confirmar); `rpt_vehiculos` roto con filtro hardcodeado |
| Presupuestos | 🟢 Listo | SP de conversión completo; tablas documentadas; flujo claro. Solo falta confirmar vista `vw_presupuesto_new` |
| Órdenes de Servicio | 🟡 Parcial | Función `total_lineas_orden` no extraída; cuerpo triggers OS desconocido; `sp_cambia_descuento_ordenes` ausente; lógica de numeración en VFP |
| Comisiones | 🟡 Parcial | SP de reporte disponible pero lógica tipo 1 vs tipo 2 está en Crystal Report, no en SP; `Mecanico.Comision` es int (BUG-002) |
| Facturación | 🔴 Falta | Es módulo externo; el taller solo escribe 4 campos de factura en OS; el módulo POS completo está en la BD pero no fue objetivo de esta extracción |
| Avisos de mantenimiento | 🟡 Parcial | `rpt_avisos` usa `fecha_ult_mov` del cliente, no `Proximo_Servicio` de la OS; lógica por km puede estar solo en Crystal Report |
| Autenticación / Permisos | 🟡 Parcial | ASP.NET Identity ya en producción (buena base); falta implementar permisos granulares por campo que el VFP tenía |
| Catálogos (marcas, colores, líneas, tipos) | 🟢 Listo | Tablas y SPs de listado disponibles |
| Reportes taller | 🟡 Parcial | 8 de 9 SPs de datos disponibles; `rpt_vehiculos` roto; lógica de presentación en Crystal Reports no extraída |
| Configuración (empresa, series, cajas) | 🟢 Listo | SPs y tablas disponibles; `empresas` tiene 42 campos documentados |
| Integración inventarios | 🟡 Parcial | Misma BD — no es integración real; pero credenciales hardcodeadas deben eliminarse |
| OLAP / Cubos | 🔴 Falta | `co_ordenes_servicio` existe pero ADO con credenciales hardcodeadas no es aceptable en nuevo sistema |
