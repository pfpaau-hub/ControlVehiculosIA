using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
