# Formularios — Utilitarios y Sistema

## frm_selecciona_empresas
**Tipo:** Login / Inicio de sesión
**Propósito:** Primer formulario que ve el usuario — selecciona empresa activa

### Lo que hace
```vfp
PUBLIC nEmpresa, cPeriodo
nEmpresa = Empresas.Id_Empresa
cPeriodo = Empresas.Periodo
_screen.AddProperty("cReportes", CURDIR())
m.goStateManager.OpenForm('source\frm_menu_principal.scx')
```

### En nuevo sistema
- Reemplazar con autenticación real (usuario + contraseña)
- La empresa se asocia al usuario autenticado (o se selecciona post-login)
- El período contable activo se carga desde la configuración de la empresa
- La ruta de reportes no aplica (reportes se generan en servidor)

---

## frm_menu_principal
**Tipo:** Menú gráfico principal
**Accesos directos a:**
- frm_clientes
- frm_vehiculos
- frm_bancos
- frm_colores_vehiculos
- frm_presupuestos_new (etiqueta: "Presupuesto Servicio")
- frm_cambia_porcentaje_ordenes
- (y demás módulos via botones adicionales)

---

## frm_pantalla_busqueda
**Tipo:** Componente genérico de búsqueda parametrizable
**Propósito:** Buscador reutilizable en múltiples módulos

### Parámetros que recibe
| Parámetro | Descripción |
|-----------|-------------|
| ccampos | Campos a mostrar en la grilla de resultados |
| cfrom | Tabla o cursor fuente |
| calias | Alias de la fuente de datos |
| ctitulos | Títulos de las columnas de la grilla |
| calias_origen | Alias del formulario que abrió el buscador |
| cfiltro_busqueda | Condición WHERE adicional |

### Comportamiento
- Muestra hasta 3 columnas con radio buttons para cambiar el criterio de búsqueda
- Al seleccionar un registro, devuelve el valor al formulario origen (calias_origen)
- Búsqueda incremental: filtra mientras el usuario escribe

### En nuevo sistema
Implementar como componente de búsqueda/filtro reutilizable con:
- Mismo concepto de columnas configurables
- Retorno del valor seleccionado al componente padre
- Búsqueda en tiempo real

---

## frm_consulta_servicios
**Tipo:** Análisis OLAP
**Control:** ContourCubeLite (control OLE propietario)

### Conexión
```
ADO directo:
Provider=MSDASQL.1
Data Source=inventarios
Initial Catalog=db_inventario_pfp
```

### SP llamado
```sql
EXEC co_ordenes_servicio 1  -- parámetro hardcoded
```

### En nuevo sistema
Reemplazar con herramienta BI moderna:
- Opción simple: tabla pivot en el frontend (AG Grid, Tabulator)
- Opción completa: integración con Metabase, Grafana, PowerBI embebido
- El parámetro hardcoded=1 debe hacerse configurable desde la UI
- Exponer el SP `co_ordenes_servicio` o su equivalente como endpoint de datos
