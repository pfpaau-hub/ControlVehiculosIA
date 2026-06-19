using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.API.DTOs;

public record LoginRequest(
    [Required] string UserName,
    [Required] string Password
);
