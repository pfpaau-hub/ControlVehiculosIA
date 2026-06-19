using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class OrdenServicioDetalleIntegracion
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
    public DateTime? FechaHora { get; set; }
    public int? OrdenDetalleId { get; set; }         // FK surrogate → Tbl_Orden_Servicio_Detalle.Id
    public int? OrdenServicioId { get; set; }        // FK shortcut → Tbl_Orden_Servicio.Id (FASE 2)
    public int? BodegaId { get; set; }               // FK → Tbl_Bodegas.Id (FASE 2)

    public OrdenServicio? OrdenServicio { get; set; }
    public OrdenServicioDetalle? DetalleServicio { get; set; }
    public Bodega? Bodega { get; set; }
}
