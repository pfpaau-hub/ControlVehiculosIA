using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ControlVehiculos.Application.Common;
using ControlVehiculos.Infrastructure.Data;
using ControlVehiculos.Infrastructure.Entities;
using ControlVehiculos.API.Services;

namespace ControlVehiculos.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class PresupuestosController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public PresupuestosController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? status) =>
        Ok(await _db.PresupuestosOrdenServicio.AsNoTracking()
            .Where(p => status == null || p.Status == status)
            .OrderByDescending(p => p.Fecha)
            .ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var p = await _db.PresupuestosOrdenServicio
            .Include(x => x.Detalles)
                .ThenInclude(d => d.Insumos)
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == id);
        return p is null ? NotFound() : Ok(p);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] PresupuestoOrdenServicio presupuesto)
    {
        presupuesto.IdEmpresa = _empresaCtx.IdEmpresa;
        presupuesto.Status    = 1;
        presupuesto.Fecha     = DateTime.Now;

        var empresa = await _db.Empresas.FirstOrDefaultAsync(e => e.IdEmpresa == _empresaCtx.IdEmpresa);
        if (empresa is not null)
        {
            presupuesto.IdOrden = empresa.SigNumeroPresupuesto;
            empresa.SigNumeroPresupuesto++;
        }

        _db.PresupuestosOrdenServicio.Add(presupuesto);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = presupuesto.Id }, presupuesto);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] PresupuestoOrdenServicio presupuesto)
    {
        if (id != presupuesto.Id) return BadRequest();
        _db.Entry(presupuesto).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var p = await _db.PresupuestosOrdenServicio.FindAsync(id);
        if (p is null) return NotFound();
        if (p.Status == 2) return BadRequest(new { error = "No se puede eliminar un presupuesto cerrado" });
        _db.PresupuestosOrdenServicio.Remove(p);
        await _db.SaveChangesAsync();
        return NoContent();
    }

    // POST /api/presupuestos/{id}/cerrar — status 1 → 2 (listo para convertir)
    [HttpPost("{id:int}/cerrar")]
    public async Task<IActionResult> Cerrar(int id)
    {
        var p = await _db.PresupuestosOrdenServicio.FindAsync(id);
        if (p is null) return NotFound();
        if (p.Status != 1) return BadRequest(new { error = "Solo se pueden cerrar presupuestos abiertos (status=1)" });

        p.Status = 2;
        await _db.SaveChangesAsync();
        return Ok(new { id = p.Id, status = p.Status });
    }

    // POST /api/presupuestos/{id}/convertir — equivale a sp_genera_orden_servicio
    [HttpPost("{id:int}/convertir")]
    public async Task<IActionResult> Convertir(int id, [FromServices] PresupuestoService svc)
    {
        // Verificar existencia antes de delegar al servicio (para retornar 404 correcto)
        var existe = await _db.PresupuestosOrdenServicio.AnyAsync(p => p.Id == id);
        if (!existe) return NotFound();

        try
        {
            var os = await svc.ConvertirAsync(id);
            return CreatedAtAction("GetById", "OrdenesServicio",
                new { id = os.Id },
                new { os.Id, os.IdOrden, mensaje = "Orden de servicio creada correctamente" });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { error = ex.Message });
        }
    }
}
