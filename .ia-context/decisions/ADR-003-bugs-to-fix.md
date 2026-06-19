# ADR-003 — Bugs y Correcciones en la Recreación

**Estado:** Aceptado
**Fecha:** 2026-06-17

## Decisión
Los siguientes bugs del sistema original **se corregirán durante la recreación**, no se replican.

---

## BUG-001 — Puertas mapeado como Modelo
**Origen:** `sp_insertavehiculo`
**Código incorrecto:**
```sql
nodo.elemento.value('Puertas[1]','int') as Modelo  -- WRONG
```
**Corrección en nuevo sistema:**
- Campo `puertas` → columna `puertas` (int)
- Campo `modelo` → columna `modelo` (varchar(4))
- Son campos separados e independientes en el modelo de datos

---

## BUG-002 — Comision de mecánico como int
**Origen:** Tabla `Mecanico`, campo `Comision int`
**Problema:** Trunca porcentajes decimales (12.5% se guarda como 12)
**Corrección:** `comision decimal(5,2)` — permite hasta 999.99%
**Nota:** El campo `porc_comision` en `vendedores` ya es decimal — consistente.

---

## BUG-003 — SPs duplicados
**Origen:** SQL Server — múltiples versiones del mismo SP
**Afectados:**
- `sp_lista_cliente` × 3 (con SELECTs distintos)
- `sp_lista_producto` × 2
- `sp_lista_marca` + `rpt_lista_marca` (idénticos)
**Corrección:** Un único endpoint/consulta por entidad en el nuevo sistema.

---

## BUG-004 — tblprueba en producción
**Origen:** Tabla `tblprueba`/`TblPrueba` con inserts en SPs de producción
**Corrección:** No crear esta tabla. Eliminarla del dump antes de migrar datos.

---

## INC-001 — id_producto para servicios
**Origen:** Tabla `productos_comisiones.id_producto` referencia servicios
**Corrección:** Renombrar a `id_servicio` en el nuevo sistema para consistencia con `detalle_servicios.id_servicio`

---

## INC-002 — PresionLlantas capitalización
**Corrección:** Usar `presion_llantas` (snake_case) de forma consistente.

---

## INC-003 — NIT tipo inconsistente
**Corrección:** Definir `nit varchar(20)` en todo el sistema. No usar `nvarchar(max)`.

---

## INC-004 — MotorDe campo renombrado
**Contexto:** Campo cambió de `Motor` (int) a `MotorDe` (nvarchar(10)) durante evolución.
**Corrección:** El nuevo sistema usa `motor_de varchar(10)` consistentemente.

---

## SEC-001 — Credenciales hardcoded (CRÍTICO)
**Origen:** `SQLCONNECT("inventarios","sa","")` en 8 formularios
**Corrección en nuevo sistema:**
- Credenciales en variables de entorno (`.env` / secrets manager)
- Nunca en código fuente
- Usuario dedicado con permisos mínimos (no `sa`)
- Contraseña fuerte requerida

---

## SEC-002 — Cadena de conexión ADO en claro
**Origen:** `frm_consulta_servicios`
**Corrección:** Mismo tratamiento que SEC-001.

---

## Limpieza — Archivos que no se recrean
- `frm_pruebas` — formulario de desarrollo
- `frm_orden_serviciosbackup` — backup de formulario
- `gencode.prg` — herramienta de desarrollo
- `tblprueba` — tabla de pruebas

---

## Correcciones de diseño
| Ítem actual | Corrección propuesta |
|------------|---------------------|
| `co_ordenes_servicio` con parámetro hardcoded=1 | Hacerlo configurable desde UI |
| `periodo` como string MM/AAAA | Usar tipo fecha o campos año+mes por separado |
| `fecha_ult_mov` actualizado por trigger oculto | Hacer explícito el mecanismo de actualización |
| Alias VFP reutilizados en presupuestos | Nombres propios y claros en nuevo sistema |
