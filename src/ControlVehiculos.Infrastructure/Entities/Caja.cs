using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Caja
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdCaja { get; set; }
    [MaxLength(50)] public string Observaciones { get; set; } = "";
}
