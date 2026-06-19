namespace ControlVehiculos.Application.Common;

public interface IEmpresaContext
{
    int IdEmpresa { get; }
    string Periodo { get; }
    int IdCaja { get; }
}
