# ADR-001 — Objetivo de la Migración

**Estado:** Aceptado
**Fecha:** 2026-06-17

## Contexto
El sistema ControlVehiculosIA está actualmente en producción en Visual FoxPro + SQL Server.
VFP es una tecnología descontinuada por Microsoft. El sistema funciona correctamente pero necesita modernizarse.

## Decisión
Recrear el sistema completo en tecnologías modernas, conservando **toda la lógica de negocio** tal como está hoy, y corrigiendo los bugs y vulnerabilidades conocidas durante la recreación.

## Qué se conserva (lógica de negocio)
- El flujo completo: Cliente → Vehículo → Presupuesto → Orden de Servicio → Facturación
- El ciclo de vida de la OS: status 1 → 2 → numero > 0
- La regla de reversión: solo si status=2 AND numero=0 AND fecha_facturacion IS NULL
- La conversión presupuesto→OS (solo ítems autorizados)
- El control de privilegios granular por campo en datos del cliente
- El período contable como contexto de operaciones
- La búsqueda genérica parametrizable (como componente reutilizable)
- Las comisiones: tipo 1=valor fijo, tipo 2=porcentaje
- El modelo multi-empresa (todo filtrado por id_empresa)
- Los mismos reportes con los mismos datos y parámetros
- La numeración de órdenes por empresa (sig_orden_servicio)
- El límite de líneas por documento (total_detalle_lineas)

## Qué se cambia (tecnología y bugs)
- Lenguaje y framework → por definir (ver ADR futuros)
- Base de datos → por definir (puede seguir siendo SQL Server o migrar)
- Crystal Reports → librería de PDF moderna
- ContourCubeLite OLAP → herramienta BI web moderna
- Credenciales hardcoded → variables de entorno / secrets manager
- Tablas DBF locales → eliminadas, todo en la BD central
- Registro de Windows → configuración en BD o archivo
- ODBC DSN → connection string directa

## Qué se corrige (bugs conocidos — ver ADR-003)
- BUG-001: Puertas mapeado como Modelo
- BUG-002: Comision mecánico como int
- BUG-003: SPs duplicados
- BUG-004: tblprueba en producción
- INC-001 a INC-005: Inconsistencias de nomenclatura

## Consecuencias
- El nuevo sistema debe ser funcionalmente equivalente al actual para los usuarios
- La migración de datos de SQL Server debe ser parte del plan de implementación
- Los reportes deben producir la misma información en nuevo formato
