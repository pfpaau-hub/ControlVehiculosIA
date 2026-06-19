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
public class SeriesController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public SeriesController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? status) =>
        Ok(await _db.Series.AsNoTracking()
            .Where(s => status == null || s.Status == status)
            .OrderBy(s => s.SerieCodigo)
            .ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var s = await _db.Series.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return s is null ? NotFound() : Ok(s);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Serie serie)
    {
        serie.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Series.Add(serie);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = serie.Id }, serie);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Serie serie)
    {
        if (id != serie.Id) return BadRequest();
        serie.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(serie).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var s = await _db.Series.FindAsync(id);
        if (s is null) return NotFound();
        _db.Series.Remove(s);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
