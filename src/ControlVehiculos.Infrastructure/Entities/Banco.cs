using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Banco
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(2)]  public string IdBanco { get; set; } = "";
    [MaxLength(60)] public string Nombre { get; set; } = "";
}
