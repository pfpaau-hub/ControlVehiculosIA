// Tabla origen: [Tbl_Proveedores]
// NOTA: esta tabla sirve para clientes Y proveedores. Tipo char(1): 'C','P','A'
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Proveedor
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(20)] public string Nit { get; set; } = "";         // clave natural
    [MaxLength(100)] public string Nombre { get; set; } = "";
    public int CreditoOContado { get; set; }
    public int DiasCredito { get; set; }
    [MaxLength(80)] public string Contacto { get; set; } = "";
    [MaxLength(80)] public string CorreoElectro { get; set; } = "";
    [MaxLength(100)] public string Direccion { get; set; } = "";
    [MaxLength(50)] public string Colonia { get; set; } = "";
    [MaxLength(10)] public string Apto { get; set; } = "";
    [MaxLength(2)]  public string Zona { get; set; } = "";
    [MaxLength(50)] public string Ciudad { get; set; } = "";
    [MaxLength(30)] public string Telefono { get; set; } = "";
    [MaxLength(20)] public string Tarjeta { get; set; } = "";
    [MaxLength(5)]  public string NumCasa { get; set; } = "";
    [MaxLength(40)] public string Municipio { get; set; } = "";
    [MaxLength(30)] public string Telefono1 { get; set; } = "";
    [MaxLength(1)]  public string Tipo { get; set; } = "";        // 'C'/'P'/'A'
    [MaxLength(10)] public string LocalExtranjero { get; set; } = "";
    public DateTime? FechaUltMov { get; set; }
    [MaxLength(2)]  public string RetieneIsr { get; set; } = "";
    [MaxLength(100)] public string FacturarA { get; set; } = "";
    [MaxLength(1)]  public string TipoPrecio { get; set; } = "";
    public int PorcentajeDescuento { get; set; }
    [MaxLength(20)] public string Identificacion { get; set; } = "";
    public DateTime FechaUltMovProv { get; set; }
    [MaxLength(2)]  public string IdConceptoServicio { get; set; } = "";
    public int TipoIva { get; set; }
    [MaxLength(10)] public string IdCuentaCxp { get; set; } = "";
    [MaxLength(10)] public string Clasificacion { get; set; } = "";
    public int PagaIva { get; set; }
    public decimal LimiteCreditoCliente { get; set; }
    public int? EsAgenteRetenedorIva { get; set; }
    public int? TieneExencionIva { get; set; }
    [MaxLength(2)]  public string? TipoAgenteRetenedorIva { get; set; }
    public decimal? PorcentajeAgenteRetendorIva { get; set; }
    [MaxLength(10)] public string? IdGrupoCliente { get; set; }
    public int TipoPoliticaCredito { get; set; }
    public int? RegimenContribyente { get; set; }
    [MaxLength(200)] public string? Beneficiario { get; set; }

    // Navigation
    public ICollection<Vehiculo> Vehiculos { get; set; } = new List<Vehiculo>();
    public ICollection<OrdenServicio> OrdenesServicio { get; set; } = new List<OrdenServicio>();
    public ICollection<PresupuestoOrdenServicio> Presupuestos { get; set; } = new List<PresupuestoOrdenServicio>();
}
