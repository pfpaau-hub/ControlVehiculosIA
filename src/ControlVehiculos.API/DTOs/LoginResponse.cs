namespace ControlVehiculos.API.DTOs;

public record LoginResponse(
    string Token,
    DateTime Expiry,
    string UserName,
    int IdEmpresa,
    string Periodo,
    int IdCaja
);
