# Memoria — Modelo de Sesión y Privilegios

## Variables globales de sesión
Definidas en `frm_selecciona_empresas` al inicio de la aplicación.

| Variable | Tipo | Definida en | Uso |
|---------|------|------------|-----|
| `nEmpresa` | int | frm_selecciona_empresas | Filtra TODOS los datos por empresa — presente en cada query |
| `cPeriodo` | varchar(7) | frm_selecciona_empresas | Período contable activo (MM/AAAA) — asignado a campo `periodo` en insumos |
| `ncaja` | int | Login cajero | Caja activa — requerida para reportes de historial de facturas |
| `_screen.cReportes` | varchar | frm_selecciona_empresas | Ruta base de archivos .rpt de Crystal Reports |

## Flujo de inicialización de sesión
```
1. Usuario abre la aplicación
2. frm_selecciona_empresas muestra lista de empresas disponibles
3. Usuario selecciona empresa
4. Sistema define: PUBLIC nEmpresa = empresas.id_empresa
5. Sistema define: PUBLIC cPeriodo = empresas.periodo
6. Sistema define: _screen.AddProperty("cReportes", CURDIR())
7. Abre frm_menu_principal
```

## Control de privilegios por campo (módulo Clientes)
El sistema CodeMine usa un sistema de privilegios nombrados. Cada campo sensible del cliente tiene un privilegio asociado:

| Privilegio | Campo controlado | Comportamiento |
|-----------|-----------------|---------------|
| `tarjeta` | Cliente.tarjeta | Solo visible/editable con privilegio |
| `aplica_descuento_cliente` | Cliente.porcentaje_descuento | Solo editable con privilegio + tarjeta no vacía |
| `aplica_forma_pago` | Cliente.credito_o_contado | Solo editable con privilegio |
| `aplica_tipo_precio` | Cliente.tipo_precio | Solo editable con privilegio |
| `aplica_dias_credito` | Cliente.dias_credito | Solo editable con privilegio |
| `rpt_clientes_con_movimiento` | Reporte clientes con movimiento | Solo accesible con privilegio |

## Multi-empresa
- Toda consulta incluye el filtro `id_empresa = nEmpresa`
- El número de orden de servicio y de presupuesto se administra **por empresa** en la tabla `empresas`
- Las bodegas, colores, clientes, vendedores y marcas están asociados a una empresa

## En el nuevo sistema
- Las variables globales (`nEmpresa`, `cPeriodo`, `ncaja`) deben implementarse como contexto de sesión autenticada (JWT claims, session store, o contexto de React/similar)
- El sistema de privilegios por campo debe implementarse como roles y permisos granulares
- El período contable debe ser configurable por empresa y debe mostrarse en la UI para que el usuario sepa en qué período está operando
