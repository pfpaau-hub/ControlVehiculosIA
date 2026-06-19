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
public class ProveedoresController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public ProveedoresController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    // GET /api/proveedores?tipo=C  (C=cliente, P=proveedor, A=ambos, vacío=todos)
    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] string? tipo)
    {
        var query = _db.Proveedores.AsNoTracking();
        if (!string.IsNullOrEmpty(tipo))
            query = query.Where(p => p.Tipo == tipo || p.Tipo == "A");
        return Ok(await query.OrderBy(p => p.Nombre).ToListAsync());
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var p = await _db.Proveedores.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return p is null ? NotFound() : Ok(p);
    }

    // GET /api/proveedores/nit/{nit} — búsqueda rápida por NIT (para validación en OS)
    [HttpGet("nit/{nit}")]
    public async Task<IActionResult> GetByNit(string nit)
    {
        var p = await _db.Proveedores.AsNoTracking()
            .FirstOrDefaultAsync(x => x.Nit.Trim() == nit.Trim());
        return p is null ? NotFound() : Ok(new
        {
            p.Id, p.Nit, p.Nombre, p.FacturarA, p.Tarjeta, p.Tipo
        });
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Proveedor proveedor)
    {
        proveedor.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Proveedores.Add(proveedor);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = proveedor.Id }, proveedor);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Proveedor proveedor)
    {
        if (id != proveedor.Id) return BadRequest();
        proveedor.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(proveedor).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var p = await _db.Proveedores.FindAsync(id);
        if (p is null) return NotFound();
        _db.Proveedores.Remove(p);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
