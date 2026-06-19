// Tabla origen: [Tbl_Tipo_Vehiculos] — solo Id_Empresa + Tipo char(25), sin PK numérico
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class TipoVehiculo
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(25)] public string Tipo { get; set; } = "";        // clave natural
}
