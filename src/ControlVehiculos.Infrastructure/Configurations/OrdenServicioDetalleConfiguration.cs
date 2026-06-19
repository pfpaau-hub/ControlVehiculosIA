using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
        builder.Property(e => e.OrdenServicioId).HasColumnName("OrdenServicioId");
        builder.Property(e => e.VendedorId).HasColumnName("VendedorId");

        builder.HasMany(e => e.Insumos).WithOne(i => i.DetalleServicio)
               .HasForeignKey(i => i.OrdenDetalleId).OnDelete(DeleteBehavior.Cascade);
    }
}
