// Tabla origen: [Tbl_Linea_Vehiculo] — Id_Empresa + Id_Marca char(10) + Id_Linea char(10)
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class LineaVehiculo
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdMarca { get; set; } = "";     // parte de clave natural
    [MaxLength(10)] public string IdLinea { get; set; } = "";     // parte de clave natural

    // Navigation
    public Marca? Marca { get; set; }
}
