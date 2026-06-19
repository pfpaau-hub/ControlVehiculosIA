using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using ControlVehiculos.Infrastructure.Entities;
using ControlVehiculos.Infrastructure.Configurations;
using ControlVehiculos.Application.Common;

namespace ControlVehiculos.Infrastructure.Data;

public class AppDbContext : IdentityDbContext<AppUser>
{
    private readonly IEmpresaContext _empresaContext;

    public AppDbContext(DbContextOptions<AppDbContext> options, IEmpresaContext empresaContext)
        : base(options)
    {
        _empresaContext = empresaContext;
    }

    // Catálogos de empresa
    public DbSet<Empresa> Empresas => Set<Empresa>();
    public DbSet<Proveedor> Proveedores => Set<Proveedor>();
    public DbSet<Vendedor> Vendedores => Set<Vendedor>();
    public DbSet<Bodega> Bodegas => Set<Bodega>();
    public DbSet<Caja> Cajas => Set<Caja>();
    public DbSet<Cajero> Cajeros => Set<Cajero>();
    public DbSet<Serie> Series => Set<Serie>();
    public DbSet<Banco> Bancos => Set<Banco>();
    public DbSet<CasaCredito> CasasCredito => Set<CasaCredito>();

    // Catálogos de vehículos
    public DbSet<Vehiculo> Vehiculos => Set<Vehiculo>();
    public DbSet<Marca> Marcas => Set<Marca>();
    public DbSet<LineaVehiculo> LineasVehiculo => Set<LineaVehiculo>();
    public DbSet<TipoVehiculo> TiposVehiculo => Set<TipoVehiculo>();
    public DbSet<Color> Colores => Set<Color>();

    // Productos y servicios
    public DbSet<Producto> Productos => Set<Producto>();
    public DbSet<ProductoComision> ProductosComisiones => Set<ProductoComision>();
    public DbSet<InsumoServicio> InsumosServicios => Set<InsumoServicio>();

    // Presupuestos
    public DbSet<PresupuestoOrdenServicio> PresupuestosOrdenServicio => Set<PresupuestoOrdenServicio>();
    public DbSet<PresupuestoOrdenServicioDetalle> PresupuestosOrdenServicioDetalle => Set<PresupuestoOrdenServicioDetalle>();
    public DbSet<PresupuestoOrdenServicioDetalleIntegracion> PresupuestosOrdenServicioDetalleIntegracion => Set<PresupuestoOrdenServicioDetalleIntegracion>();

    // Órdenes de servicio
    public DbSet<OrdenServicio> OrdenesServicio => Set<OrdenServicio>();
    public DbSet<OrdenServicioDetalle> OrdenesServicioDetalle => Set<OrdenServicioDetalle>();
    public DbSet<OrdenServicioDetalleIntegracion> OrdenesServicioDetalleIntegracion => Set<OrdenServicioDetalleIntegracion>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

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

        // Global Query Filters — filtran automáticamente por empresa de sesión
        // Empresa no lleva filtro (tabla raíz de configuración)
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
