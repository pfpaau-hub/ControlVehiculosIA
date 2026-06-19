# Formularios — Vehículos

## frm_vehiculos
**Tipo:** CRUD principal
**Pestañas:** 2 — Datos principales / Otros Datos Vehículo

### Cursores / DataEnvironment
| Cursor | Tabla | Notas |
|--------|-------|-------|
| vehiculos | vehiculos | BufferModeOverride=3 |
| clientes | clientes | Para lookup NIT |
| marcas | marcas | |
| colores | colores | BufferModeOverride=3 |
| linea_vehiculos | linea_vehiculos | Filtrado por marca activa |
| tipos_vehiculos | tipos_vehiculos | |
| ordenes_por_placa | ordenes | NoDataOnLoad=.T. — carga al ver historial |

### Campos pestaña 1 (datos principales)
| Campo | Reglas UI |
|-------|----------|
| num_placa | PK, máscara mayúsculas, requerido |
| nit | Doble combo: por NIT o por nombre de cliente |
| marca | Combo, al cambiar recarga combo de líneas |
| linea | Combo, filtrado por marca seleccionada |
| tipo | Combo tipos_vehiculos |
| color | Combo colores, **requerido** — error explícito si vacío al guardar |
| modelo | varchar(4) — año |
| fecha_ult_mov | Solo lectura |

### Campos pestaña 2 (datos técnicos)
| Campo | Tipo | Reglas |
|-------|------|--------|
| presion_llantas | int | PSI |
| servicio_cada | varchar(5) | Intervalo de mantenimiento |
| unidad_medida | varchar(10) | Combo: "Millas" / "Kilometros" |
| puertas | int | |
| cilindros | int | |
| motor | varchar(25) | Descripción del motor |
| combustible | varchar(10) | Combo: "Gasolina" / "Diesel" |

### Comportamientos especiales
1. **Cambio de marca → recarga líneas:**
   `requery("LINEA_VEHICULOS")` al cambiar combo de marca
2. **Agregar color nuevo inline:**
   Botón que abre `frm_colores_vehiculos2` modal sin perder el formulario actual
3. **Ver historial de OS:**
   Botón que hace `SQLCONNECT("inventarios","sa","")` + `requery("ORDENES_POR_PLACA")` y abre `frm_historial_vehiculos`
4. **Doble búsqueda de cliente:**
   Combo 1: selecciona por NIT
   Combo 2: selecciona por nombre → sincroniza ambos combos

### Búsquedas locales VFP
```vfp
SELECT nit, nombre FROM clientes INTO CURSOR cli ORDER BY nit
SELECT num_placa, marca, linea, color FROM vehiculos INTO CURSOR curplacas
```

---

## frm_historial_vehiculos
**Tipo:** Solo lectura — hijo de frm_vehiculos
**Apertura:** `openchild("frm_historial_vehiculos.scx")` desde frm_vehiculos

### Grilla (cursor ordenes_por_placa)
| Campo | Descripción |
|-------|------------|
| fecha | Fecha de la OS |
| id_orden | Número de orden |
| fecha_facturacion | Fecha en que se facturó (NULL si no facturada) |
| numero | Número de factura (0 si no facturada) |
| facturar_a | Cliente de la OS |

### Botón "Imprimir Orden"
Llama: `rpt_servicios.rpt(nEmpresa, norden, 'O')`

---

## frm_mas_datos
**Tipo:** Info no modal — datos del vehículo en contexto de OS
**Campos:** tipo, marca, linea, color (read-through de `vehiculos`)

---

## frm_mas_datos1
**Tipo:** Info modal — mismos campos que frm_mas_datos en layout de pestañas
**Uso:** Versión modal de frm_mas_datos para cuando se necesita confirmación
