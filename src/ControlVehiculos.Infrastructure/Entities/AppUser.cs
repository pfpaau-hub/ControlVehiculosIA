using Microsoft.AspNetCore.Identity;

namespace ControlVehiculos.Infrastructure.Entities;

public class AppUser : IdentityUser
{
    public int IdEmpresa { get; set; }
    public string Periodo { get; set; } = "";
    public int IdCaja { get; set; }
}
