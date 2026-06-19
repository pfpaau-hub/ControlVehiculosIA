# Lógica Reconstruida — SPs y Triggers Faltantes

> Generado: 2026-06-18
> Fuente: inferencia desde DDL, `sp_genera_orden_servicio`, fragmentos de triggers, y reglas de negocio.
> Confianza: Alta (🟢) / Media (🟡) por sección.

---

## 1. Función `dbo.total_lineas_orden` 🟢

**Propósito:** Contar las líneas de servicio de una OS para validar contra el límite `empresas.total_detalle_lineas`.

**Evidencia:** Referenciada en formulario VFP como `dbo.total_lineas_orden(nEmpresa, cOrden)`. Solo cuenta líneas de servicio (no insumos — los insumos son sub-ítems de una línea de servicio, no líneas independientes).

**Reconstrucción:**

```sql
CREATE FUNCTION dbo.total_lineas_orden (
    @Id_Empresa int,
    @Id_Orden   int
)
RETURNS int
AS
BEGIN
    DECLARE @total int
    SELECT @total = COUNT(*)
    FROM Tbl_Orden_Servicio_Detalle
    WHERE Id_Empresa = @Id_Empresa
      AND Id_Orden   = @Id_Orden
    RETURN ISNULL(@total, 0)
END
```

**Uso en el nuevo sistema:** Implementar como método en la capa de servicio: `bool LimiteLineasAlcanzado(int empresa, int orden)` que compare el resultado contra `empresas.total_detalle_lineas`.

---

## 2. `sp_cambia_descuento_ordenes` 🟡

**Propósito:** Aplicar o retirar el descuento del cliente a todas las líneas de una OS completa.

**Evidencia:**
- Llamado desde `frm_cambia_porcentaje_ordenes` con parámetros `@nempresa, @norden, @naplica_descuento`
- `Tbl_Proveedores` tiene el campo `Porcentaje_descuento int`
- `Tbl_Orden_Servicio` tiene `Nit` para obtener el cliente
- `Tbl_Orden_Servicio_Detalle` tiene `Precio`, `Precio_Descuento`, `Total_Linea`, `Total_Linea_Descuento`, `otros`, `otros_Descuento`
- `Tbl_Orden_Servicio_Detalle_Integracion` tiene `Precio`, `Precio_descuento`, `Total_Linea`, `Total_Linea_descuento`

**Lógica inferida:**
1. Obtiene el `Porcentaje_descuento` del cliente desde `Tbl_Proveedores` vía la OS
2. Si `@naplica_descuento = 1` (aplicar): calcula precios con descuento
3. Si `@naplica_descuento = 0` (retirar): iguala precios de descuento a precios normales

**Reconstrucción:**

```sql
CREATE PROCEDURE sp_cambia_descuento_ordenes
    @Id_Empresa        int,
    @Id_Orden          int,
    @Aplica_Descuento  int   -- 1 = aplicar descuento, 0 = retirar
AS
BEGIN
    DECLARE @Porcentaje numeric(18,2)
    DECLARE @Factor     numeric(18,6)

    -- Obtener porcentaje del cliente asociado a la OS
    SELECT @Porcentaje = p.Porcentaje_descuento
    FROM Tbl_Orden_Servicio os
    JOIN Tbl_Proveedores p
      ON p.Id_Empresa = os.Id_Empresa AND p.Nit = os.Nit
    WHERE os.Id_Empresa = @Id_Empresa AND os.Id_Orden = @Id_Orden

    SET @Factor = 1 - (ISNULL(@Porcentaje, 0) / 100.0)

    IF @Aplica_Descuento = 1
    BEGIN
        -- Aplicar descuento a servicios
        UPDATE Tbl_Orden_Servicio_Detalle
        SET Precio_Descuento        = Precio * @Factor,
            Total_Linea_Descuento   = Cantidad * (Precio * @Factor),
            otros_Descuento         = otros * @Factor
        WHERE Id_Empresa = @Id_Empresa AND Id_Orden = @Id_Orden

        -- Aplicar descuento a insumos
        UPDATE Tbl_Orden_Servicio_Detalle_Integracion
        SET Precio_descuento        = Precio * @Factor,
            Total_Linea_descuento   = Cantidad * (Precio * @Factor)
        WHERE Id_Empresa = @Id_Empresa AND Id_Orden = @Id_Orden
    END
    ELSE
    BEGIN
        -- Retirar descuento: igualar campos de descuento a los normales
        UPDATE Tbl_Orden_Servicio_Detalle
        SET Precio_Descuento        = Precio,
            Total_Linea_Descuento   = Total_Linea,
            otros_Descuento         = otros
        WHERE Id_Empresa = @Id_Empresa AND Id_Orden = @Id_Orden

        UPDATE Tbl_Orden_Servicio_Detalle_Integracion
        SET Precio_descuento        = Precio,
            Total_Linea_descuento   = Total_Linea
        WHERE Id_Empresa = @Id_Empresa AND Id_Orden = @Id_Orden
    END
END
```

**Incertidumbre (🟡):** No confirmado si el descuento viene del cliente o si el formulario lo pide al usuario. Si el usuario ingresa un porcentaje manualmente, agregar `@Porcentaje numeric(18,2)` como parámetro adicional y omitir el JOIN a `Tbl_Proveedores`.

---

## 3. Triggers en `Tbl_Orden_Servicio_Detalle_Integracion` 🟡

### Contexto clave

`Tbl_Orden_Servicio_Detalle.otros` es el **subtotal de insumos cobrados** (`Se_Cobra='S'`) que pertenecen a una línea de servicio. Los triggers mantienen este campo sincronizado automáticamente cuando se insertan, modifican o eliminan insumos.

```
Tbl_Orden_Servicio_Detalle (servicio)
  ├── otros              ← SUM(insumos Se_Cobra='S' → Total_Linea)
  ├── otros_Descuento    ← SUM(insumos Se_Cobra='S' → Total_Linea_descuento)
  └── Tbl_Orden_Servicio_Detalle_Integracion (insumos)
        ├── Linea (FK → servicio padre)
        ├── Se_Cobra ('S'/'N')
        ├── Total_Linea
        └── Total_Linea_descuento
```

---

### Trigger INSERT — `T_I_Tbl_Orden_Servicio_Detalle_Integracion` 🟡

**Evidencia:** Fragmento visible: `Declare @Fecha_ult_Movimiento` — actualiza `Fecha_Ult_Mov` en el vehículo (o cliente) cuando se agrega un insumo a una OS activa.

**Reconstrucción:**

```sql
CREATE TRIGGER T_I_Tbl_Orden_Servicio_Detalle_Integracion
ON Tbl_Orden_Servicio_Detalle_Integracion
FOR INSERT
AS
BEGIN
    -- 1. Actualizar otros (subtotal insumos) en la línea de servicio padre
    UPDATE d
    SET d.otros         = d.otros         + ISNULL(i.Total_Linea, 0),
        d.otros_Descuento = d.otros_Descuento + ISNULL(i.Total_Linea_descuento, 0),
        d.Total_Linea   = d.Precio * d.Cantidad + d.otros + ISNULL(i.Total_Linea, 0),
        d.Total_Linea_Descuento = d.Precio_Descuento * d.Cantidad
                                + d.otros_Descuento + ISNULL(i.Total_Linea_descuento, 0)
    FROM Tbl_Orden_Servicio_Detalle d
    JOIN inserted i
      ON d.Id_Empresa = i.Id_Empresa
     AND d.Id_Orden   = i.Id_Orden
     AND d.Linea      = i.Linea
    WHERE i.Se_Cobra = 'S'

    -- 2. Actualizar Fecha_Ult_Mov en el vehículo
    UPDATE v
    SET v.Fecha_Ult_Mov = GETDATE()
    FROM Tbl_Vehiculos v
    JOIN Tbl_Orden_Servicio os
      ON os.Id_Empresa = v.Id_Empresa AND os.Num_Placa = v.Num_Placa
    JOIN inserted i
      ON i.Id_Empresa = os.Id_Empresa AND i.Id_Orden = os.Id_Orden
END
```

---

### Trigger UPDATE — `T_u_Tbl_Orden_Servicio_Detalle_Integracion` 🟡

**Evidencia:** Fragmento visible: `------desactualizando` — patrón clásico de triggers UPDATE: primero revierte el valor anterior (con DELETED), luego aplica el nuevo (con INSERTED).

**Reconstrucción:**

```sql
CREATE TRIGGER T_u_Tbl_Orden_Servicio_Detalle_Integracion
ON Tbl_Orden_Servicio_Detalle_Integracion
FOR UPDATE
AS
BEGIN
    -- Paso 1: Desactualizando — restar el valor anterior (de DELETED)
    UPDATE d
    SET d.otros           = d.otros           - ISNULL(del.Total_Linea, 0),
        d.otros_Descuento = d.otros_Descuento - ISNULL(del.Total_Linea_descuento, 0)
    FROM Tbl_Orden_Servicio_Detalle d
    JOIN deleted del
      ON d.Id_Empresa = del.Id_Empresa
     AND d.Id_Orden   = del.Id_Orden
     AND d.Linea      = del.Linea
    WHERE del.Se_Cobra = 'S'

    -- Paso 2: Actualizando — sumar el valor nuevo (de INSERTED)
    UPDATE d
    SET d.otros           = d.otros           + ISNULL(ins.Total_Linea, 0),
        d.otros_Descuento = d.otros_Descuento + ISNULL(ins.Total_Linea_descuento, 0),
        d.Total_Linea     = d.Precio * d.Cantidad + d.otros + ISNULL(ins.Total_Linea, 0),
        d.Total_Linea_Descuento = d.Precio_Descuento * d.Cantidad
                                + d.otros_Descuento + ISNULL(ins.Total_Linea_descuento, 0)
    FROM Tbl_Orden_Servicio_Detalle d
    JOIN inserted ins
      ON d.Id_Empresa = ins.Id_Empresa
     AND d.Id_Orden   = ins.Id_Orden
     AND d.Linea      = ins.Linea
    WHERE ins.Se_Cobra = 'S'
END
```

---

### Trigger DELETE — `T_D_Tbl_Orden_Servicio_Detalle_Integracion` 🟡

**Evidencia:** Fragmento visible: `Declare @Costo_Tot` — al eliminar un insumo, descuenta su valor de `otros` en la línea de servicio padre.

**Reconstrucción:**

```sql
CREATE TRIGGER T_D_Tbl_Orden_Servicio_Detalle_Integracion
ON Tbl_Orden_Servicio_Detalle_Integracion
FOR DELETE
AS
BEGIN
    DECLARE @Costo_Tot numeric(18,5)

    -- Restar el insumo eliminado del subtotal en la línea de servicio padre
    UPDATE d
    SET d.otros           = d.otros           - ISNULL(del.Total_Linea, 0),
        d.otros_Descuento = d.otros_Descuento - ISNULL(del.Total_Linea_descuento, 0),
        d.Total_Linea     = d.Precio * d.Cantidad
                          + (d.otros - ISNULL(del.Total_Linea, 0)),
        d.Total_Linea_Descuento = d.Precio_Descuento * d.Cantidad
                                + (d.otros_Descuento - ISNULL(del.Total_Linea_descuento, 0))
    FROM Tbl_Orden_Servicio_Detalle d
    JOIN deleted del
      ON d.Id_Empresa = del.Id_Empresa
     AND d.Id_Orden   = del.Id_Orden
     AND d.Linea      = del.Linea
    WHERE del.Se_Cobra = 'S'
END
```

---

## 4. Triggers en `Tbl_Orden_Servicio` 🟡

Los triggers INSERT/UPDATE/DELETE en la cabecera de la OS no tienen fragmentos visibles útiles. Su comportamiento se infiere del patrón estándar en la misma BD:

| Trigger | Lógica inferida |
|---------|----------------|
| `T_I_Tbl_Orden_Servicio` (INSERT) | Actualiza `Tbl_Vehiculos.Fecha_Ult_Mov = GETDATE()` y `Tbl_Proveedores.Fecha_ult_Mov = GETDATE()` al crear la OS |
| `T_U_Tbl_Orden_Servicio` (UPDATE) | Actualiza `Fecha_Ult_Mov` en vehículo y cliente al cerrar (`Status=2`) o facturar |
| `T_D_Tbl_Orden_Servicio` (DELETE) | Impide DELETE si existen filas en `Tbl_Orden_Servicio_Detalle` o `Tbl_Orden_Servicio_Detalle_Integracion` — retorna error |

---

## 5. Recomendación para el nuevo sistema

**No recrear los triggers como triggers en la nueva BD.** Implementar la misma lógica de forma explícita en la capa de servicio (C# / NestJS):

| Lógica del trigger | Implementación recomendada |
|--------------------|---------------------------|
| `otros` = suma de insumos | Recalcular en `AgregarInsumo()`, `ActualizarInsumo()`, `EliminarInsumo()` |
| `fecha_ult_mov` en vehículo | Actualizar en `CrearOrdenServicio()` y `AgregarInsumo()` |
| `fecha_ult_mov` en cliente | Actualizar en `CrearOrdenServicio()` |
| Integridad referencial (no borrar) | Validar existencia de dependientes antes del DELETE en capa de servicio |

Esto hace la lógica visible, testeable y sin efectos secundarios implícitos.

---

## Resumen de confianza

| Pieza | Confianza | Razonamiento |
|-------|-----------|-------------|
| `total_lineas_orden` | 🟢 Alta | Función simple de COUNT — no hay otra interpretación posible |
| `sp_cambia_descuento_ordenes` — estructura | 🟢 Alta | DDL + parámetros del formulario son suficientes |
| `sp_cambia_descuento_ordenes` — fuente del % | 🟡 Media | Puede venir del cliente o del usuario — confirmar con el equipo |
| Triggers `otros`/`otros_Descuento` | 🟢 Alta | Patrón estándar; `otros` en DDL tiene semántica explícita de "subtotal insumos" |
| Trigger INSERT — `fecha_ult_mov` vehículo | 🟡 Media | El fragmento solo dice `@Fecha_ult_Movimiento`; podría ser también el cliente |
| Triggers `T_I/T_U/T_D_Tbl_Orden_Servicio` | 🟡 Media | No hay fragmentos; inferido desde patrones de la misma BD |
