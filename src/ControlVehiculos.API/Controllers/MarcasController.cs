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
public class MarcasController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public MarcasController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.Marcas.AsNoTracking()
            .Include(m => m.Lineas)
            .OrderBy(m => m.IdMarca)
            .ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var m = await _db.Marcas.Include(x => x.Lineas).AsNoTracking()
                         .FirstOrDefaultAsync(x => x.Id == id);
        return m is null ? NotFound() : Ok(m);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Marca marca)
    {
        marca.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Marcas.Add(marca);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = marca.Id }, marca);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Marca marca)
    {
        if (id != marca.Id) return BadRequest();
        marca.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(marca).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var m = await _db.Marcas.FindAsync(id);
        if (m is null) return NotFound();
        _db.Marcas.Remove(m);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
