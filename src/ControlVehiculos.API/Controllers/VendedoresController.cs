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
public class VendedoresController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public VendedoresController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] string? status) =>
        Ok(await _db.Vendedores.AsNoTracking()
            .Where(v => status == null || v.Status == status)
            .OrderBy(v => v.Nombre)
            .ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var v = await _db.Vendedores.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return v is null ? NotFound() : Ok(v);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Vendedor vendedor)
    {
        vendedor.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Vendedores.Add(vendedor);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = vendedor.Id }, vendedor);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Vendedor vendedor)
    {
        if (id != vendedor.Id) return BadRequest();
        vendedor.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(vendedor).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var v = await _db.Vendedores.FindAsync(id);
        if (v is null) return NotFound();
        _db.Vendedores.Remove(v);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
