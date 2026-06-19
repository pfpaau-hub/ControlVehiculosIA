using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class InsumoServicio
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(15)] public string IdProducto { get; set; } = "";
    [MaxLength(15)] public string IdProducto1 { get; set; } = "";
    public decimal Costo { get; set; }
    public decimal? Cantidad { get; set; }

    public Producto? Servicio { get; set; }
    public Producto? Insumo { get; set; }
}
