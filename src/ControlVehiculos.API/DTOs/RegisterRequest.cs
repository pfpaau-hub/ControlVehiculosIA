using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.API.DTOs;

public record RegisterRequest(
    [Required] string UserName,
    [Required][EmailAddress] string Email,
    [Required][MinLength(6)] string Password,
    [Required] int    IdEmpresa,
    [Required] string Periodo,
                int   IdCaja
);
