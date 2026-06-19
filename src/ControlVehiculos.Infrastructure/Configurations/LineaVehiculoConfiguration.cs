using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
