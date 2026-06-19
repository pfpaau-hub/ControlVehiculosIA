using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class ProductoComision
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(15)] public string IdProducto { get; set; } = "";
    public int TipoComision { get; set; }
    public decimal ValorComision { get; set; }
    public decimal PorcentajeComision { get; set; }

    public Producto? Producto { get; set; }
}
