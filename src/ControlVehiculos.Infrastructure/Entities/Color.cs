// Tabla origen: [Tbl_colores] — Id_Empresa + Color char(10) + uno bit
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Color
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string ColorNombre { get; set; } = ""; // clave natural
    public bool? Uno { get; set; }
}
