using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
