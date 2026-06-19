using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Bodega
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdBodega { get; set; } = "";
    [MaxLength(60)] public string? Nombre { get; set; }

    public ICollection<OrdenServicioDetalleIntegracion> Insumos { get; set; } = new List<OrdenServicioDetalleIntegracion>();
    public ICollection<PresupuestoOrdenServicioDetalleIntegracion> InsumosPresupuesto { get; set; } = new List<PresupuestoOrdenServicioDetalleIntegracion>();
}
