using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class PresupuestoOrdenServicioDetalleIntegracion
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdOrden { get; set; }
    public int Linea { get; set; }
    public int LineaDet { get; set; }
    [MaxLength(15)] public string IdProducto { get; set; } = "";
    [MaxLength(100)] public string Descripcion { get; set; } = "";
    public decimal Cantidad { get; set; }
    public decimal Precio { get; set; }
    [MaxLength(10)] public string IdBodega { get; set; } = "";
    [MaxLength(1)]  public string SeCobra { get; set; } = "";
    public decimal TotalLinea { get; set; }
    public decimal PrecioDescuento { get; set; }
    public decimal TotalLineaDescuento { get; set; }
    public int RebajaExistencias { get; set; }
    public decimal Costo { get; set; }
    [MaxLength(7)]  public string Periodo { get; set; } = "";
    public DateTime FechaHora { get; set; }
    public int Autorizado { get; set; }
    public int? PresupuestoDetalleId { get; set; }  // FK surrogate → tbl_presupuesto_os_detalle.Id
    public int? PresupuestoId { get; set; }          // FK shortcut → Tbl_Presupuesto_Orden_Servicio.Id (FASE 2)
    public int? BodegaId { get; set; }               // FK → Tbl_Bodegas.Id (FASE 2)

    public PresupuestoOrdenServicio? Presupuesto { get; set; }
    public PresupuestoOrdenServicioDetalle? DetalleServicio { get; set; }
    public Bodega? Bodega { get; set; }
}
