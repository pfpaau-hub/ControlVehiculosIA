using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using ControlVehiculos.API.DTOs;
using ControlVehiculos.API.Services;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly UserManager<AppUser>  _users;
    private readonly SignInManager<AppUser> _signIn;
    private readonly TokenService          _tokens;

    public AuthController(
        UserManager<AppUser> users,
        SignInManager<AppUser> signIn,
        TokenService tokens)
    {
        _users  = users;
        _signIn = signIn;
        _tokens = tokens;
    }

    /// <summary>Autentica usuario y devuelve JWT.</summary>
    [AllowAnonymous]
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest req)
    {
        var user = await _users.FindByNameAsync(req.UserName);
        if (user is null)
            return Unauthorized(new { error = "Credenciales inválidas" });

        var result = await _signIn.CheckPasswordSignInAsync(user, req.Password, lockoutOnFailure: true);
        if (!result.Succeeded)
        {
            if (result.IsLockedOut)
                return StatusCode(423, new { error = "Cuenta bloqueada temporalmente" });
            return Unauthorized(new { error = "Credenciales inválidas" });
        }

        var (token, expiry) = _tokens.GenerateToken(user);
        return Ok(new LoginResponse(token, expiry, user.UserName!, user.IdEmpresa, user.Periodo, user.IdCaja));
    }

    /// <summary>Devuelve info del usuario autenticado (claims del JWT).</summary>
    [Authorize]
    [HttpGet("me")]
    public async Task<IActionResult> Me()
    {
        var user = await _users.FindByNameAsync(User.Identity!.Name!);
        if (user is null) return Unauthorized();
        return Ok(new
        {
            user.Id,
            user.UserName,
            user.Email,
            user.IdEmpresa,
            user.Periodo,
            user.IdCaja
        });
    }

    /// <summary>Registra un nuevo usuario (solo para setup inicial / admin).</summary>
    [AllowAnonymous]
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest req)
    {
        var user = new AppUser
        {
            UserName   = req.UserName,
            Email      = req.Email,
            IdEmpresa  = req.IdEmpresa,
            Periodo    = req.Periodo,
            IdCaja     = req.IdCaja
        };

        var result = await _users.CreateAsync(user, req.Password);
        if (!result.Succeeded)
            return BadRequest(new { errors = result.Errors.Select(e => e.Description) });

        return CreatedAtAction(nameof(Me), new { userName = user.UserName }, new { user.Id, user.UserName });
    }
}
