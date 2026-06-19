using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ControlVehiculos.Application.Common;
using ControlVehiculos.Infrastructure.Data;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class LineasVehiculoController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public LineasVehiculoController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] string? idMarca) =>
        Ok(await _db.LineasVehiculo.AsNoTracking()
            .Where(l => idMarca == null || l.IdMarca == idMarca)
            .OrderBy(l => l.IdMarca).ThenBy(l => l.IdLinea)
            .ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var l = await _db.LineasVehiculo.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return l is null ? NotFound() : Ok(l);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] LineaVehiculo linea)
    {
        linea.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.LineasVehiculo.Add(linea);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = linea.Id }, linea);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] LineaVehiculo linea)
    {
        if (id != linea.Id) return BadRequest();
        linea.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(linea).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var l = await _db.LineasVehiculo.FindAsync(id);
        if (l is null) return NotFound();
        _db.LineasVehiculo.Remove(l);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
