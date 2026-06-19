using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

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
