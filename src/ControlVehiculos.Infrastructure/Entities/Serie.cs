using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Serie
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(20)] public string Autorizacion { get; set; } = "";
    [MaxLength(5)]  public string SerieCodigo { get; set; } = "";
    [MaxLength(3)]  public string IdTipo { get; set; } = "";
    public int Del { get; set; }
    public int Al { get; set; }
    public int Actual { get; set; }
    public DateTime FechaIngreso { get; set; }
    [MaxLength(30)] public string Descripcion { get; set; } = "";
    public DateTime FechaHora { get; set; }
    public int Status { get; set; }
    public int? NumeroAnios { get; set; }
    public DateTime? FechaVencimiento { get; set; }
    public int PorcentajeConsumo { get; set; }
}
