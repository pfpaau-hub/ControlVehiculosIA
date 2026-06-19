# Skill: ControlVehiculosIA — Carga rápida de contexto

## QUÉ ES
Sistema de gestión de taller automotriz en **Visual FoxPro + SQL Server**, en producción.
Objetivo actual: **recrear toda la lógica en tecnologías modernas** (lógica intacta, tecnología nueva).

**Flujo de negocio:**
```
Login → Empresa → Cliente → Vehículo → [Presupuesto →] Orden de Servicio → Facturación → Reportes
```

**Archivos clave del original:**
- `Source/appmain.prg` — punto de entrada
- `DATABASE/db_Control_AutomotrizIA` — backup SQL Server (6.2 MB)
- `.ia-context/` — toda la documentación detallada
- `CLAUDE.md` — índice de navegación

---

## MODELO DE DATOS (17 tablas)

```
Empresa(id_empresa, nombre_empresa, sig_orden_servicio, sig_numero_presupuesto,
        id_bodega_facturacion, total_detalle_lineas, periodo[MM/AAAA])

Cliente(id_cliente PK, nit[20] UNIQUE INMUTABLE, nombre, facturar_a NOT NULL,
        direccion, municipio, departamento, telefono1, telefono2,
        correo_electronico, tipo_precio[A/B/C], identificacion, tarjeta,
        porcentaje_descuento, credito_o_contado, dias_credito,
        estado[1=activo,0=inactivo], fecha_ult_mov, id_empresa FK)

Vehiculo(id_vehiculo PK, num_placa[10] UNIQUE, nit FK→Cliente,
         id_linea FK, id_tipo FK, id_color FK NOT NULL,
         modelo[4], puertas, cilindros, motor[25], motor_de[10],
         unidad_medida[Millas/Kilometros], presion_llantas, servicio_cada[5],
         combustible[Gasolina/Diesel], fecha_ult_mov, id_empresa FK)

Marca(id_marca_vehiculo PK, marca_vehiculo, id_empresa FK)
Linea(id_linea PK, linea_vehiculo, id_marca_vehiculo FK)   ← filtrada por marca
TipoVehiculo(id_tipo_vehiculo PK, estilo_vehiculo)
Color(id_color PK, nombre_color, id_empresa FK)

tbl_presupuesto_servicio(id_presupuesto IDENTITY PK, id_empresa, nit FK,
                         num_placa, tarjeta, fecha, observaciones[200],
                         status[1=Abierto,2=Cerrado])
tbl_presupuesto_servicio_detalle(id_detalle PK, id_presupuesto FK,
                                  descripcion[250], valor dec(18,2),
                                  autorizado bit[0/1])

tbl_orden_servicio(id_orden PK←sig_orden_servicio, id_empresa, nit FK NOT NULL,
                   num_placa FK NOT NULL, facturar_a, fecha, fecha_cierre,
                   id_empleado_recibe FK NOT NULL, status[1=Abierta,2=Cerrada],
                   tarjeta, proximo_servicio int, lectura_actual int,
                   numero[0=sin facturar,>0=N°factura], fecha_facturacion)

detalle_servicios(linea, id_orden FK, id_empresa, id_servicio FK, id_empleado FK NOT NULL,
                  fosa, cantidad dec(28,2), precio, precio_descuento,
                  otros, otros_descuento, total_linea, total_linea_descuento)

ordenes_servicio_integracion(linea_det, id_orden FK, id_empresa,
                              id_producto FK, id_bodega FK NOT NULL,
                              se_cobra[S/N], cantidad, precio, precio_descuento,
                              total_linea, total_linea_descuento, periodo[MM/AAAA])

tbl_productos(id_producto PK, descripcion, descripcion_corta,
              es_servicio bit[1=mano_obra,0=repuesto], id_empresa FK)

Empleado(id_empleado PK, nombre, porc_comision dec(5,2), status[A/B])
Mecanico(id_mecanico PK, nombre, comision dec(5,2)¹, id_empresa FK)
productos_comisiones(id_servicio² FK→tbl_productos es_servicio=1,
                     tipo_comision[1=valorFijo,2=porcentaje],
                     valor_comision, porcentaje_comision)

Bodega(id_bodega PK, nombre_bodega, id_empresa FK)
Existencias(id_bodega FK, id_producto FK, existencia)
Series(id_serie PK, autorizacion, serie, id_tipo, del, al, actual,
       fecha_ingreso, descripcion, status[Alta/Baja])
Cajas(id_caja PK, observaciones) + CajasSeries(id_caja, autorizacion, serie, id_tipo)
Cajeros(id_cajero PK, nombre)
Bancos(id_banco PK, nombre)
CasasCredito(id_casa PK, nombre)
```
¹ Actualmente `int` en el original — BUG a corregir, debe ser `decimal(5,2)`
² Actualmente se llama `id_producto` en el original — inconsistencia a corregir

---

## REGLAS DE NEGOCIO CRÍTICAS

### Cliente
- NIT: PK inmutable (readonly después de crear)
- `porcentaje_descuento` solo editable si `tarjeta ≠ vacío`
- Campos con privilegio independiente: `tarjeta`, `porcentaje_descuento`, `credito_o_contado`, `tipo_precio`, `dias_credito`
- `sp_buscar_cliente` filtra `estado=1`

### Vehículo
- Color obligatorio (validación explícita)
- Combo líneas se recarga al cambiar marca → filtro por `id_marca_vehiculo`

### Presupuesto
- ID via `IDENT_CURRENT('TBL_PRESUPUESTO_SERVICIO')` post-insert
- `status=2` requerido para convertir a OS
- Conversión: `sp_genera_orden_servicio(empresa, presupuesto, orden)` → solo `autorizado=1`

### Orden de Servicio
- Ciclo: `status=1` → validar(nit+placa+recibe_orden+total>0) → `status=2` → facturación → `numero>0`
- Límite líneas: `dbo.total_lineas_orden(empresa, orden)` ≤ `empresas.total_detalle_lineas`
- Reversión SOLO si: `status=2 AND numero=0 AND fecha_facturacion IS NULL`
- `periodo` de insumos = variable de sesión `cPeriodo`
- Numeración de orden: de `empresas.sig_orden_servicio` (auto-incrementa)

### Estados por entidad
| Entidad | Campo | Valores |
|---------|-------|---------|
| Cliente | estado | 1=activo, 0=inactivo |
| OS | status | 1=Abierta, 2=Cerrada |
| OS | numero | 0=sin facturar, >0=N° factura |
| Presupuesto | status | 1=Abierto, 2=Cerrado |
| Det. Presupuesto | autorizado | 0=no, 1=sí |
| Serie | status | 'Alta' / 'Baja' |
| Empleado | status | 'A'=activo, 'B'=baja |
| Insumo OS | se_cobra | 'S' / 'N' |

---

## SESIÓN Y PRIVILEGIOS

**Variables globales** (definidas en login/selección de empresa):
- `nEmpresa` — filtra TODO por empresa (presente en cada query)
- `cPeriodo` — período contable MM/AAAA (se asigna a `ordenes_servicio_integracion.periodo`)
- `ncaja` — caja activa (requerida en reportes de historial)
- `_screen.cReportes` — ruta de archivos .rpt (Crystal Reports)

---

## STORED PROCEDURES

| SP | Parámetros | Acción |
|----|-----------|--------|
| `sp_genera_orden_servicio` | empresa, presupuesto, orden | Presupuesto→OS (solo autorizado=1) |
| `sp_cambia_descuento_ordenes` | empresa, orden, aplica(0/1) | Resetea descuento |
| `dbo.total_lineas_orden` | empresa, orden | Función escalar — cuenta líneas |
| `sp_devuelve_NumOServicio` | fecha_ini datetime, fecha_fin datetime | Cuenta OS en rango |
| `co_ordenes_servicio` | int (hardcoded=1) | Datos OLAP |
| `sp_insertacliente` | XML | Inserta cliente |
| `sp_buscar_cliente` | — | Clientes estado=1 |
| `sp_eliminacliente` | @IdCliente int | |
| `sp_lista_cliente` | — | ⚠️ 3 versiones duplicadas |
| `sp_insertavehiculo` | XML | ⚠️ BUG: Puertas→Modelo |
| `sp_lista_vehiculo` | — | |
| `sp_eliminavehiculo` | @IdVehiculo int | |
| `sp_vehiculo_cliente` | @NIT varchar(20) | Vehículos de un cliente |
| `sp_buscar_placa` | @Placa nvarchar(10) | Valida existencia |
| `sp_insertamarca/color/tipovehiculo/mecanico/presupuesto/bodega` | XML | Inserta entidad |
| `sp_lista_linea` | @IdMarcaVehiculo int | Líneas por marca |
| `sp_lista_producto` | — | ⚠️ 2 versiones duplicadas |

**SQL directo crítico:**
```sql
-- Revertir cierre de OS
UPDATE tbl_orden_servicio SET status=1
WHERE id_empresa=? AND id_orden=? AND status=2 AND numero=0

-- Cargar órdenes reversibles
SELECT * FROM tbl_orden_servicio
WHERE id_empresa=? AND status=2 AND fecha_facturacion IS NULL

-- Obtener ID de presupuesto recién insertado
SELECT ISNULL(IDENT_CURRENT('TBL_PRESUPUESTO_SERVICIO'),0) AS ultimo
```

---

## REPORTES (Crystal Reports v9 → reemplazar con PDF moderno)

| Archivo .rpt | Parámetros | Descripción |
|-------------|-----------|-------------|
| `rpt_servicios.rpt` | empresa, id_orden, 'O'/'P' | OS o presupuesto |
| `rpt_presupuesto_new.rpt` | empresa, id_presupuesto, 0/1 | 0=todos, 1=autorizados |
| `rpt_presupuesto_por_autorizar.rpt` | empresa, id_presupuesto | Para firma cliente |
| `rpt_historial_facturas.rpt` | empresa, ncaja, fecha_ini, fecha_fin | |
| `rpt_ordenes_trabajadas.rpt` | empresa, id_empleado\|'TODO', fecha_ini, fecha_fin | |
| `rpt_avisos.rpt` | empresa, fecha, fechaal, fechasugerida | Recordatorios mantenimiento |
| `rpt_comisiones_mecanicos.rpt` | empresa, id_empleado\|'TOD', fecha_ini, fecha_fin | ⚠️ 'TOD' ≠ 'TODO' |
| `productos_ordenados_nofacturados.rpt` | empresa | |

---

## FORMULARIOS CLAVE (40 total)

| Formulario | Rol | Nota crítica |
|-----------|-----|-------------|
| `frm_selecciona_empresas` | Login | Define nEmpresa, cPeriodo, cReportes |
| `frm_menu_principal` | Navegación | Abre frm_presupuestos_**new** (no el viejo) |
| `frm_clientes` | CRUD | NIT inmutable, privilegios por campo |
| `frm_clientes_children` | Modal | Datos financieros con privilegios |
| `frm_vehiculos` | CRUD | Requery líneas al cambiar marca |
| `frm_presupuestos_new` | CRUD | **Versión activa** — tablas `tbl_presupuesto_servicio*` |
| `frm_presupuestos` | CRUD | **DEPRECADO** — alias confusos, no usar como referencia |
| `frm_orden_servicios` | CRUD central | 3 niveles: cabecera+servicios+insumos |
| `frm_genera_orden_servicio` | Proceso | Presupuesto→OS |
| `frm_anular_ordenes_servicio` | Admin | Solo si numero=0 |
| `frm_consulta_servicios` | OLAP | ContourCubeLite + ADO directo → reemplazar |
| `frm_pantalla_busqueda` | Genérico | Buscador parametrizable reutilizable |

---

## BUGS A CORREGIR EN EL NUEVO SISTEMA

| ID | Dónde | Problema | Corrección |
|----|-------|---------|-----------|
| BUG-001 | `sp_insertavehiculo` | `Puertas` se guarda en columna `Modelo` | Columnas separadas correctas |
| BUG-002 | `Mecanico.comision` | Tipo `int` trunca porcentajes decimales | `decimal(5,2)` |
| BUG-003 | SQL Server | `sp_lista_cliente` ×3, `sp_lista_producto` ×2 | Un solo endpoint por entidad |
| BUG-004 | SQL Server | `tblprueba` con inserts en SPs de producción | Eliminar tabla y referencias |
| INC-001 | `productos_comisiones` | `id_producto` referencia servicios | Renombrar a `id_servicio` |
| INC-002 | XML/SPs | `Presionllantas` vs `PresionLlantas` | Estandarizar snake_case |
| INC-003 | SPs | NIT como `nvarchar(max)` en algunos SPs | Estandarizar `varchar(20)` |
| SEC-001 | 8 formularios VFP | `SQLCONNECT("inventarios","sa","")` | Variables de entorno |
| SEC-002 | `frm_consulta_servicios` | Cadena ADO con BD en claro | Variables de entorno |

---

## INTEGRACIONES EXTERNAS (a rediseñar)

- **Sistema de inventarios:** BD separada `db_inventario_pfp` vía DSN ODBC `"inventarios"`
- **Sistema de facturación:** Externo — el sistema solo lee el resultado (`numero`, `fecha_facturacion`)
- **Crystal Reports:** Archivos `.rpt` en ruta `_screen.cReportes` → reemplazar con PDF moderno
- **ContourCubeLite:** Control OLE OLAP propietario → reemplazar con herramienta BI web

---

## STACK TECNOLÓGICO DEFINIDO (ADR-004)

| Capa | Tecnología |
|------|-----------|
| Backend | C# + ASP.NET Core Web API (.NET 8) |
| Frontend | React + TypeScript |
| Base de datos | SQL Server (mantener — misma BD del VFP) |
| ORM | Entity Framework Core 8 + Dapper |
| Autenticación | ASP.NET Core Identity + JWT |
| Reportes PDF | FastReport.NET o RDLC (reemplaza Crystal Reports) |
| Despliegue | IIS o Azure App Service |

**Estrategia:** API nueva apunta a la misma SQL Server → ambos sistemas corren en paralelo → migración módulo por módulo sin cortar el VFP.

**Mapeo clave:**
- `nEmpresa` / `cPeriodo` globales → JWT claims + middleware de contexto de empresa
- Privilegios por campo → ASP.NET Core Policies + `[Authorize(Policy="...")]`
- `SQLEXEC()` inline → EF Core LINQ o Dapper
- Crystal Reports `.rpt` → FastReport `.frx` o RDLC `.rdlc`
- `ContourCubeLite` OLAP → AG Grid con pivot o SSRS

---

## DÓNDE ENCONTRAR MÁS DETALLE

```
.ia-context/
├── INDEX.md                     ← Mapa completo
├── memory/business-rules.md     ← Reglas por módulo
├── memory/technical-debt.md     ← Bugs detallados con código
├── memory/session-model.md      ← Privilegios y sesión
├── architecture/data-model.md   ← Tablas completas con tipos
├── architecture/stored-procedures.md  ← SPs con SQL completo
├── decisions/ADR-001.md         ← Objetivo de migración
├── decisions/ADR-002.md         ← Dos sistemas de presupuestos
├── decisions/ADR-003.md         ← Cada bug con corrección
├── tasks/backlog.md             ← ~50 tareas en 5 fases
└── forms/<módulo>.md            ← Detalle de cada formulario
```
