using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
        builder.Property(e => e.FechaHora).HasColumnName("fecha_hora");
        builder.Property(e => e.OrdenDetalleId).HasColumnName("OrdenDetalleId");
        builder.Property(e => e.OrdenServicioId).HasColumnName("OrdenServicioId");
        builder.Property(e => e.BodegaId).HasColumnName("BodegaId");

        builder.HasOne(e => e.OrdenServicio)
               .WithMany(os => os.Integraciones)
               .HasForeignKey(e => e.OrdenServicioId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Bodega)
               .WithMany(b => b.Insumos)
               .HasForeignKey(e => e.BodegaId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
