using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class PresupuestoOrdenServicioDetalle
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdOrden { get; set; }
    public int Linea { get; set; }
    [MaxLength(15)] public string IdServicio { get; set; } = "";
    [MaxLength(100)] public string Descripcion { get; set; } = "";
    [MaxLength(4)]  public string IdEmpleado { get; set; } = "";
    [MaxLength(3)]  public string Fosa { get; set; } = "";
    public decimal Precio { get; set; }
    public decimal Otros { get; set; }
    public decimal TotalLinea { get; set; }
    public decimal Cantidad { get; set; }
    public decimal PrecioDescuento { get; set; }
    public decimal TotalLineaDescuento { get; set; }
    public decimal OtrosDescuento { get; set; }
    public decimal Costo { get; set; }
    public decimal ValorComision { get; set; }
    public decimal PorcentajeComision { get; set; }
    public int Autorizado { get; set; }
    public int? PresupuestoId { get; set; }         // FK surrogate → Tbl_Presupuesto_Orden_Servicio.Id
    public int? VendedorId { get; set; }            // FK → Tbl_Vendedores.Id (FASE 2)

    public PresupuestoOrdenServicio? Presupuesto { get; set; }
    public Vendedor? Vendedor { get; set; }
    public ICollection<PresupuestoOrdenServicioDetalleIntegracion> Insumos { get; set; } = new List<PresupuestoOrdenServicioDetalleIntegracion>();
}
