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
public class BancosController : ControllerBase
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public BancosController(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.Bancos.AsNoTracking().OrderBy(b => b.Nombre).ToListAsync());

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var b = await _db.Bancos.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        return b is null ? NotFound() : Ok(b);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Banco banco)
    {
        banco.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Bancos.Add(banco);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = banco.Id }, banco);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] Banco banco)
    {
        if (id != banco.Id) return BadRequest();
        banco.IdEmpresa = _empresaCtx.IdEmpresa;
        _db.Entry(banco).State = EntityState.Modified;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var b = await _db.Bancos.FindAsync(id);
        if (b is null) return NotFound();
        _db.Bancos.Remove(b);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
