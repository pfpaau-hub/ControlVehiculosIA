# Formularios — Clientes

## frm_clientes
**Tipo:** CRUD principal
**Pestañas:** 2 — Datos del cliente / Vehículos asignados

### Campos (tabla `clientes`)
| Campo VFP | Tipo | Reglas UI |
|-----------|------|----------|
| nit | varchar(20) | PK, máscara 20 chars mayúsculas, readonly excepto en Nuevo |
| nombre | varchar(100) | Razón social |
| facturar_a | varchar(100) | Requerido |
| telefono | varchar(20) | Teléfono principal |
| telefono1 | varchar(20) | Teléfono secundario |
| colonia | varchar(50) | |
| apto | varchar(20) | |
| zona | varchar(10) | |
| direccion | varchar(200) | |
| num_casa | varchar(10) | |
| ciudad | varchar(50) | |
| municipio | varchar(50) | |
| correo_electro | varchar(100) | |
| fecha_ult_mov | datetime | Solo lectura |

### Pestaña 2 — Vehículos asignados (grilla)
Campos mostrados: `num_placa`, `marca`, `linea`, `tipo`, `color`, `fecha_ult_mov`
Query VFP local:
```sql
SELECT num_placa, marca, linea, tipo, color, fecha_ult_mov
FROM vehiculos
WHERE ALLTRIM(nit) = ALLTRIM(a)
ORDER BY marca
INTO CURSOR Vehiculos_Asignados
```

### Reglas de negocio
- El NIT está deshabilitado (`lenabled=.F.`) por defecto; solo se activa al crear nuevo registro
- Al cambiar NIT en modo Nuevo: verifica que no exista con LOCATE en tabla VFP local
- Filtro en cursor: `nit <> "XXXXXXXXXXXXXXXXXXXX"` (excluye registros especiales del sistema)
- Usa BufferModeOverride=3 para buffer optimista de tabla

### SQL Server
- Ninguno directo desde este formulario
- Opera sobre tabla VFP local sincronizada con SQL Server

---

## frm_clientes_children
**Tipo:** Formulario hijo modal — "Datos Tarjetahabiente"
**Se abre desde:** frm_clientes (botón de datos adicionales)

### Campos (tabla `clientes` — campos financieros)
| Campo VFP | Tipo | Reglas UI |
|-----------|------|----------|
| identificacion | varchar(20) | |
| tarjeta | varchar(20) | Requiere privilegio `tarjeta` |
| porcentaje_descuento | decimal | Máscara "99", solo activo si tarjeta ≠ vacío, privilegio `aplica_descuento_cliente` |
| credito_o_contado | varchar(10) | Combo: "Crédito"/"Contado", privilegio `aplica_forma_pago` |
| tipo_precio | varchar(1) | Combo A/B/C, requerido, privilegio `aplica_tipo_precio` |
| dias_credito | int | Máscara "99", privilegio `aplica_dias_credito` |

### Regla clave
```vfp
* El campo porcentaje_descuento solo se habilita si tarjeta no está vacía:
RETURN IIF(EMPTY(clientes.tarjeta), .F., .T.)
```

### En nuevo sistema
- Los privilegios deben implementarse como permisos de rol
- El campo `porcentaje_descuento` tiene dependencia con `tarjeta` (validación en frontend y backend)
- Considerar mostrar estos campos en la misma vista del cliente pero con visibilidad condicional por rol
