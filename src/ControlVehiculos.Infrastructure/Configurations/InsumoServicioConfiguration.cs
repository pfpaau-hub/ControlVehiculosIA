using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
