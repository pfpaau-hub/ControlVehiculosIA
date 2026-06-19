using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ControlVehiculos.Application.Common;
using ControlVehiculos.Infrastructure.Data;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.API.Controllers;

[Authorize]
[ApiController]
[Route("api/ordenes-servicio")]
public class OrdenesServicioController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public OrdenesServicioController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? status) =>
        Ok(await _db.OrdenesServicio.AsNoTracking()
            .Where(o => status == null || o.Status == status)
            .OrderByDescending(o => o.Fecha)
            .ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var os = await _db.OrdenesServicio
            .Include(o => o.Detalles)
                .ThenInclude(d => d.Insumos)
            .AsNoTracking()
            .FirstOrDefaultAsync(o => o.Id == id);
        return os is null ? NotFound() : Ok(os);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] OrdenServicio orden)
    {
        // NIT debe existir en el catálogo de clientes (Tbl_Proveedores)
        if (!string.IsNullOrWhiteSpace(orden.Nit))
        {
            var nitExiste = await _db.Proveedores
                .AnyAsync(p => p.Nit.Trim() == orden.Nit.Trim());
            if (!nitExiste)
                return BadRequest(new { error = $"El NIT '{orden.Nit}' no existe en el catálogo de clientes. Regístrelo primero en la sección Clientes." });
        }

        // IdEmpresa siempre del contexto — no confiar en el cuerpo del request
        orden.IdEmpresa = _empresaCtx.IdEmpresa;
        orden.Status    = 1;
        orden.Fecha     = DateTime.Now;

        // Asignar número de OS desde el contador de la empresa
        var empresa = await _db.Empresas.FirstOrDefaultAsync(e => e.IdEmpresa == _empresaCtx.IdEmpresa);
        if (empresa is not null)
        {
            orden.IdOrden = empresa.SigOrdenServicio ?? 1;
            empresa.SigOrdenServicio = orden.IdOrden + 1;
        }

        _db.OrdenesServicio.Add(orden);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = orden.Id }, orden);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] OrdenServicio orden)
    {
        if (id != orden.Id) return BadRequest();
        _db.Entry(orden).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    // POST /api/ordenes-servicio/{id}/cerrar — status 1 → 2
    [HttpPost("{id:int}/cerrar")]
    public async Task<IActionResult> Cerrar(int id)
    {
        var os = await _db.OrdenesServicio.FindAsync(id);
        if (os is null) return NotFound();
        if (os.Status != 1) return BadRequest(new { error = "Solo se pueden cerrar órdenes abiertas (status=1)" });

        os.Status      = 2;
        os.FechaCierre = DateTime.Now;
        await _db.SaveChangesAsync();
        return Ok(new { id = os.Id, status = os.Status, fechaCierre = os.FechaCierre });
    }

    // POST /api/ordenes-servicio/{id}/reabrir — status 2 → 1
    [HttpPost("{id:int}/reabrir")]
    public async Task<IActionResult> Reabrir(int id)
    {
        var os = await _db.OrdenesServicio.FindAsync(id);
        if (os is null) return NotFound();
        if (os.Status != 2) return BadRequest(new { error = "Solo se pueden reabrir órdenes cerradas (status=2)" });
        if (os.Numero != 0) return BadRequest(new { error = "No se puede reabrir: la orden ya fue facturada" });
        if (os.FechaFacturacion.HasValue) return BadRequest(new { error = "No se puede reabrir: tiene fecha de facturación" });

        os.Status      = 1;
        os.FechaCierre = null;
        await _db.SaveChangesAsync();
        return Ok(new { id = os.Id, status = os.Status });
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var os = await _db.OrdenesServicio.FindAsync(id);
        if (os is null) return NotFound();
        if (os.Status == 2) return BadRequest(new { error = "No se puede eliminar una orden cerrada" });
        _db.OrdenesServicio.Remove(os);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
