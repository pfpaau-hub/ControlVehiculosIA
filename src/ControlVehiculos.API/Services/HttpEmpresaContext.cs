using System.Security.Claims;
using ControlVehiculos.Application.Common;

namespace ControlVehiculos.API.Services;

public class HttpEmpresaContext : IEmpresaContext
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public HttpEmpresaContext(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public int IdEmpresa =>
        int.TryParse(_httpContextAccessor.HttpContext?.User.FindFirstValue("id_empresa"), out var id)
            ? id : 1;

    public string Periodo =>
        _httpContextAccessor.HttpContext?.User.FindFirstValue("periodo") ?? "";

    public int IdCaja =>
        int.TryParse(_httpContextAccessor.HttpContext?.User.FindFirstValue("id_caja"), out var caja)
            ? caja : 0;
}
