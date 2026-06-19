using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
