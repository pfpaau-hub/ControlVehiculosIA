// Tabla origen: [Tbl_Marcas] — solo Id_Empresa + Id_Marca char(10), sin nombre
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Marca
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdMarca { get; set; } = "";     // clave natural

    // Navigation
    public ICollection<LineaVehiculo> Lineas { get; set; } = new List<LineaVehiculo>();
}
