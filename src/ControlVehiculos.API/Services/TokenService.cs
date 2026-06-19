using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.API.Services;

public class TokenService
{
    private readonly IConfiguration _config;

    public TokenService(IConfiguration config) => _config = config;

    public (string token, DateTime expiry) GenerateToken(AppUser user)
    {
        var key     = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!));
        var creds   = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var expiry  = DateTime.UtcNow.AddMinutes(
            double.TryParse(_config["Jwt:ExpiryMinutes"], out var m) ? m : 480);

        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub,  user.Id),
            new Claim(JwtRegisteredClaimNames.Jti,  Guid.NewGuid().ToString()),
            new Claim(ClaimTypes.Name,               user.UserName ?? ""),
            new Claim("id_empresa",                  user.IdEmpresa.ToString()),
            new Claim("periodo",                     user.Periodo),
            new Claim("id_caja",                     user.IdCaja.ToString()),
        };

        var token = new JwtSecurityToken(
            issuer:             _config["Jwt:Issuer"],
            audience:           _config["Jwt:Audience"],
            claims:             claims,
            expires:            expiry,
            signingCredentials: creds);

        return (new JwtSecurityTokenHandler().WriteToken(token), expiry);
    }
}
