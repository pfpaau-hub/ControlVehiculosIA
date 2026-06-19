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
public class TiposVehiculoController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public TiposVehiculoController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.TiposVehiculo.AsNoTracking().OrderBy(t => t.Tipo).ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var t = await _db.TiposVehiculo.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return t is null ? NotFound() : Ok(t);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] TipoVehiculo tipo)
    {
        tipo.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.TiposVehiculo.Add(tipo);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = tipo.Id }, tipo);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] TipoVehiculo tipo)
    {
        if (id != tipo.Id) return BadRequest();
        tipo.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(tipo).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var t = await _db.TiposVehiculo.FindAsync(id);
        if (t is null) return NotFound();
        _db.TiposVehiculo.Remove(t);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
