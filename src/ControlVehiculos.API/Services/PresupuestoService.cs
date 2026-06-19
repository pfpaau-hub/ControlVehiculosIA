using Microsoft.EntityFrameworkCore;
using ControlVehiculos.Application.Common;
using ControlVehiculos.Infrastructure.Data;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.API.Services;

/// <summary>
/// Equivalente a sp_genera_orden_servicio + lógica del formulario frm_genera_orden_servicio.
/// </summary>
public class PresupuestoService
{
    private readonly AppDbContext    _db;
    private readonly IEmpresaContext _empresaCtx;

    public PresupuestoService(AppDbContext db, IEmpresaContext empresaCtx)
    {
        _db         = db;
        _empresaCtx = empresaCtx;
    }

    /// <summary>
    /// Convierte un presupuesto cerrado (status=2) en una Orden de Servicio.
    /// Solo copia líneas y insumos con autorizado=1.
    /// </summary>
    public async Task<OrdenServicio> ConvertirAsync(int presupuestoId)
    {
        // ── 1. Cargar cabecera del presupuesto ─────────────────────────
        var presupuesto = await _db.PresupuestosOrdenServicio
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.Id == presupuestoId)
            ?? throw new InvalidOperationException("Presupuesto no encontrado.");

        if (presupuesto.Status != 2)
            throw new InvalidOperationException(
                "El presupuesto debe estar cerrado (status=2) antes de convertirse en Orden de Servicio.");

        // ── 2. Cargar detalles e insumos autorizados (equivale a los dos cursores del SP) ─
        var detalles = await _db.PresupuestosOrdenServicioDetalle
            .AsNoTracking()
            .Where(d => d.IdOrden == presupuesto.IdOrden && d.Autorizado == 1)
            .OrderBy(d => d.Linea)
            .ToListAsync();

        var insumos = await _db.PresupuestosOrdenServicioDetalleIntegracion
            .AsNoTracking()
            .Where(i => i.IdOrden == presupuesto.IdOrden && i.Autorizado == 1)
            .OrderBy(i => i.Linea).ThenBy(i => i.LineaDet)
            .ToListAsync();

        // ── 3. Obtener y reservar próximo número de OS ─────────────────
        // (el formulario VFP leía empresas.sig_orden_servicio antes de llamar al SP)
        var empresa = await _db.Empresas
            .FirstOrDefaultAsync(e => e.IdEmpresa == _empresaCtx.IdEmpresa)
            ?? throw new InvalidOperationException("Empresa no encontrada.");

        int idOrden = empresa.SigOrdenServicio ?? 1;

        // Verificar que no exista ya una OS con ese número
        bool existe = await _db.OrdenesServicio
            .AnyAsync(os => os.IdOrden == idOrden);
        if (existe)
            throw new InvalidOperationException(
                $"Ya existe una Orden de Servicio con número {idOrden}. " +
                $"Actualice sig_orden_servicio en la empresa.");

        // ── 4. Construir el grafo de objetos ───────────────────────────
        // Cabecera OS — valores fijos idénticos al SP original
        var orden = new OrdenServicio
        {
            IdEmpresa        = presupuesto.IdEmpresa,
            IdOrden          = idOrden,
            NumPlaca         = presupuesto.NumPlaca,
            FacturarA        = presupuesto.FacturarA,
            Observaciones    = presupuesto.Observaciones,
            RecibeOrden      = presupuesto.RecibeOrden,
            Encargado        = presupuesto.Encargado,
            Tarjeta          = presupuesto.Tarjeta,
            Fecha            = presupuesto.Fecha,
            Status           = 1,
            Nit              = presupuesto.Nit,
            LecturaActual    = presupuesto.LecturaActual,
            ProximoServicio  = presupuesto.ProximoServicio,
            FechaCierre      = null,
            FechaFacturacion = null,
            Numero           = 0,
            Autorizacion     = "",
            Serie            = "",
            Tipo             = "",
            Anticipo         = 0,
            ProveedorId      = presupuesto.ProveedorId,
            VehiculoId       = presupuesto.VehiculoId,
        };

        // Detalles (cursor servicios) — mantener el Linea original del presupuesto
        var osDetalleByLinea = new Dictionary<int, OrdenServicioDetalle>();
        foreach (var d in detalles)
        {
            var osDetalle = new OrdenServicioDetalle
            {
                IdEmpresa           = presupuesto.IdEmpresa,
                IdOrden             = idOrden,
                Linea               = d.Linea,
                IdServicio          = d.IdServicio,
                Descripcion         = d.Descripcion,
                IdEmpleado          = d.IdEmpleado,
                Fosa                = d.Fosa,
                Precio              = d.Precio,
                Otros               = d.Otros,
                TotalLinea          = d.TotalLinea,
                Cantidad            = d.Cantidad,
                PrecioDescuento     = d.PrecioDescuento,
                TotalLineaDescuento = d.TotalLineaDescuento,
                OtrosDescuento      = d.OtrosDescuento,
                Costo               = d.Costo,
                ValorComision       = d.ValorComision,
                PorcentajeComision  = d.PorcentajeComision,
                VendedorId          = d.VendedorId,
            };
            orden.Detalles.Add(osDetalle);
            osDetalleByLinea[d.Linea] = osDetalle;
        }

        // Insumos (cursor insumos) — agrega getdate() igual que el SP
        foreach (var ins in insumos)
        {
            var insumoOS = new OrdenServicioDetalleIntegracion
            {
                IdEmpresa           = presupuesto.IdEmpresa,
                IdOrden             = idOrden,
                Linea               = ins.Linea,
                LineaDet            = ins.LineaDet,
                IdProducto          = ins.IdProducto,
                Descripcion         = ins.Descripcion,
                Cantidad            = ins.Cantidad,
                Precio              = ins.Precio,
                IdBodega            = ins.IdBodega,
                SeCobra             = ins.SeCobra,
                TotalLinea          = ins.TotalLinea,
                PrecioDescuento     = ins.PrecioDescuento,
                TotalLineaDescuento = ins.TotalLineaDescuento,
                RebajaExistencias   = ins.RebajaExistencias,
                Costo               = ins.Costo,
                Periodo             = ins.Periodo,
                FechaHora           = DateTime.Now,    // equivale a getdate() del SP
                BodegaId            = ins.BodegaId,
            };

            // Asociar al detalle padre para que EF resuelva OrdenDetalleId
            if (osDetalleByLinea.TryGetValue(ins.Linea, out var parentDetalle))
                parentDetalle.Insumos.Add(insumoOS);
            else
                orden.Integraciones.Add(insumoOS);  // huérfano — raro pero seguro
        }

        // ── 5. Transacción: grabar todo + incrementar contador ─────────
        using var tx = await _db.Database.BeginTransactionAsync();
        try
        {
            _db.OrdenesServicio.Add(orden);
            empresa.SigOrdenServicio = idOrden + 1;
            await _db.SaveChangesAsync();
            await tx.CommitAsync();
        }
        catch
        {
            await tx.RollbackAsync();
            throw;
        }

        return orden;
    }
}
