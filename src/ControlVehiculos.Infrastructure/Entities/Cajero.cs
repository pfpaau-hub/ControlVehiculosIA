using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Cajero
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdCajero { get; set; } = "";
    [MaxLength(50)] public string? Nombre { get; set; }
}
