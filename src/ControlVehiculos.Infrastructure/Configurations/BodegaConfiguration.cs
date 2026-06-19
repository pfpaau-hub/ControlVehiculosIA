using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
