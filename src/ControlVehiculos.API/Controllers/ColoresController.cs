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
public class ColoresController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public ColoresController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.Colores.AsNoTracking().OrderBy(c => c.ColorNombre).ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var c = await _db.Colores.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return c is null ? NotFound() : Ok(c);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Color color)
    {
        color.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Colores.Add(color);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = color.Id }, color);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Color color)
    {
        if (id != color.Id) return BadRequest();
        color.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(color).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var c = await _db.Colores.FindAsync(id);
        if (c is null) return NotFound();
        _db.Colores.Remove(c);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
