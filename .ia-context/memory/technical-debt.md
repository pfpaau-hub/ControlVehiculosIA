# Memoria — Deuda Técnica y Bugs Conocidos

## Bugs activos en el sistema original

### BUG-001 — Puertas mapeado como Modelo
**Archivo:** `sp_insertavehiculo` en SQL Server (documentado originalmente)
**Estado (2026-06-18):** PARCIALMENTE RESUELTO en el schema real. En `db_inventario_pfp`, `Tbl_Vehiculos` tiene `Modelo char(4)` y `Puertas char(1)` como columnas SEPARADAS — el schema de BD ya está correcto. Sin embargo, `sp_insertavehiculo` NO existe en los 277 SPs extraídos: los inserts de vehículos los hace el VFP directamente o con otro mecanismo. El bug en el mapeo XML puede seguir existiendo en el código VFP (no tenemos ese código aún).
**En el nuevo sistema:** Mantener `Modelo` y `Puertas` como campos separados (ya correcto en schema real). Verificar con el código VFP si el mapeo XML sigue siendo incorrecto.

### BUG-002 — Comision de mecánico es int
**Tabla:** `Mecanico.Comision` definida como `int`
**Impacto:** Porcentajes como 12.5% se guardan como 12, perdiendo decimales.
**Corrección:** Cambiar tipo a `decimal(5,2)`.

### BUG-003 — SPs duplicados
**Afectados:**
- `sp_lista_cliente` × 3 versiones con SELECTs distintos
- `sp_lista_producto` × 2 versiones
- `sp_lista_marca` y `rpt_lista_marca` hacen lo mismo
**Impacto:** Ambigüedad sobre cuál versión ejecuta la aplicación.
**Corrección:** Consolidar en un único SP por entidad.

### BUG-004 — Tabla tblprueba en producción
**Tabla:** `tblprueba` / `TblPrueba` (capitalización inconsistente)
**Impacto:** Tabla de desarrollo con inserts activos dentro de SPs de producción.
**Corrección:** Eliminar tabla y remover todos los inserts a ella.

---

## Inconsistencias de nomenclatura

### INC-001 — id_producto para servicios
**Dónde:** Tabla `productos_comisiones`, campo `id_producto`
**Problema:** Referencia a servicios (WHERE es_servicio=1) pero se llama `id_producto`.
En `detalle_servicios` el campo equivalente se llama `id_servicio`.
**Corrección:** Unificar a `id_servicio` en todo el sistema.

### INC-002 — PresionLlantas capitalización
**Dónde:** XML entre VFP y SPs
**Problema:** A veces `Presionllantas` (l minúscula), a veces `PresionLlantas`.
**Corrección:** Estandarizar a `presion_llantas` (snake_case si se migra).

### INC-003 — Dos sistemas de presupuestos paralelos
**Sistema A:** `frm_presupuestos` → tablas `presupuesto_ordenes*` con alias de órdenes
**Sistema B:** `frm_presupuestos_new` → tablas `tbl_presupuesto_servicio*` (el activo)
**Problema:** El menú principal llama al sistema B, pero el sistema A sigue en el código compilado.
**Corrección:** Eliminar sistema A, mantener solo `tbl_presupuesto_servicio*`.

### INC-004 — NIT con tipo inconsistente
**Dónde:** SPs de SQL Server
**Problema:** `nvarchar(max)` en versión comentada, `nvarchar(20)` en versión activa, `varchar(20)` en otros.
**Corrección:** Estandarizar a `varchar(20)` en todo el sistema.

### INC-005 — MotorDe cambió de tipo
**Dónde:** `sp_insertavehiculo`
**Problema:** Versión anterior era `Motor[1]` tipo `int`. Versión actual es `MotorDe[1]` tipo `nvarchar(10)`.
El campo en la UI de VFP puede estar enviando el nombre antiguo.
**Corrección:** Verificar qué nombre envía el formulario y sincronizar con el SP.

---

## Vulnerabilidades de seguridad

### SEC-001 — Credenciales hardcoded (CRÍTICO)
**Dónde:** 8 formularios VFP
**Código:** `SQLCONNECT("inventarios","sa","")` — usuario `sa`, contraseña vacía
**Impacto:** Cualquier persona con acceso al código o al ejecutable puede ver las credenciales de administrador de SQL Server.
**Corrección en nuevo sistema:** Variables de entorno / secrets manager. Nunca hardcodear credenciales.

### SEC-002 — Cadena de conexión ADO en claro
**Dónde:** `frm_consulta_servicios`
**Código:** `Provider=MSDASQL.1;...Data Source=inventarios;Initial Catalog=db_inventario_pfp`
**Corrección:** Mismo tratamiento que SEC-001.

---

## Archivos a eliminar (no deben existir en producción)

| Archivo | Razón |
|---------|-------|
| `Source/frm_pruebas.scx` + `.sct` | Formulario de desarrollo sin funcionalidad productiva |
| `Source/frm_orden_serviciosbackup.scx` + `.sct` | Backup de formulario, no está en menú |
| `gencode.prg` | Generador de números de serie (herramienta de desarrollo) |
| `Source/facturacion.PJT` | Archivo de proyecto duplicado (ya existe en raíz) |

---

## Decisiones de diseño cuestionables (a revisar en recreación)

| Ítem | Problema | Sugerencia |
|------|---------|-----------|
| `co_ordenes_servicio 1` | Parámetro hardcoded en OLAP | Hacerlo configurable desde UI |
| `empresas.periodo` como MM/AAAA | Período contable como string, no como fecha | Usar tipo fecha o año+mes separados |
| Alias VFP reutilizados en presupuestos | `orden_servicio` apunta a tabla de presupuesto — muy confuso | Nombres propios en sistema nuevo |
| `fecha_ult_mov` sin código de actualización visible | Probablemente trigger — no documentado | Documentar y hacer explícito en nuevo sistema |
