// Tabla origen: [Tbl_Vehiculos]
// NOTA: Marca/Linea/Color/Tipo son texto libre — NO FKs a catálogos
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Vehiculo
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string NumPlaca { get; set; } = "";    // clave natural
    [MaxLength(15)] public string Color { get; set; } = "";
    [MaxLength(25)] public string Tipo { get; set; } = "";
    [MaxLength(25)] public string Marca { get; set; } = "";
    [MaxLength(25)] public string Linea { get; set; } = "";
    [MaxLength(4)]  public string Modelo { get; set; } = "";
    [MaxLength(1)]  public string Puertas { get; set; } = "";
    [MaxLength(10)] public string Cilindros { get; set; } = "";
    [MaxLength(15)] public string Motor { get; set; } = "";
    [MaxLength(10)] public string UnidadMedida { get; set; } = "";
    public int PresionLlantas { get; set; }
    [MaxLength(10)] public string Combustible { get; set; } = "";
    public int ServicioCada { get; set; }
    [MaxLength(20)] public string Nit { get; set; } = "";         // FK implícita a Tbl_Proveedores
    public DateTime FechaUltMov { get; set; }

    // Navigation
    public ICollection<OrdenServicio> OrdenesServicio { get; set; } = new List<OrdenServicio>();
    public ICollection<PresupuestoOrdenServicio> Presupuestos { get; set; } = new List<PresupuestoOrdenServicio>();
}
