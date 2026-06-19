using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Producto
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(15)] public string IdProducto { get; set; } = "";
    [MaxLength(100)] public string? Descripcion { get; set; }
    [MaxLength(18)] public string? CodigoBarras { get; set; }
    public decimal CostoPromedio { get; set; }
    [MaxLength(10)] public string? Tipo { get; set; }
    [MaxLength(15)] public string Propiedad1 { get; set; } = "";
    [MaxLength(15)] public string Propiedad2 { get; set; } = "";
    [MaxLength(15)] public string Propiedad3 { get; set; } = "";
    [MaxLength(15)] public string Propiedad4 { get; set; } = "";
    [MaxLength(15)] public string Propiedad5 { get; set; } = "";
    [MaxLength(15)] public string Propiedad6 { get; set; } = "";
    public decimal? CantidadEquivalente { get; set; }
    [MaxLength(5)]  public string IdArticulo { get; set; } = "";
    [MaxLength(3)]  public string IdMedida { get; set; } = "";
    [MaxLength(3)]  public string IdMedida1 { get; set; } = "";
    public DateTime? FechaAlta { get; set; }
    [MaxLength(200)] public string? FotoProducto { get; set; }
    public int? Minimo { get; set; }
    public int? Maximo { get; set; }
    [MaxLength(3)]  public string IdDepto { get; set; } = "";
    [MaxLength(2)]  public string? IdLinea { get; set; }
    [MaxLength(100)] public string DescripcionCorta { get; set; } = "";
    public decimal? UltimoCosto { get; set; }
    public decimal? Precioa { get; set; }
    public decimal? Preciob { get; set; }
    public decimal? Precioc { get; set; }
    public DateTime? FechaUltMov { get; set; }
    [MaxLength(1)]  public string? UsaSubProductos { get; set; }
    public int EsServicio { get; set; }
    public int? AplicarDescuento { get; set; }
    public decimal PorcentajeUtilidad { get; set; }
    public decimal PrecioSugerido { get; set; }
    [MaxLength(80)] public string Usuario { get; set; } = "";
    public DateTime FechaHora { get; set; }
    [MaxLength(20)] public string Ubicacion { get; set; } = "";
    public decimal? PorcMaxDescuento { get; set; }
    [MaxLength(15)] public string? Estado { get; set; }
    public int? PermiteModificarPrecio { get; set; }

    public ProductoComision? Comision { get; set; }
    public ICollection<InsumoServicio> InsumosComoServicio { get; set; } = new List<InsumoServicio>();
    public ICollection<InsumoServicio> InsumosComoInsumo { get; set; } = new List<InsumoServicio>();
}
