// Tabla origen: [Tbl_Vendedores] — mecánicos y empleados/vendedores
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Vendedor
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdEmpleado { get; set; } = "";  // clave natural char(10)
    [MaxLength(80)] public string Nombre { get; set; } = "";
    public decimal PorcComision { get; set; }
    [MaxLength(1)]  public string Status { get; set; } = "";      // 'A'/'B' — ver enum StatusVendedor

    // Navigation
    public ICollection<OrdenServicioDetalle> LineasServicio { get; set; } = new List<OrdenServicioDetalle>();
    public ICollection<PresupuestoOrdenServicioDetalle> LineasPresupuesto { get; set; } = new List<PresupuestoOrdenServicioDetalle>();
}
