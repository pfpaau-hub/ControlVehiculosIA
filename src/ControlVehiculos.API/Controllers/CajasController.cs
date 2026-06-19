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
public class CajasController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public CajasController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.Cajas.AsNoTracking().OrderBy(c => c.IdCaja).ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var c = await _db.Cajas.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return c is null ? NotFound() : Ok(c);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Caja caja)
    {
        caja.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Cajas.Add(caja);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = caja.Id }, caja);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Caja caja)
    {
        if (id != caja.Id) return BadRequest();
        caja.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(caja).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var c = await _db.Cajas.FindAsync(id);
        if (c is null) return NotFound();
        _db.Cajas.Remove(c);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
