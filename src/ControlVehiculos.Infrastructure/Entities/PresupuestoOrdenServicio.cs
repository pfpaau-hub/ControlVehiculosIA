using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class PresupuestoOrdenServicio
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdOrden { get; set; }
    [MaxLength(10)] public string NumPlaca { get; set; } = "";
    [MaxLength(100)] public string FacturarA { get; set; } = "";
    [MaxLength(200)] public string Observaciones { get; set; } = "";
    [MaxLength(4)]  public string RecibeOrden { get; set; } = "";
    [MaxLength(4)]  public string Encargado { get; set; } = "";
    [MaxLength(20)] public string Tarjeta { get; set; } = "";
    public DateTime Fecha { get; set; }
    public int Status { get; set; }
    [MaxLength(20)] public string Nit { get; set; } = "";
    public int LecturaActual { get; set; }
    public int ProximoServicio { get; set; }
    public DateTime? FechaCierre { get; set; }
    public DateTime? FechaFacturacion { get; set; }
    public decimal Anticipo { get; set; }
    [MaxLength(20)] public string Autorizacion { get; set; } = "";
    [MaxLength(5)]  public string Serie { get; set; } = "";
    [MaxLength(3)]  public string Tipo { get; set; } = "";
    public decimal Numero { get; set; }

    public int? ProveedorId { get; set; }    // FK → Tbl_Proveedores.Id (FASE 2)
    public int? VehiculoId { get; set; }     // FK → Tbl_Vehiculos.Id (FASE 2)

    public Proveedor? Proveedor { get; set; }
    public Vehiculo?  Vehiculo  { get; set; }
    public ICollection<PresupuestoOrdenServicioDetalle> Detalles { get; set; } = new List<PresupuestoOrdenServicioDetalle>();
    public ICollection<PresupuestoOrdenServicioDetalleIntegracion> Integraciones { get; set; } = new List<PresupuestoOrdenServicioDetalleIntegracion>();
}
