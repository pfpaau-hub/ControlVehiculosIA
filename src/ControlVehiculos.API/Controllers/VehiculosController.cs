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
public class VehiculosController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public VehiculosController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    // GET /api/vehiculos?nit=CF  — vehículos de un cliente
    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] string? nit)
    {
        var query = _db.Vehiculos.AsNoTracking();
        if (!string.IsNullOrEmpty(nit))
            query = query.Where(v => v.Nit == nit);
        return Ok(await query.OrderBy(v => v.NumPlaca).ToListAsync());
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var v = await _db.Vehiculos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return v is null ? NotFound() : Ok(v);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Vehiculo vehiculo)
    {
        vehiculo.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Vehiculos.Add(vehiculo);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = vehiculo.Id }, vehiculo);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Vehiculo vehiculo)
    {
        if (id != vehiculo.Id) return BadRequest();
        vehiculo.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(vehiculo).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var v = await _db.Vehiculos.FindAsync(id);
        if (v is null) return NotFound();
        _db.Vehiculos.Remove(v);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
