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
public class CasasCreditoController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public CasasCreditoController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.CasasCredito.AsNoTracking().OrderBy(c => c.Nombre).ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var c = await _db.CasasCredito.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return c is null ? NotFound() : Ok(c);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CasaCredito casa)
    {
        casa.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.CasasCredito.Add(casa);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = casa.Id }, casa);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] CasaCredito casa)
    {
        if (id != casa.Id) return BadRequest();
        casa.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(casa).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var c = await _db.CasasCredito.FindAsync(id);
        if (c is null) return NotFound();
        _db.CasasCredito.Remove(c);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
