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
public class BodegasController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public BodegasController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.Bodegas.AsNoTracking().OrderBy(b => b.IdBodega).ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var b = await _db.Bodegas.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return b is null ? NotFound() : Ok(b);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Bodega bodega)
    {
        bodega.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Bodegas.Add(bodega);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = bodega.Id }, bodega);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Bodega bodega)
    {
        if (id != bodega.Id) return BadRequest();
        bodega.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(bodega).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var b = await _db.Bodegas.FindAsync(id);
        if (b is null) return NotFound();
        _db.Bodegas.Remove(b);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
