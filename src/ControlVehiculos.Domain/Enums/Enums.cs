namespace ControlVehiculos.Domain.Enums;

/// <summary>
/// Tipo de tercero en Tbl_Proveedores.Tipo ('C'=Cliente, 'P'=Proveedor, 'A'=Ambos)
/// </summary>
public enum TipoTercero
{
    Cliente = 'C',
    Proveedor = 'P',
    Ambos = 'A'
}

/// <summary>
/// Tbl_Orden_Servicio.Status / Tbl_Presupuesto_Orden_Servicio.Status
/// </summary>
public enum StatusOrden
{
    Abierta = 1,
    Cerrada = 2
}

/// <summary>
/// Tbl_presupuesto_servicio.status (presupuesto legacy)
/// </summary>
public enum StatusPresupuesto
{
    Abierto = 1,
    Cerrado = 2
}

/// <summary>
/// Tbl_Orden_Servicio_Detalle_Integracion.Se_Cobra ('S'/'N')
/// </summary>
public enum SeCobraInsumo
{
    Si = 'S',
    No = 'N'
}

/// <summary>
/// tbl_productos_comisiones.Tipo_comision
/// </summary>
public enum TipoComision
{
    ValorFijo = 1,
    Porcentaje = 2
}

/// <summary>
/// Tbl_Vendedores.status ('A'=Activo, 'B'=Baja)
/// </summary>
public enum StatusVendedor
{
    Activo = 'A',
    Baja = 'B'
}
