// Tabla origen: [empresas] — 42 campos reales
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Empresa
{
    public int Id { get; set; }                          // surrogate PK
    public int IdEmpresa { get; set; }                   // clave natural original

    [MaxLength(100)] public string? NombreEmpresa { get; set; }
    public int? PorcentajeIvaAnterior { get; set; }
    public int? PorcentajeIva { get; set; }
    [MaxLength(7)]  public string? Periodo { get; set; }
    public int? LmodificaPrecios { get; set; }
    public int? SigOrdenServicio { get; set; }
    public decimal? PorcentajeUtilidad { get; set; }
    public DateTime? Apartirde { get; set; }
    [MaxLength(10)] public string IdBodegaFacturacion { get; set; } = "";
    [MaxLength(10)] public string IdCuentaCxp { get; set; } = "";
    public int LmodificaCostos { get; set; }
    public int TotalDetalleLineas { get; set; }
    [MaxLength(10)] public string IdCuentaEfectivo { get; set; } = "";
    [MaxLength(10)] public string IdCuentaBanco { get; set; } = "";
    [MaxLength(10)] public string IdCuentaCredito { get; set; } = "";
    [MaxLength(10)] public string IdCuentaAnticipo { get; set; } = "";
    [MaxLength(10)] public string IdCuentaDebito { get; set; } = "";
    [MaxLength(10)] public string IdCuentaDebitoFiscal { get; set; } = "";
    [MaxLength(200)] public string Direccion { get; set; } = "";
    [MaxLength(50)] public string Telefonos { get; set; } = "";
    [MaxLength(20)] public string Fax { get; set; } = "";
    [MaxLength(50)] public string Email { get; set; } = "";
    [MaxLength(15)] public string? Nit { get; set; }
    public int IdContrasena { get; set; }
    [MaxLength(10)] public string IdCuentaAnticipoProveedores { get; set; } = "";
    [MaxLength(10)] public string IdCuentaCxc { get; set; } = "";
    [MaxLength(10)] public string IdCuentaVtas { get; set; } = "";
    [MaxLength(3)]  public string IdDeptoVtas { get; set; } = "";
    [MaxLength(10)] public string IdCuentaDepTransitoCxc { get; set; } = "";
    public int SigNumeroPresupuesto { get; set; }
    public int? PorcentajeUtilidadSobre { get; set; }
    [MaxLength(10)] public string FacturaCon { get; set; } = "";
    [MaxLength(100)] public string? NombreComercial { get; set; }
    [MaxLength(10)] public string? IdCuentaRebajaSventa { get; set; }
    public int UsaOrdenDespacho { get; set; }
    [MaxLength(10)] public string? OperaConMoneda { get; set; }
    public decimal? TasaCambio { get; set; }
    public int? IngresaFechaAlFacturar { get; set; }
    public int? FacturacionMultibodega { get; set; }
    [MaxLength(10)] public string? IdCuentaRetencionIvaClientes { get; set; }
    public int? FacturaEnBaseAplantillas { get; set; }
    public int? UtilizaCorrelativoContrasenaspago { get; set; }
    [MaxLength(80)] public string? DirectorioLogo { get; set; }
    public int? PermiteExistenciaNegativa { get; set; }
    [MaxLength(15)] public string? IdPropina { get; set; }
    public int? TipoOrdenAActualizar { get; set; }
    public int? OrdenEnvioPosFActura { get; set; }
    [MaxLength(10)] public string? MascaraCantidad { get; set; }
    public int? AgenteRetenedorIva { get; set; }
    [MaxLength(15)] public string? RegimenFiscalIsr { get; set; }
    [MaxLength(10)] public string? IdCuentaRetencionIsrClientes { get; set; }
    public int? TipoColaOrdenes { get; set; }
    public int? TipoCorrelOrden { get; set; }
    public bool ImprimeCopia { get; set; }
    [MaxLength(15)] public string? NumeroOrdenCompra { get; set; }
    public int CorrelativoComanda { get; set; }
    public DateTime? FechaSistema { get; set; }
    [MaxLength(100)] public string? FormatoOcompra { get; set; }
}
