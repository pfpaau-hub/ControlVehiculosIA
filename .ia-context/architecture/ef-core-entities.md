# EF Core — Entidades de Dominio

> **Generado 2026-06-18** — Basado en DDL real extraído de `db_inventario_pfp`.
> Fuente: `extracted/inventario/ddl-completo.sql`
> Estrategia: surrogate PK `int Id` + Global Query Filter por `IdEmpresa`.

---

## Estructura de carpetas

```
src/
└── ControlVehiculos.Infrastructure/
    ├── Data/
    │   ├── AppDbContext.cs
    │   └── IEmpresaContext.cs
    ├── Entities/
    │   ├── Enums/
    │   │   └── Enums.cs
    │   ├── Empresa.cs
    │   ├── Proveedor.cs
    │   ├── Vehiculo.cs
    │   ├── Marca.cs
    │   ├── LineaVehiculo.cs
    │   ├── TipoVehiculo.cs
    │   ├── Color.cs
    │   ├── Vendedor.cs
    │   ├── Bodega.cs
    │   ├── Producto.cs
    │   ├── ProductoComision.cs
    │   ├── Caja.cs
    │   ├── Cajero.cs
    │   ├── Serie.cs
    │   ├── Banco.cs
    │   ├── CasaCredito.cs
    │   ├── PresupuestoOrdenServicio.cs
    │   ├── PresupuestoOrdenServicioDetalle.cs
    │   ├── PresupuestoOrdenServicioDetalleIntegracion.cs
    │   ├── OrdenServicio.cs
    │   ├── OrdenServicioDetalle.cs
    │   ├── OrdenServicioDetalleIntegracion.cs
    │   └── InsumoServicio.cs
    └── Configurations/
        ├── EmpresaConfiguration.cs
        ├── ProveedorConfiguration.cs
        ├── VehiculoConfiguration.cs
        ├── MarcaConfiguration.cs
        ├── LineaVehiculoConfiguration.cs
        ├── TipoVehiculoConfiguration.cs
        ├── ColorConfiguration.cs
        ├── VendedorConfiguration.cs
        ├── BodegaConfiguration.cs
        ├── ProductoConfiguration.cs
        ├── ProductoComisionConfiguration.cs
        ├── CajaConfiguration.cs
        ├── CajeroConfiguration.cs
        ├── SerieConfiguration.cs
        ├── BancoConfiguration.cs
        ├── CasaCreditoConfiguration.cs
        ├── PresupuestoOrdenServicioConfiguration.cs
        ├── PresupuestoOrdenServicioDetalleConfiguration.cs
        ├── PresupuestoOrdenServicioDetalleIntegracionConfiguration.cs
        ├── OrdenServicioConfiguration.cs
        ├── OrdenServicioDetalleConfiguration.cs
        ├── OrdenServicioDetalleIntegracionConfiguration.cs
        └── InsumoServicioConfiguration.cs
```

---

## 1. Enums

```csharp
// Entities/Enums/Enums.cs
namespace ControlVehiculos.Infrastructure.Entities.Enums;

/// <summary>
/// Tipo de tercero en Tbl_Proveedores.Tipo ('C'=Cliente, 'P'=Proveedor, 'A'=Ambos)
/// </summary>
public enum TipoTercero
{
    Cliente = 'C',
    Proveedor = 'P',
    Ambos = 'A'
}

/// <summary>
/// Tbl_Orden_Servicio.Status / Tbl_Presupuesto_Orden_Servicio.Status
/// </summary>
public enum StatusOrden
{
    Abierta = 1,
    Cerrada = 2
}

/// <summary>
/// Tbl_presupuesto_servicio.status (presupuesto legacy)
/// </summary>
public enum StatusPresupuesto
{
    Abierto = 1,
    Cerrado = 2
}

/// <summary>
/// Tbl_Orden_Servicio_Detalle_Integracion.Se_Cobra ('S'/'N')
/// </summary>
public enum SeCobraInsumo
{
    Si = 'S',
    No = 'N'
}

/// <summary>
/// tbl_productos_comisiones.Tipo_comision
/// </summary>
public enum TipoComision
{
    ValorFijo = 1,
    Porcentaje = 2
}

/// <summary>
/// Tbl_Vendedores.status ('A'=Activo, 'B'=Baja)
/// </summary>
public enum StatusVendedor
{
    Activo = 'A',
    Baja = 'B'
}
```

---

## 2. Entidades de dominio

### Empresa

```csharp
// Entities/Empresa.cs
// Tabla origen: [empresas] — 42 campos reales
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Empresa
{
    public int Id { get; set; }                          // surrogate PK
    public int IdEmpresa { get; set; }                   // clave natural original

    [MaxLength(100)] public string? NombreEmpresa { get; set; }
    public int? PorcentajeIvaAnterior { get; set; }
    public int? PorcentajeIva { get; set; }
    [MaxLength(7)]  public string? Periodo { get; set; }
    public int? LmodificaPrecios { get; set; }
    public int? SigOrdenServicio { get; set; }
    public decimal? PorcentajeUtilidad { get; set; }
    public DateTime? Apartirde { get; set; }
    [MaxLength(10)] public string IdBodegaFacturacion { get; set; } = "";
    [MaxLength(10)] public string IdCuentaCxp { get; set; } = "";
    public int LmodificaCostos { get; set; }
    public int TotalDetalleLineas { get; set; }
    [MaxLength(10)] public string IdCuentaEfectivo { get; set; } = "";
    [MaxLength(10)] public string IdCuentaBanco { get; set; } = "";
    [MaxLength(10)] public string IdCuentaCredito { get; set; } = "";
    [MaxLength(10)] public string IdCuentaAnticipo { get; set; } = "";
    [MaxLength(10)] public string IdCuentaDebito { get; set; } = "";
    [MaxLength(10)] public string IdCuentaDebitoFiscal { get; set; } = "";
    [MaxLength(200)] public string Direccion { get; set; } = "";
    [MaxLength(50)] public string Telefonos { get; set; } = "";
    [MaxLength(20)] public string Fax { get; set; } = "";
    [MaxLength(50)] public string Email { get; set; } = "";
    [MaxLength(15)] public string? Nit { get; set; }
    public int IdContrasena { get; set; }
    [MaxLength(10)] public string IdCuentaAnticipoProveedores { get; set; } = "";
    [MaxLength(10)] public string IdCuentaCxc { get; set; } = "";
    [MaxLength(10)] public string IdCuentaVtas { get; set; } = "";
    [MaxLength(3)]  public string IdDeptoVtas { get; set; } = "";
    [MaxLength(10)] public string IdCuentaDepTransitoCxc { get; set; } = "";
    public int SigNumeroPresupuesto { get; set; }
    public int? PorcentajeUtilidadSobre { get; set; }
    [MaxLength(10)] public string FacturaCon { get; set; } = "";
    [MaxLength(100)] public string? NombreComercial { get; set; }
    [MaxLength(10)] public string? IdCuentaRebajaSventa { get; set; }
    public int UsaOrdenDespacho { get; set; }
    [MaxLength(10)] public string? OperaConMoneda { get; set; }
    public decimal? TasaCambio { get; set; }
    public int? IngresaFechaAlFacturar { get; set; }
    public int? FacturacionMultibodega { get; set; }
    [MaxLength(10)] public string? IdCuentaRetencionIvaClientes { get; set; }
    public int? FacturaEnBaseAplantillas { get; set; }
    public int? UtilizaCorrelativoContrasenaspago { get; set; }
    [MaxLength(80)] public string? DirectorioLogo { get; set; }
    public int? PermiteExistenciaNegativa { get; set; }
    [MaxLength(15)] public string? IdPropina { get; set; }
    public int? TipoOrdenAActualizar { get; set; }
    public int? OrdenEnvioPosFActura { get; set; }
    [MaxLength(10)] public string? MascaraCantidad { get; set; }
    public int? AgenteRetenedorIva { get; set; }
    [MaxLength(15)] public string? RegimenFiscalIsr { get; set; }
    [MaxLength(10)] public string? IdCuentaRetencionIsrClientes { get; set; }
    public int? TipoColaOrdenes { get; set; }
    public int? TipoCorrelOrden { get; set; }
    public bool ImprimeCopia { get; set; }
    [MaxLength(15)] public string? NumeroOrdenCompra { get; set; }
    public int CorrelativoComanda { get; set; }
    public DateTime? FechaSistema { get; set; }
    [MaxLength(100)] public string? FormatoOcompra { get; set; }
}
```

### Proveedor (= Tbl_Proveedores — clientes y proveedores)

```csharp
// Entities/Proveedor.cs
// Tabla origen: [Tbl_Proveedores]
// NOTA: esta tabla sirve para clientes Y proveedores. Tipo char(1): 'C','P','A'
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Proveedor
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(20)] public string Nit { get; set; } = "";         // clave natural
    [MaxLength(100)] public string Nombre { get; set; } = "";
    public int CreditoOContado { get; set; }
    public int DiasCredito { get; set; }
    [MaxLength(80)] public string Contacto { get; set; } = "";
    [MaxLength(80)] public string CorreoElectro { get; set; } = "";
    [MaxLength(100)] public string Direccion { get; set; } = "";
    [MaxLength(50)] public string Colonia { get; set; } = "";
    [MaxLength(10)] public string Apto { get; set; } = "";
    [MaxLength(2)]  public string Zona { get; set; } = "";
    [MaxLength(50)] public string Ciudad { get; set; } = "";
    [MaxLength(30)] public string Telefono { get; set; } = "";
    [MaxLength(20)] public string Tarjeta { get; set; } = "";
    [MaxLength(5)]  public string NumCasa { get; set; } = "";
    [MaxLength(40)] public string Municipio { get; set; } = "";
    [MaxLength(30)] public string Telefono1 { get; set; } = "";
    [MaxLength(1)]  public string Tipo { get; set; } = "";        // 'C'/'P'/'A'
    [MaxLength(10)] public string LocalExtranjero { get; set; } = "";
    public DateTime? FechaUltMov { get; set; }
    [MaxLength(2)]  public string RetieneIsr { get; set; } = "";
    [MaxLength(100)] public string FacturarA { get; set; } = "";
    [MaxLength(1)]  public string TipoPrecio { get; set; } = "";
    public int PorcentajeDescuento { get; set; }
    [MaxLength(20)] public string Identificacion { get; set; } = "";
    public DateTime FechaUltMovProv { get; set; }
    [MaxLength(2)]  public string IdConceptoServicio { get; set; } = "";
    public int TipoIva { get; set; }
    [MaxLength(10)] public string IdCuentaCxp { get; set; } = "";
    [MaxLength(10)] public string Clasificacion { get; set; } = "";
    public int PagaIva { get; set; }
    public decimal LimiteCreditoCliente { get; set; }
    public int? EsAgenteRetenedorIva { get; set; }
    public int? TieneExencionIva { get; set; }
    [MaxLength(2)]  public string? TipoAgenteRetenedorIva { get; set; }
    public decimal? PorcentajeAgenteRetendorIva { get; set; }
    [MaxLength(10)] public string? IdGrupoCliente { get; set; }
    public int TipoPoliticaCredito { get; set; }
    public int? RegimenContribyente { get; set; }
    [MaxLength(200)] public string? Beneficiario { get; set; }

    // Navigation
    public ICollection<Vehiculo> Vehiculos { get; set; } = new List<Vehiculo>();
    public ICollection<OrdenServicio> OrdenesServicio { get; set; } = new List<OrdenServicio>();
    public ICollection<PresupuestoOrdenServicio> Presupuestos { get; set; } = new List<PresupuestoOrdenServicio>();
}
```

### Vehiculo

```csharp
// Entities/Vehiculo.cs
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
```

### Marca

```csharp
// Entities/Marca.cs
// Tabla origen: [Tbl_Marcas] — solo Id_Empresa + Id_Marca char(10), sin nombre
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Marca
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdMarca { get; set; } = "";     // clave natural

    // Navigation
    public ICollection<LineaVehiculo> Lineas { get; set; } = new List<LineaVehiculo>();
}
```

### LineaVehiculo

```csharp
// Entities/LineaVehiculo.cs
// Tabla origen: [Tbl_Linea_Vehiculo] — Id_Empresa + Id_Marca char(10) + Id_Linea char(10)
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class LineaVehiculo
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdMarca { get; set; } = "";     // parte de clave natural
    [MaxLength(10)] public string IdLinea { get; set; } = "";     // parte de clave natural

    // Navigation
    public Marca? Marca { get; set; }
}
```

### TipoVehiculo

```csharp
// Entities/TipoVehiculo.cs
// Tabla origen: [Tbl_Tipo_Vehiculos] — solo Id_Empresa + Tipo char(25), sin PK numérico
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class TipoVehiculo
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(25)] public string Tipo { get; set; } = "";        // clave natural
}
```

### Color

```csharp
// Entities/Color.cs
// Tabla origen: [Tbl_colores] — Id_Empresa + Color char(10) + uno bit
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Color
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string ColorNombre { get; set; } = ""; // clave natural
    public bool? Uno { get; set; }
}
```

### Vendedor

```csharp
// Entities/Vendedor.cs
// Tabla origen: [Tbl_Vendedores] — mecánicos y empleados/vendedores
using System.ComponentModel.DataAnnotations;
using ControlVehiculos.Infrastructure.Entities.Enums;

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
```

### Bodega

```csharp
// Entities/Bodega.cs
// Tabla origen: [Tbl_bodega] — Id_Empresa + Id_Bodega char(10) + Nombre char(60)
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Bodega
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdBodega { get; set; } = "";    // clave natural
    [MaxLength(60)] public string? Nombre { get; set; }

    // Navigation
    public ICollection<OrdenServicioDetalleIntegracion> Insumos { get; set; } = new List<OrdenServicioDetalleIntegracion>();
    public ICollection<PresupuestoOrdenServicioDetalleIntegracion> InsumosPresupuesto { get; set; } = new List<PresupuestoOrdenServicioDetalleIntegracion>();
}
```

### Producto

```csharp
// Entities/Producto.cs
// Tabla origen: [Tbl_Productos] — 30+ campos; Es_servicio=1 → mano de obra, 0 → insumo
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Producto
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(15)] public string IdProducto { get; set; } = "";  // clave natural
    [MaxLength(100)] public string? Descripcion { get; set; }
    [MaxLength(18)] public string? CodigoBarras { get; set; }
    public decimal CostoPromedio { get; set; }
    [MaxLength(10)] public string? Tipo { get; set; }
    [MaxLength(15)] public string Propiedad1 { get; set; } = "";
    [MaxLength(15)] public string Propiedad2 { get; set; } = "";
    [MaxLength(15)] public string Propiedad3 { get; set; } = "";
    [MaxLength(15)] public string Propiedad4 { get; set; } = "";
    [MaxLength(15)] public string Propiedad5 { get; set; } = "";
    [MaxLength(15)] public string Propiedad6 { get; set; } = "";
    public decimal? CantidadEquivalente { get; set; }
    [MaxLength(5)]  public string IdArticulo { get; set; } = "";
    [MaxLength(3)]  public string IdMedida { get; set; } = "";
    [MaxLength(3)]  public string IdMedida1 { get; set; } = "";
    public DateTime? FechaAlta { get; set; }
    [MaxLength(200)] public string? FotoProducto { get; set; }
    public int? Minimo { get; set; }
    public int? Maximo { get; set; }
    [MaxLength(3)]  public string IdDepto { get; set; } = "";
    [MaxLength(2)]  public string? IdLinea { get; set; }
    [MaxLength(100)] public string DescripcionCorta { get; set; } = "";
    public decimal? UltimoCosto { get; set; }
    public decimal? Precioa { get; set; }
    public decimal? Preciob { get; set; }
    public decimal? Precioc { get; set; }
    public DateTime? FechaUltMov { get; set; }
    [MaxLength(1)]  public string? UsaSubProductos { get; set; }
    public int EsServicio { get; set; }                           // 1=servicio, 0=producto
    public int? AplicarDescuento { get; set; }
    public decimal PorcentajeUtilidad { get; set; }
    public decimal PrecioSugerido { get; set; }
    [MaxLength(80)] public string Usuario { get; set; } = "";
    public DateTime FechaHora { get; set; }
    [MaxLength(20)] public string Ubicacion { get; set; } = "";
    public decimal? PorcMaxDescuento { get; set; }
    [MaxLength(15)] public string? Estado { get; set; }
    public int? PermiteModificarPrecio { get; set; }

    // Navigation
    public ProductoComision? Comision { get; set; }
    public ICollection<InsumoServicio> InsumosComoServicio { get; set; } = new List<InsumoServicio>();
    public ICollection<InsumoServicio> InsumosComoInsumo { get; set; } = new List<InsumoServicio>();
}
```

### ProductoComision

```csharp
// Entities/ProductoComision.cs
// Tabla origen: [tbl_productos_comisiones]
using System.ComponentModel.DataAnnotations;
using ControlVehiculos.Infrastructure.Entities.Enums;

namespace ControlVehiculos.Infrastructure.Entities;

public class ProductoComision
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(15)] public string IdProducto { get; set; } = "";  // clave natural + FK a Producto
    public int TipoComision { get; set; }                         // 1=valor fijo, 2=porcentaje
    public decimal ValorComision { get; set; }
    public decimal PorcentajeComision { get; set; }

    // Navigation
    public Producto? Producto { get; set; }
}
```

### Caja

```csharp
// Entities/Caja.cs
// Tabla origen: [Tbl_Cajas]
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Caja
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdCaja { get; set; }                               // clave natural
    [MaxLength(50)] public string Observaciones { get; set; } = "";
}
```

### Cajero

```csharp
// Entities/Cajero.cs
// Tabla origen: [Tbl_Cajeros]
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Cajero
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(10)] public string IdCajero { get; set; } = "";    // clave natural
    [MaxLength(50)] public string? Nombre { get; set; }
}
```

### Serie

```csharp
// Entities/Serie.cs
// Tabla origen: [Tbl_Series]
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Serie
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(20)] public string Autorizacion { get; set; } = ""; // parte de clave natural
    [MaxLength(5)]  public string SerieCodigo { get; set; } = "";   // parte de clave natural
    [MaxLength(3)]  public string IdTipo { get; set; } = "";        // parte de clave natural
    public int Del { get; set; }
    public int Al { get; set; }
    public int Actual { get; set; }
    public DateTime FechaIngreso { get; set; }
    [MaxLength(30)] public string Descripcion { get; set; } = "";
    public DateTime FechaHora { get; set; }
    public int Status { get; set; }                                 // int — no varchar
    public int? NumeroAnios { get; set; }
    public DateTime? FechaVencimiento { get; set; }
    public int PorcentajeConsumo { get; set; }
}
```

### Banco

```csharp
// Entities/Banco.cs
// Tabla origen: [Tbl_Bancos]
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class Banco
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(2)]  public string IdBanco { get; set; } = "";     // clave natural
    [MaxLength(60)] public string Nombre { get; set; } = "";
}
```

### CasaCredito

```csharp
// Entities/CasaCredito.cs
// Tabla origen: [Tbl_Casas_Credito]
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class CasaCredito
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(2)]  public string IdCasa { get; set; } = "";      // clave natural
    [MaxLength(60)] public string Nombre { get; set; } = "";
}
```

### PresupuestoOrdenServicio

```csharp
// Entities/PresupuestoOrdenServicio.cs
// Tabla origen: [Tbl_Presupuesto_Orden_Servicio] — misma estructura que Tbl_Orden_Servicio
// Es el presupuesto "nuevo" — fuente para sp_genera_orden_servicio
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class PresupuestoOrdenServicio
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdOrden { get; set; }                              // clave natural
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

    // Navigation
    public ICollection<PresupuestoOrdenServicioDetalle> Detalles { get; set; } = new List<PresupuestoOrdenServicioDetalle>();
    public ICollection<PresupuestoOrdenServicioDetalleIntegracion> Integraciones { get; set; } = new List<PresupuestoOrdenServicioDetalleIntegracion>();
}
```

### PresupuestoOrdenServicioDetalle

```csharp
// Entities/PresupuestoOrdenServicioDetalle.cs
// Tabla origen: [tbl_presupuesto_orden_servicio_detalle]
// Igual a Tbl_Orden_Servicio_Detalle + campo Autorizado int
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class PresupuestoOrdenServicioDetalle
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdOrden { get; set; }                              // FK a PresupuestoOrdenServicio
    public int Linea { get; set; }                               // parte de clave natural
    [MaxLength(15)] public string IdServicio { get; set; } = "";
    [MaxLength(100)] public string Descripcion { get; set; } = "";
    [MaxLength(4)]  public string IdEmpleado { get; set; } = ""; // char(4) — mecánico
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
    public int Autorizado { get; set; }                          // campo extra vs OS

    // Navigation
    public PresupuestoOrdenServicio? Presupuesto { get; set; }
    public ICollection<PresupuestoOrdenServicioDetalleIntegracion> Insumos { get; set; } = new List<PresupuestoOrdenServicioDetalleIntegracion>();
}
```

### PresupuestoOrdenServicioDetalleIntegracion

```csharp
// Entities/PresupuestoOrdenServicioDetalleIntegracion.cs
// Tabla origen: [Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion]
// Igual a Tbl_Orden_Servicio_Detalle_Integracion + campo Autorizado int
// NOTA: fecha_hora es NOT NULL aquí (vs nullable en OS)
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
    public DateTime FechaHora { get; set; }                      // NOT NULL en presupuesto
    public int Autorizado { get; set; }

    // Navigation
    public PresupuestoOrdenServicio? Presupuesto { get; set; }
    public PresupuestoOrdenServicioDetalle? DetalleServicio { get; set; }
    public Bodega? Bodega { get; set; }
}
```

### OrdenServicio

```csharp
// Entities/OrdenServicio.cs
// Tabla origen: [Tbl_Orden_Servicio]
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class OrdenServicio
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdOrden { get; set; }                             // clave natural
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
    public decimal Numero { get; set; }                          // numeric(10,0): 0=sin factura

    // Navigation
    public ICollection<OrdenServicioDetalle> Detalles { get; set; } = new List<OrdenServicioDetalle>();
    public ICollection<OrdenServicioDetalleIntegracion> Integraciones { get; set; } = new List<OrdenServicioDetalleIntegracion>();
}
```

### OrdenServicioDetalle

```csharp
// Entities/OrdenServicioDetalle.cs
// Tabla origen: [Tbl_Orden_Servicio_Detalle]
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class OrdenServicioDetalle
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    public int IdOrden { get; set; }
    public int Linea { get; set; }
    [MaxLength(15)] public string IdServicio { get; set; } = "";
    [MaxLength(100)] public string Descripcion { get; set; } = "";
    [MaxLength(4)]  public string IdEmpleado { get; set; } = ""; // char(4) — truncado de char(10)
    [MaxLength(3)]  public string Fosa { get; set; } = "";
    public decimal Precio { get; set; }
    public decimal Otros { get; set; }
    public decimal TotalLinea { get; set; }
    public decimal Cantidad { get; set; }
    public decimal PrecioDescuento { get; set; }
    public decimal TotalLineaDescuento { get; set; }
    public decimal OtrosDescuento { get; set; }
    public decimal Costo { get; set; }                           // numeric(18,5)
    public decimal ValorComision { get; set; }
    public decimal PorcentajeComision { get; set; }

    // Navigation
    public OrdenServicio? OrdenServicio { get; set; }
    public ICollection<OrdenServicioDetalleIntegracion> Insumos { get; set; } = new List<OrdenServicioDetalleIntegracion>();
}
```

### OrdenServicioDetalleIntegracion

```csharp
// Entities/OrdenServicioDetalleIntegracion.cs
// Tabla origen: [Tbl_Orden_Servicio_Detalle_Integracion]
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
    [MaxLength(10)] public string IdBodega { get; set; } = "";   // char(10) — no int
    [MaxLength(1)]  public string SeCobra { get; set; } = "";    // 'S'/'N'
    public decimal TotalLinea { get; set; }
    public decimal PrecioDescuento { get; set; }
    public decimal TotalLineaDescuento { get; set; }
    public int RebajaExistencias { get; set; }
    public decimal Costo { get; set; }                           // numeric(18,5)
    [MaxLength(7)]  public string Periodo { get; set; } = "";
    public DateTime? FechaHora { get; set; }                     // NULL en OS (vs NOT NULL en presupuesto)

    // Navigation
    public OrdenServicio? OrdenServicio { get; set; }
    public OrdenServicioDetalle? DetalleServicio { get; set; }
    public Bodega? Bodega { get; set; }
}
```

### InsumoServicio

```csharp
// Entities/InsumoServicio.cs
// Tabla origen: [Tbl_insumos_servicios]
// Define qué insumos se usan automáticamente al agregar un servicio
using System.ComponentModel.DataAnnotations;

namespace ControlVehiculos.Infrastructure.Entities;

public class InsumoServicio
{
    public int Id { get; set; }
    public int IdEmpresa { get; set; }

    [MaxLength(15)] public string IdProducto { get; set; } = "";  // servicio padre
    [MaxLength(15)] public string IdProducto1 { get; set; } = ""; // insumo asociado
    public decimal Costo { get; set; }
    public decimal? Cantidad { get; set; }                        // numeric(18,0) NULL

    // Navigation
    public Producto? Servicio { get; set; }
    public Producto? Insumo { get; set; }
}
```

---

## 3. Configuraciones Fluent API

### EmpresaConfiguration

```csharp
// Configurations/EmpresaConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class EmpresaConfiguration : IEntityTypeConfiguration<Empresa>
{
    public void Configure(EntityTypeBuilder<Empresa> builder)
    {
        builder.ToTable("empresas");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();
        builder.HasIndex(e => e.IdEmpresa).IsUnique();

        builder.Property(e => e.NombreEmpresa).HasColumnName("Nombre_Empresa").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.PorcentajeIvaAnterior).HasColumnName("Porcentaje_Iva_Anterior");
        builder.Property(e => e.PorcentajeIva).HasColumnName("Porcentaje_iva");
        builder.Property(e => e.Periodo).HasColumnName("Periodo").HasMaxLength(7).IsFixedLength();
        builder.Property(e => e.LmodificaPrecios).HasColumnName("Lmodifica_Precios");
        builder.Property(e => e.SigOrdenServicio).HasColumnName("Sig_Orden_Servicio");
        builder.Property(e => e.PorcentajeUtilidad).HasColumnName("Porcentaje_Utilidad").HasPrecision(18, 2);
        builder.Property(e => e.Apartirde).HasColumnName("apartirde");
        builder.Property(e => e.IdBodegaFacturacion).HasColumnName("Id_Bodega_Facturacion").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.SigNumeroPresupuesto).HasColumnName("Sig_numero_presupuesto");
        builder.Property(e => e.TasaCambio).HasColumnName("Tasa_cambio").HasPrecision(18, 5);
        builder.Property(e => e.ImprimeCopia).HasColumnName("ImprimeCopia");
        builder.Property(e => e.FechaSistema).HasColumnName("FechaSistema");
    }
}
```

### ProveedorConfiguration

```csharp
// Configurations/ProveedorConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class ProveedorConfiguration : IEntityTypeConfiguration<Proveedor>
{
    public void Configure(EntityTypeBuilder<Proveedor> builder)
    {
        builder.ToTable("Tbl_Proveedores");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        // Clave natural: (Id_Empresa, Nit)
        builder.HasIndex(e => new { e.IdEmpresa, e.Nit }).IsUnique();

        builder.Property(e => e.Nit).HasColumnName("Nit").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.CreditoOContado).HasColumnName("Credito_o_Contado");
        builder.Property(e => e.DiasCredito).HasColumnName("Dias_Credito");
        builder.Property(e => e.Contacto).HasColumnName("Contacto").HasMaxLength(80).IsFixedLength();
        builder.Property(e => e.CorreoElectro).HasColumnName("correo_electro").HasMaxLength(80).IsFixedLength();
        builder.Property(e => e.Direccion).HasColumnName("direccion").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.Colonia).HasColumnName("Colonia").HasMaxLength(50).IsFixedLength();
        builder.Property(e => e.Apto).HasColumnName("Apto").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Zona).HasColumnName("zona").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.Ciudad).HasColumnName("ciudad").HasMaxLength(50).IsFixedLength();
        builder.Property(e => e.Telefono).HasColumnName("Telefono").HasMaxLength(30).IsFixedLength();
        builder.Property(e => e.Tarjeta).HasColumnName("Tarjeta").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.NumCasa).HasColumnName("Num_Casa").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.Municipio).HasColumnName("Municipio").HasMaxLength(40).IsFixedLength();
        builder.Property(e => e.Telefono1).HasColumnName("Telefono1").HasMaxLength(30).IsFixedLength();
        builder.Property(e => e.Tipo).HasColumnName("Tipo").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.LocalExtranjero).HasColumnName("Local_Extranjero").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.FechaUltMov).HasColumnName("Fecha_ult_Mov");
        builder.Property(e => e.RetieneIsr).HasColumnName("Retiene_ISR").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.FacturarA).HasColumnName("Facturar_a").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.TipoPrecio).HasColumnName("Tipo_Precio").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.PorcentajeDescuento).HasColumnName("Porcentaje_descuento");
        builder.Property(e => e.Identificacion).HasColumnName("Identificacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.FechaUltMovProv).HasColumnName("Fecha_Ult_Mov_Prov");
        builder.Property(e => e.IdConceptoServicio).HasColumnName("Id_Concepto_servicio").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.TipoIva).HasColumnName("Tipo_Iva");
        builder.Property(e => e.IdCuentaCxp).HasColumnName("Id_Cuenta_cxp").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Clasificacion).HasColumnName("clasificacion").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.PagaIva).HasColumnName("Paga_iva");
        builder.Property(e => e.LimiteCreditoCliente).HasColumnName("Limite_credito_cliente").HasPrecision(18, 2);
        builder.Property(e => e.EsAgenteRetenedorIva).HasColumnName("Es_agente_retenedor_iva");
        builder.Property(e => e.TieneExencionIva).HasColumnName("Tiene_exencion_iva");
        builder.Property(e => e.TipoAgenteRetenedorIva).HasColumnName("Tipo_agente_retenedor_iva").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.PorcentajeAgenteRetendorIva).HasColumnName("Porcentaje_agente_retendor_iva").HasPrecision(18, 2);
        builder.Property(e => e.IdGrupoCliente).HasColumnName("Id_grupo_cliente").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.TipoPoliticaCredito).HasColumnName("Tipo_politica_credito");
        builder.Property(e => e.RegimenContribyente).HasColumnName("regimen_contribyente");
        builder.Property(e => e.Beneficiario).HasColumnName("beneficiario").HasMaxLength(200);

        builder.HasMany(e => e.Vehiculos)
               .WithOne()
               .HasForeignKey(v => v.Nit)
               .HasPrincipalKey(p => p.Nit)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
```

### VehiculoConfiguration

```csharp
// Configurations/VehiculoConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class VehiculoConfiguration : IEntityTypeConfiguration<Vehiculo>
{
    public void Configure(EntityTypeBuilder<Vehiculo> builder)
    {
        builder.ToTable("Tbl_Vehiculos");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        // Clave natural original: (Id_Empresa, Num_Placa)
        builder.HasIndex(e => new { e.IdEmpresa, e.NumPlaca }).IsUnique();

        builder.Property(e => e.NumPlaca).HasColumnName("Num_Placa").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Color).HasColumnName("Color").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Tipo).HasColumnName("Tipo").HasMaxLength(25).IsFixedLength();
        builder.Property(e => e.Marca).HasColumnName("Marca").HasMaxLength(25).IsFixedLength();
        builder.Property(e => e.Linea).HasColumnName("Linea").HasMaxLength(25).IsFixedLength();
        builder.Property(e => e.Modelo).HasColumnName("Modelo").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Puertas).HasColumnName("Puertas").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.Cilindros).HasColumnName("Cilindros").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Motor).HasColumnName("motor").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.UnidadMedida).HasColumnName("Unidad_Medida").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.PresionLlantas).HasColumnName("Presion_Llantas");
        builder.Property(e => e.Combustible).HasColumnName("combustible").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.ServicioCada).HasColumnName("servicio_cada");
        builder.Property(e => e.Nit).HasColumnName("nit").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.FechaUltMov).HasColumnName("Fecha_Ult_Mov");
    }
}
```

### MarcaConfiguration

```csharp
// Configurations/MarcaConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class MarcaConfiguration : IEntityTypeConfiguration<Marca>
{
    public void Configure(EntityTypeBuilder<Marca> builder)
    {
        builder.ToTable("Tbl_Marcas");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdMarca }).IsUnique();

        builder.Property(e => e.IdMarca).HasColumnName("Id_Marca").HasMaxLength(10).IsFixedLength();

        builder.HasMany(e => e.Lineas)
               .WithOne(l => l.Marca)
               .HasForeignKey(l => new { l.IdEmpresa, l.IdMarca })
               .HasPrincipalKey(m => new { m.IdEmpresa, m.IdMarca })
               .OnDelete(DeleteBehavior.Restrict);
    }
}
```

### LineaVehiculoConfiguration

```csharp
// Configurations/LineaVehiculoConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class LineaVehiculoConfiguration : IEntityTypeConfiguration<LineaVehiculo>
{
    public void Configure(EntityTypeBuilder<LineaVehiculo> builder)
    {
        builder.ToTable("Tbl_Linea_Vehiculo");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdMarca, e.IdLinea }).IsUnique();

        builder.Property(e => e.IdMarca).HasColumnName("Id_Marca").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.IdLinea).HasColumnName("Id_Linea").HasMaxLength(10).IsFixedLength();
    }
}
```

### TipoVehiculoConfiguration

```csharp
// Configurations/TipoVehiculoConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class TipoVehiculoConfiguration : IEntityTypeConfiguration<TipoVehiculo>
{
    public void Configure(EntityTypeBuilder<TipoVehiculo> builder)
    {
        builder.ToTable("Tbl_Tipo_Vehiculos");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.Tipo }).IsUnique();

        builder.Property(e => e.Tipo).HasColumnName("Tipo").HasMaxLength(25).IsFixedLength();
    }
}
```

### ColorConfiguration

```csharp
// Configurations/ColorConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class ColorConfiguration : IEntityTypeConfiguration<Color>
{
    public void Configure(EntityTypeBuilder<Color> builder)
    {
        builder.ToTable("Tbl_colores");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.ColorNombre }).IsUnique();

        builder.Property(e => e.ColorNombre).HasColumnName("Color").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Uno).HasColumnName("uno");
    }
}
```

### VendedorConfiguration

```csharp
// Configurations/VendedorConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class VendedorConfiguration : IEntityTypeConfiguration<Vendedor>
{
    public void Configure(EntityTypeBuilder<Vendedor> builder)
    {
        builder.ToTable("Tbl_Vendedores");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdEmpleado }).IsUnique();

        builder.Property(e => e.IdEmpleado).HasColumnName("Id_Empleado").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(80).IsFixedLength();
        builder.Property(e => e.PorcComision).HasColumnName("porc_comision").HasPrecision(18, 2);
        builder.Property(e => e.Status).HasColumnName("status").HasMaxLength(1).IsFixedLength();
    }
}
```

### BodegaConfiguration

```csharp
// Configurations/BodegaConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class BodegaConfiguration : IEntityTypeConfiguration<Bodega>
{
    public void Configure(EntityTypeBuilder<Bodega> builder)
    {
        builder.ToTable("Tbl_bodega");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdBodega }).IsUnique();

        builder.Property(e => e.IdBodega).HasColumnName("Id_Bodega").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(60).IsFixedLength();
    }
}
```

### ProductoConfiguration

```csharp
// Configurations/ProductoConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class ProductoConfiguration : IEntityTypeConfiguration<Producto>
{
    public void Configure(EntityTypeBuilder<Producto> builder)
    {
        builder.ToTable("Tbl_Productos");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdProducto }).IsUnique();

        builder.Property(e => e.IdProducto).HasColumnName("Id_Producto").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Descripcion).HasColumnName("Descripcion").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.CodigoBarras).HasColumnName("Codigo_Barras").HasMaxLength(18).IsFixedLength();
        builder.Property(e => e.CostoPromedio).HasColumnName("Costo_Promedio").HasPrecision(12, 5);
        builder.Property(e => e.Tipo).HasColumnName("Tipo").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Propiedad1).HasColumnName("Propiedad1").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad2).HasColumnName("Propiedad2").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad3).HasColumnName("Propiedad3").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad4).HasColumnName("Propiedad4").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad5).HasColumnName("propiedad5").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad6).HasColumnName("propiedad6").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.CantidadEquivalente).HasColumnName("Cantidad_Equivalente").HasPrecision(12, 4);
        builder.Property(e => e.IdArticulo).HasColumnName("Id_Articulo").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.IdMedida).HasColumnName("Id_medida").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.IdMedida1).HasColumnName("Id_medida1").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.FechaAlta).HasColumnName("Fecha_Alta");
        builder.Property(e => e.FotoProducto).HasColumnName("fotoproducto").HasMaxLength(200);
        builder.Property(e => e.Minimo).HasColumnName("minimo");
        builder.Property(e => e.Maximo).HasColumnName("maximo");
        builder.Property(e => e.IdDepto).HasColumnName("Id_Depto").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.IdLinea).HasColumnName("Id_Linea").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.DescripcionCorta).HasColumnName("Descripcion_Corta").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.UltimoCosto).HasColumnName("ultimo_costo").HasPrecision(18, 5);
        builder.Property(e => e.Precioa).HasColumnName("Precioa").HasPrecision(18, 2);
        builder.Property(e => e.Preciob).HasColumnName("Preciob").HasPrecision(18, 2);
        builder.Property(e => e.Precioc).HasColumnName("Precioc").HasPrecision(18, 2);
        builder.Property(e => e.FechaUltMov).HasColumnName("Fecha_Ult_Mov");
        builder.Property(e => e.UsaSubProductos).HasColumnName("usa_sub_productos").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.EsServicio).HasColumnName("Es_servicio");
        builder.Property(e => e.AplicarDescuento).HasColumnName("Aplicar_Descuento");
        builder.Property(e => e.PorcentajeUtilidad).HasColumnName("Porcentaje_Utilidad").HasPrecision(18, 2);
        builder.Property(e => e.PrecioSugerido).HasColumnName("Precio_sugerido").HasPrecision(18, 2);
        builder.Property(e => e.Usuario).HasColumnName("Usuario").HasMaxLength(80).IsFixedLength();
        builder.Property(e => e.FechaHora).HasColumnName("Fecha_hora");
        builder.Property(e => e.Ubicacion).HasColumnName("ubicacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.PorcMaxDescuento).HasColumnName("Porc_Max_descuento").HasPrecision(5, 2);
        builder.Property(e => e.Estado).HasColumnName("estado").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.PermiteModificarPrecio).HasColumnName("Permite_modificar_precio");

        builder.HasOne(e => e.Comision)
               .WithOne(c => c.Producto)
               .HasForeignKey<ProductoComision>(c => new { c.IdEmpresa, c.IdProducto })
               .HasPrincipalKey<Producto>(p => new { p.IdEmpresa, p.IdProducto })
               .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(e => e.InsumosComoServicio)
               .WithOne(i => i.Servicio)
               .HasForeignKey(i => new { i.IdEmpresa, i.IdProducto })
               .HasPrincipalKey(p => new { p.IdEmpresa, p.IdProducto })
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(e => e.InsumosComoInsumo)
               .WithOne(i => i.Insumo)
               .HasForeignKey(i => new { i.IdEmpresa, i.IdProducto1 })
               .HasPrincipalKey(p => new { p.IdEmpresa, p.IdProducto })
               .OnDelete(DeleteBehavior.Restrict);
    }
}
```

### ProductoComisionConfiguration

```csharp
// Configurations/ProductoComisionConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class ProductoComisionConfiguration : IEntityTypeConfiguration<ProductoComision>
{
    public void Configure(EntityTypeBuilder<ProductoComision> builder)
    {
        builder.ToTable("tbl_productos_comisiones");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdProducto }).IsUnique();

        builder.Property(e => e.IdProducto).HasColumnName("Id_Producto").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.TipoComision).HasColumnName("Tipo_comision");
        builder.Property(e => e.ValorComision).HasColumnName("Valor_comision").HasPrecision(12, 2);
        builder.Property(e => e.PorcentajeComision).HasColumnName("Porcentaje_comision").HasPrecision(12, 2);
    }
}
```

### CajaConfiguration

```csharp
// Configurations/CajaConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class CajaConfiguration : IEntityTypeConfiguration<Caja>
{
    public void Configure(EntityTypeBuilder<Caja> builder)
    {
        builder.ToTable("Tbl_Cajas");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdCaja }).IsUnique();

        builder.Property(e => e.IdCaja).HasColumnName("Id_Caja");
        builder.Property(e => e.Observaciones).HasColumnName("Observaciones").HasMaxLength(50).IsFixedLength();
    }
}
```

### CajeroConfiguration

```csharp
// Configurations/CajeroConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class CajeroConfiguration : IEntityTypeConfiguration<Cajero>
{
    public void Configure(EntityTypeBuilder<Cajero> builder)
    {
        builder.ToTable("Tbl_Cajeros");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdCajero }).IsUnique();

        builder.Property(e => e.IdCajero).HasColumnName("Id_Cajero").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(50).IsFixedLength();
    }
}
```

### SerieConfiguration

```csharp
// Configurations/SerieConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class SerieConfiguration : IEntityTypeConfiguration<Serie>
{
    public void Configure(EntityTypeBuilder<Serie> builder)
    {
        builder.ToTable("Tbl_Series");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        // Clave natural: (Id_Empresa, Autorizacion, Serie, Id_Tipo)
        builder.HasIndex(e => new { e.IdEmpresa, e.Autorizacion, e.SerieCodigo, e.IdTipo }).IsUnique();

        builder.Property(e => e.Autorizacion).HasColumnName("Autorizacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.SerieCodigo).HasColumnName("Serie").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.IdTipo).HasColumnName("Id_Tipo").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.Del).HasColumnName("Del");
        builder.Property(e => e.Al).HasColumnName("Al");
        builder.Property(e => e.Actual).HasColumnName("Actual");
        builder.Property(e => e.FechaIngreso).HasColumnName("Fecha_Ingreso");
        builder.Property(e => e.Descripcion).HasColumnName("Descripcion").HasMaxLength(30).IsFixedLength();
        builder.Property(e => e.FechaHora).HasColumnName("Fecha_hora");
        builder.Property(e => e.Status).HasColumnName("status");
        builder.Property(e => e.NumeroAnios).HasColumnName("Numero_Anios");
        builder.Property(e => e.FechaVencimiento).HasColumnName("Fecha_vencimiento");
        builder.Property(e => e.PorcentajeConsumo).HasColumnName("Porcentaje_consumo");
    }
}
```

### BancoConfiguration

```csharp
// Configurations/BancoConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class BancoConfiguration : IEntityTypeConfiguration<Banco>
{
    public void Configure(EntityTypeBuilder<Banco> builder)
    {
        builder.ToTable("Tbl_Bancos");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdBanco }).IsUnique();

        builder.Property(e => e.IdBanco).HasColumnName("Id_Banco").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(60).IsFixedLength();
    }
}
```

### CasaCreditoConfiguration

```csharp
// Configurations/CasaCreditoConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class CasaCreditoConfiguration : IEntityTypeConfiguration<CasaCredito>
{
    public void Configure(EntityTypeBuilder<CasaCredito> builder)
    {
        builder.ToTable("Tbl_Casas_Credito");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdCasa }).IsUnique();

        builder.Property(e => e.IdCasa).HasColumnName("Id_Casa").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(60).IsFixedLength();
    }
}
```

### PresupuestoOrdenServicioConfiguration

```csharp
// Configurations/PresupuestoOrdenServicioConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class PresupuestoOrdenServicioConfiguration : IEntityTypeConfiguration<PresupuestoOrdenServicio>
{
    public void Configure(EntityTypeBuilder<PresupuestoOrdenServicio> builder)
    {
        builder.ToTable("Tbl_Presupuesto_Orden_Servicio");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdOrden }).IsUnique();

        builder.Property(e => e.IdOrden).HasColumnName("Id_Orden");
        builder.Property(e => e.NumPlaca).HasColumnName("Num_Placa").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.FacturarA).HasColumnName("Facturar_a").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.Observaciones).HasColumnName("Observaciones").HasMaxLength(200);
        builder.Property(e => e.RecibeOrden).HasColumnName("Recibe_Orden").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Encargado).HasColumnName("Encargado").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Tarjeta).HasColumnName("Tarjeta").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.Fecha).HasColumnName("Fecha");
        builder.Property(e => e.Status).HasColumnName("Status");
        builder.Property(e => e.Nit).HasColumnName("Nit").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.LecturaActual).HasColumnName("Lectura_Actual");
        builder.Property(e => e.ProximoServicio).HasColumnName("Proximo_Servicio");
        builder.Property(e => e.FechaCierre).HasColumnName("Fecha_Cierre");
        builder.Property(e => e.FechaFacturacion).HasColumnName("Fecha_Facturacion");
        builder.Property(e => e.Anticipo).HasColumnName("Anticipo").HasPrecision(18, 2);
        builder.Property(e => e.Autorizacion).HasColumnName("Autorizacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.Serie).HasColumnName("Serie").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.Tipo).HasColumnName("tipo").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.Numero).HasColumnName("Numero").HasPrecision(10, 0);

        builder.HasMany(e => e.Detalles)
               .WithOne(d => d.Presupuesto)
               .HasForeignKey(d => new { d.IdEmpresa, d.IdOrden })
               .HasPrincipalKey(e => new { e.IdEmpresa, e.IdOrden })
               .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(e => e.Integraciones)
               .WithOne(i => i.Presupuesto)
               .HasForeignKey(i => new { i.IdEmpresa, i.IdOrden })
               .HasPrincipalKey(e => new { e.IdEmpresa, e.IdOrden })
               .OnDelete(DeleteBehavior.Cascade);
    }
}
```

### PresupuestoOrdenServicioDetalleConfiguration

```csharp
// Configurations/PresupuestoOrdenServicioDetalleConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class PresupuestoOrdenServicioDetalleConfiguration : IEntityTypeConfiguration<PresupuestoOrdenServicioDetalle>
{
    public void Configure(EntityTypeBuilder<PresupuestoOrdenServicioDetalle> builder)
    {
        builder.ToTable("tbl_presupuesto_orden_servicio_detalle");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdOrden, e.Linea }).IsUnique();

        builder.Property(e => e.IdOrden).HasColumnName("Id_Orden");
        builder.Property(e => e.Linea).HasColumnName("Linea");
        builder.Property(e => e.IdServicio).HasColumnName("Id_Servicio").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Descripcion).HasColumnName("Descripcion").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.IdEmpleado).HasColumnName("Id_Empleado").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Fosa).HasColumnName("Fosa").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.Precio).HasColumnName("Precio").HasPrecision(18, 2);
        builder.Property(e => e.Otros).HasColumnName("otros").HasPrecision(18, 2);
        builder.Property(e => e.TotalLinea).HasColumnName("Total_Linea").HasPrecision(18, 2);
        builder.Property(e => e.Cantidad).HasColumnName("Cantidad").HasPrecision(18, 2);
        builder.Property(e => e.PrecioDescuento).HasColumnName("Precio_Descuento").HasPrecision(18, 2);
        builder.Property(e => e.TotalLineaDescuento).HasColumnName("Total_Linea_Descuento").HasPrecision(18, 2);
        builder.Property(e => e.OtrosDescuento).HasColumnName("otros_Descuento").HasPrecision(18, 2);
        builder.Property(e => e.Costo).HasColumnName("costo").HasPrecision(18, 5);
        builder.Property(e => e.ValorComision).HasColumnName("Valor_comision").HasPrecision(12, 2);
        builder.Property(e => e.PorcentajeComision).HasColumnName("Porcentaje_comision").HasPrecision(12, 2);
        builder.Property(e => e.Autorizado).HasColumnName("Autorizado");

        builder.HasMany(e => e.Insumos)
               .WithOne(i => i.DetalleServicio)
               .HasForeignKey(i => new { i.IdEmpresa, i.IdOrden, i.Linea })
               .HasPrincipalKey(d => new { d.IdEmpresa, d.IdOrden, d.Linea })
               .OnDelete(DeleteBehavior.Cascade);
    }
}
```

### PresupuestoOrdenServicioDetalleIntegracionConfiguration

```csharp
// Configurations/PresupuestoOrdenServicioDetalleIntegracionConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class PresupuestoOrdenServicioDetalleIntegracionConfiguration
    : IEntityTypeConfiguration<PresupuestoOrdenServicioDetalleIntegracion>
{
    public void Configure(EntityTypeBuilder<PresupuestoOrdenServicioDetalleIntegracion> builder)
    {
        builder.ToTable("Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdOrden, e.Linea, e.LineaDet }).IsUnique();

        builder.Property(e => e.IdOrden).HasColumnName("Id_Orden");
        builder.Property(e => e.Linea).HasColumnName("Linea");
        builder.Property(e => e.LineaDet).HasColumnName("Linea_det");
        builder.Property(e => e.IdProducto).HasColumnName("Id_Producto").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Descripcion).HasColumnName("Descripcion").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.Cantidad).HasColumnName("Cantidad").HasPrecision(18, 2);
        builder.Property(e => e.Precio).HasColumnName("Precio").HasPrecision(18, 2);
        builder.Property(e => e.IdBodega).HasColumnName("Id_Bodega").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.SeCobra).HasColumnName("Se_Cobra").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.TotalLinea).HasColumnName("Total_Linea").HasPrecision(18, 2);
        builder.Property(e => e.PrecioDescuento).HasColumnName("Precio_descuento").HasPrecision(18, 2);
        builder.Property(e => e.TotalLineaDescuento).HasColumnName("Total_Linea_descuento").HasPrecision(18, 2);
        builder.Property(e => e.RebajaExistencias).HasColumnName("Rebaja_Existencias");
        builder.Property(e => e.Costo).HasColumnName("Costo").HasPrecision(18, 5);
        builder.Property(e => e.Periodo).HasColumnName("Periodo").HasMaxLength(7).IsFixedLength();
        builder.Property(e => e.FechaHora).HasColumnName("fecha_hora");    // NOT NULL en esta tabla
        builder.Property(e => e.Autorizado).HasColumnName("Autorizado");
    }
}
```

### OrdenServicioConfiguration

```csharp
// Configurations/OrdenServicioConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class OrdenServicioConfiguration : IEntityTypeConfiguration<OrdenServicio>
{
    public void Configure(EntityTypeBuilder<OrdenServicio> builder)
    {
        builder.ToTable("Tbl_Orden_Servicio");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdOrden }).IsUnique();

        builder.Property(e => e.IdOrden).HasColumnName("Id_Orden");
        builder.Property(e => e.NumPlaca).HasColumnName("Num_Placa").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.FacturarA).HasColumnName("Facturar_a").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.Observaciones).HasColumnName("Observaciones").HasMaxLength(200);
        builder.Property(e => e.RecibeOrden).HasColumnName("Recibe_Orden").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Encargado).HasColumnName("Encargado").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Tarjeta).HasColumnName("Tarjeta").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.Fecha).HasColumnName("Fecha");
        builder.Property(e => e.Status).HasColumnName("Status");
        builder.Property(e => e.Nit).HasColumnName("Nit").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.LecturaActual).HasColumnName("Lectura_Actual");
        builder.Property(e => e.ProximoServicio).HasColumnName("Proximo_Servicio");
        builder.Property(e => e.FechaCierre).HasColumnName("Fecha_Cierre");
        builder.Property(e => e.FechaFacturacion).HasColumnName("Fecha_Facturacion");
        builder.Property(e => e.Anticipo).HasColumnName("Anticipo").HasPrecision(18, 2);
        builder.Property(e => e.Autorizacion).HasColumnName("Autorizacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.Serie).HasColumnName("Serie").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.Tipo).HasColumnName("tipo").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.Numero).HasColumnName("Numero").HasPrecision(10, 0);

        builder.HasMany(e => e.Detalles)
               .WithOne(d => d.OrdenServicio)
               .HasForeignKey(d => new { d.IdEmpresa, d.IdOrden })
               .HasPrincipalKey(e => new { e.IdEmpresa, e.IdOrden })
               .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(e => e.Integraciones)
               .WithOne(i => i.OrdenServicio)
               .HasForeignKey(i => new { i.IdEmpresa, i.IdOrden })
               .HasPrincipalKey(e => new { e.IdEmpresa, e.IdOrden })
               .OnDelete(DeleteBehavior.Cascade);
    }
}
```

### OrdenServicioDetalleConfiguration

```csharp
// Configurations/OrdenServicioDetalleConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class OrdenServicioDetalleConfiguration : IEntityTypeConfiguration<OrdenServicioDetalle>
{
    public void Configure(EntityTypeBuilder<OrdenServicioDetalle> builder)
    {
        builder.ToTable("Tbl_Orden_Servicio_Detalle");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdOrden, e.Linea }).IsUnique();

        builder.Property(e => e.IdOrden).HasColumnName("Id_Orden");
        builder.Property(e => e.Linea).HasColumnName("Linea");
        builder.Property(e => e.IdServicio).HasColumnName("Id_Servicio").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Descripcion).HasColumnName("Descripcion").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.IdEmpleado).HasColumnName("Id_Empleado").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Fosa).HasColumnName("Fosa").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.Precio).HasColumnName("Precio").HasPrecision(18, 2);
        builder.Property(e => e.Otros).HasColumnName("otros").HasPrecision(18, 2);
        builder.Property(e => e.TotalLinea).HasColumnName("Total_Linea").HasPrecision(18, 2);
        builder.Property(e => e.Cantidad).HasColumnName("Cantidad").HasPrecision(18, 2);
        builder.Property(e => e.PrecioDescuento).HasColumnName("Precio_Descuento").HasPrecision(18, 2);
        builder.Property(e => e.TotalLineaDescuento).HasColumnName("Total_Linea_Descuento").HasPrecision(18, 2);
        builder.Property(e => e.OtrosDescuento).HasColumnName("otros_Descuento").HasPrecision(18, 2);
        builder.Property(e => e.Costo).HasColumnName("costo").HasPrecision(18, 5);
        builder.Property(e => e.ValorComision).HasColumnName("Valor_comision").HasPrecision(12, 2);
        builder.Property(e => e.PorcentajeComision).HasColumnName("Porcentaje_comision").HasPrecision(12, 2);

        builder.HasMany(e => e.Insumos)
               .WithOne(i => i.DetalleServicio)
               .HasForeignKey(i => new { i.IdEmpresa, i.IdOrden, i.Linea })
               .HasPrincipalKey(d => new { d.IdEmpresa, d.IdOrden, d.Linea })
               .OnDelete(DeleteBehavior.Cascade);
    }
}
```

### OrdenServicioDetalleIntegracionConfiguration

```csharp
// Configurations/OrdenServicioDetalleIntegracionConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class OrdenServicioDetalleIntegracionConfiguration : IEntityTypeConfiguration<OrdenServicioDetalleIntegracion>
{
    public void Configure(EntityTypeBuilder<OrdenServicioDetalleIntegracion> builder)
    {
        builder.ToTable("Tbl_Orden_Servicio_Detalle_Integracion");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdOrden, e.Linea, e.LineaDet }).IsUnique();

        builder.Property(e => e.IdOrden).HasColumnName("Id_Orden");
        builder.Property(e => e.Linea).HasColumnName("Linea");
        builder.Property(e => e.LineaDet).HasColumnName("Linea_det");
        builder.Property(e => e.IdProducto).HasColumnName("Id_Producto").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Descripcion).HasColumnName("Descripcion").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.Cantidad).HasColumnName("Cantidad").HasPrecision(18, 2);
        builder.Property(e => e.Precio).HasColumnName("Precio").HasPrecision(18, 2);
        builder.Property(e => e.IdBodega).HasColumnName("Id_Bodega").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.SeCobra).HasColumnName("Se_Cobra").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.TotalLinea).HasColumnName("Total_Linea").HasPrecision(18, 2);
        builder.Property(e => e.PrecioDescuento).HasColumnName("Precio_descuento").HasPrecision(18, 2);
        builder.Property(e => e.TotalLineaDescuento).HasColumnName("Total_Linea_descuento").HasPrecision(18, 2);
        builder.Property(e => e.RebajaExistencias).HasColumnName("Rebaja_Existencias");
        builder.Property(e => e.Costo).HasColumnName("Costo").HasPrecision(18, 5);
        builder.Property(e => e.Periodo).HasColumnName("Periodo").HasMaxLength(7).IsFixedLength();
        builder.Property(e => e.FechaHora).HasColumnName("fecha_hora");    // NULL en OS
    }
}
```

### InsumoServicioConfiguration

```csharp
// Configurations/InsumoServicioConfiguration.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ControlVehiculos.Infrastructure.Configurations;

public class InsumoServicioConfiguration : IEntityTypeConfiguration<InsumoServicio>
{
    public void Configure(EntityTypeBuilder<InsumoServicio> builder)
    {
        builder.ToTable("Tbl_insumos_servicios");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdProducto, e.IdProducto1 }).IsUnique();

        builder.Property(e => e.IdProducto).HasColumnName("Id_producto").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.IdProducto1).HasColumnName("Id_Producto1").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Costo).HasColumnName("Costo").HasPrecision(18, 2);
        builder.Property(e => e.Cantidad).HasColumnName("Cantidad").HasPrecision(18, 0);
    }
}
```

---

## 4. IEmpresaContext e AppDbContext

```csharp
// Data/IEmpresaContext.cs
namespace ControlVehiculos.Infrastructure.Data;

/// <summary>
/// Contrato que expone el IdEmpresa de sesión para los Global Query Filters.
/// Implementar en HttpContext o en un servicio de sesión.
/// </summary>
public interface IEmpresaContext
{
    int IdEmpresa { get; }
}
```

```csharp
// Data/AppDbContext.cs
using Microsoft.EntityFrameworkCore;
using ControlVehiculos.Infrastructure.Entities;
using ControlVehiculos.Infrastructure.Configurations;

namespace ControlVehiculos.Infrastructure.Data;

public class AppDbContext : DbContext
{
    private readonly IEmpresaContext _empresaContext;

    public AppDbContext(DbContextOptions<AppDbContext> options, IEmpresaContext empresaContext)
        : base(options)
    {
        _empresaContext = empresaContext;
    }

    // ── Catálogos de empresa ──────────────────────────────────────
    public DbSet<Empresa> Empresas => Set<Empresa>();
    public DbSet<Proveedor> Proveedores => Set<Proveedor>();
    public DbSet<Vendedor> Vendedores => Set<Vendedor>();
    public DbSet<Bodega> Bodegas => Set<Bodega>();
    public DbSet<Caja> Cajas => Set<Caja>();
    public DbSet<Cajero> Cajeros => Set<Cajero>();
    public DbSet<Serie> Series => Set<Serie>();
    public DbSet<Banco> Bancos => Set<Banco>();
    public DbSet<CasaCredito> CasasCredito => Set<CasaCredito>();

    // ── Catálogos de vehículos ────────────────────────────────────
    public DbSet<Vehiculo> Vehiculos => Set<Vehiculo>();
    public DbSet<Marca> Marcas => Set<Marca>();
    public DbSet<LineaVehiculo> LineasVehiculo => Set<LineaVehiculo>();
    public DbSet<TipoVehiculo> TiposVehiculo => Set<TipoVehiculo>();
    public DbSet<Color> Colores => Set<Color>();

    // ── Productos / servicios ─────────────────────────────────────
    public DbSet<Producto> Productos => Set<Producto>();
    public DbSet<ProductoComision> ProductosComisiones => Set<ProductoComision>();
    public DbSet<InsumoServicio> InsumosServicios => Set<InsumoServicio>();

    // ── Presupuesto (versión nueva) ───────────────────────────────
    public DbSet<PresupuestoOrdenServicio> PresupuestosOrdenServicio => Set<PresupuestoOrdenServicio>();
    public DbSet<PresupuestoOrdenServicioDetalle> PresupuestosOrdenServicioDetalle => Set<PresupuestoOrdenServicioDetalle>();
    public DbSet<PresupuestoOrdenServicioDetalleIntegracion> PresupuestosOrdenServicioDetalleIntegracion => Set<PresupuestoOrdenServicioDetalleIntegracion>();

    // ── Orden de servicio ─────────────────────────────────────────
    public DbSet<OrdenServicio> OrdenesServicio => Set<OrdenServicio>();
    public DbSet<OrdenServicioDetalle> OrdenesServicioDetalle => Set<OrdenServicioDetalle>();
    public DbSet<OrdenServicioDetalleIntegracion> OrdenesServicioDetalleIntegracion => Set<OrdenServicioDetalleIntegracion>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // ── Aplicar todas las configuraciones ─────────────────────
        modelBuilder.ApplyConfiguration(new EmpresaConfiguration());
        modelBuilder.ApplyConfiguration(new ProveedorConfiguration());
        modelBuilder.ApplyConfiguration(new VehiculoConfiguration());
        modelBuilder.ApplyConfiguration(new MarcaConfiguration());
        modelBuilder.ApplyConfiguration(new LineaVehiculoConfiguration());
        modelBuilder.ApplyConfiguration(new TipoVehiculoConfiguration());
        modelBuilder.ApplyConfiguration(new ColorConfiguration());
        modelBuilder.ApplyConfiguration(new VendedorConfiguration());
        modelBuilder.ApplyConfiguration(new BodegaConfiguration());
        modelBuilder.ApplyConfiguration(new ProductoConfiguration());
        modelBuilder.ApplyConfiguration(new ProductoComisionConfiguration());
        modelBuilder.ApplyConfiguration(new CajaConfiguration());
        modelBuilder.ApplyConfiguration(new CajeroConfiguration());
        modelBuilder.ApplyConfiguration(new SerieConfiguration());
        modelBuilder.ApplyConfiguration(new BancoConfiguration());
        modelBuilder.ApplyConfiguration(new CasaCreditoConfiguration());
        modelBuilder.ApplyConfiguration(new PresupuestoOrdenServicioConfiguration());
        modelBuilder.ApplyConfiguration(new PresupuestoOrdenServicioDetalleConfiguration());
        modelBuilder.ApplyConfiguration(new PresupuestoOrdenServicioDetalleIntegracionConfiguration());
        modelBuilder.ApplyConfiguration(new OrdenServicioConfiguration());
        modelBuilder.ApplyConfiguration(new OrdenServicioDetalleConfiguration());
        modelBuilder.ApplyConfiguration(new OrdenServicioDetalleIntegracionConfiguration());
        modelBuilder.ApplyConfiguration(new InsumoServicioConfiguration());

        // ── Global Query Filters — filtran por empresa de sesión ──
        // Empresa NO lleva filtro (es la tabla raíz de configuración)
        modelBuilder.Entity<Proveedor>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Vehiculo>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Marca>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<LineaVehiculo>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<TipoVehiculo>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Color>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Vendedor>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Bodega>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Producto>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<ProductoComision>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<InsumoServicio>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Caja>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Cajero>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Serie>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<Banco>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<CasaCredito>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<PresupuestoOrdenServicio>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<PresupuestoOrdenServicioDetalle>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<PresupuestoOrdenServicioDetalleIntegracion>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<OrdenServicio>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<OrdenServicioDetalle>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
        modelBuilder.Entity<OrdenServicioDetalleIntegracion>().HasQueryFilter(e => e.IdEmpresa == _empresaContext.IdEmpresa);
    }
}
```

---

## Notas de implementación

| Decisión | Razón |
|---|---|
| Surrogate PK `int Id` en todas las entidades | Las PKs originales son compuestas (IdEmpresa + clave natural); EF Core navega mejor con surrogate int |
| `IdEmpresa` como `int` en todas las entidades | Permite Global Query Filter uniforme sin cast |
| `Tbl_Vendedores.IdEmpleado` = `string [MaxLength(10)]` | DDL real es `char(10)`; en `OrdenServicioDetalle.IdEmpleado` es `char(4)` — discrepancia histórica documentada en data-model.md |
| `Tbl_Vehiculos` sin FK a catálogos | DDL real confirma texto libre en Color/Tipo/Marca/Linea — los catálogos son solo para UI de lookup |
| `Numero` en OS/Presupuesto = `decimal` con `HasPrecision(10,0)` | DDL: `numeric(10,0)` — C# no tiene tipo integral de 10 dígitos nativo |
| `InsumoServicio.Cantidad` = `decimal?` | DDL: `numeric(18,0) NULL` |
| `Tbl_Marcas` sin nombre | DDL real solo tiene `Id_Empresa + Id_Marca char(10)` — sin campo de nombre de marca |
| `PresupuestoOrdenServicioDetalleIntegracion.FechaHora` = `DateTime` (no nullable) | En la tabla de presupuesto es `NOT NULL`; en OS es `NULL` |
| Global Query Filter sobre `_empresaContext` (interface) | Permite inyectar `IdEmpresa` desde HttpContext sin acoplar el DbContext a la capa web |
