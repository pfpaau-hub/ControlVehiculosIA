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
public class CajerosController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public CajerosController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.Cajeros.AsNoTracking().OrderBy(c => c.IdCajero).ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var c = await _db.Cajeros.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return c is null ? NotFound() : Ok(c);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Cajero cajero)
    {
        cajero.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Cajeros.Add(cajero);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = cajero.Id }, cajero);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Cajero cajero)
    {
        if (id != cajero.Id) return BadRequest();
        cajero.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(cajero).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var c = await _db.Cajeros.FindAsync(id);
        if (c is null) return NotFound();
        _db.Cajeros.Remove(c);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
