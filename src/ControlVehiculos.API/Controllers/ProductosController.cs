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
public class ProductosController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public ProductosController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    /// <summary>
    /// Lista productos/servicios.
    /// ?esServicio=1 → solo servicios | ?esServicio=0 → solo productos
    /// ?q=texto      → busca en IdProducto o Descripcion
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? esServicio, [FromQuery] string? q) =>
        Ok(await _db.Productos.AsNoTracking()
            .Where(p => esServicio == null || p.EsServicio == esServicio)
            .Where(p => q == null
                || p.IdProducto.Contains(q)
                || (p.Descripcion != null && p.Descripcion.Contains(q)))
            .OrderBy(p => p.IdProducto)
            .ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var p = await _db.Productos
            .Include(x => x.Comision)
            .Include(x => x.InsumosComoServicio)
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == id);
        return p is null ? NotFound() : Ok(p);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Producto producto)
    {
        producto.IdEmpresa  = _empresaCtx.IdEmpresa;
        producto.FechaAlta ??= DateTime.Now;
        producto.FechaHora  = DateTime.Now;
        _db.Productos.Add(producto);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = producto.Id }, producto);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Producto producto)
    {
        if (id != producto.Id) return BadRequest();
        producto.FechaHora = DateTime.Now;
        producto.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(producto).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var p = await _db.Productos.FindAsync(id);
        if (p is null) return NotFound();
        _db.Productos.Remove(p);
        await _db.SaveChangesAsync();
        return NoContent();
    }

    // GET /api/productos/{id}/comision
    [HttpGet("{id:int}/comision")]
    public async Task<IActionResult> GetComision(int id)
    {
        var c = await _db.ProductosComisiones.AsNoTracking()
                         .FirstOrDefaultAsync(x => x.Id == id);
        return c is null ? NotFound() : Ok(c);
    }

    // PUT /api/productos/{id}/comision — upsert comisión
    [HttpPut("{id:int}/comision")]
    public async Task<IActionResult> UpsertComision(int id, [FromBody] ProductoComision comision)
    {
        var producto = await _db.Productos.Include(p => p.Comision).FirstOrDefaultAsync(p => p.Id == id);
        if (producto is null) return NotFound();

        if (producto.Comision is null)
        {
            comision.IdProducto = producto.IdProducto;
            _db.ProductosComisiones.Add(comision);
        }
        else
        {
            producto.Comision.TipoComision        = comision.TipoComision;
            producto.Comision.ValorComision        = comision.ValorComision;
            producto.Comision.PorcentajeComision   = comision.PorcentajeComision;
        }

        await _db.SaveChangesAsync();
        return NoContent();
    }
}
