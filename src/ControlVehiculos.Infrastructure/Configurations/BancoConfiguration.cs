using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class BancoConfiguration : IEntityTypeConfiguration<Banco>
{
    public void Configure(EntityTypeBuilder<Banco> builder)
    {
        builder.ToTable("Tbl_Bancos");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdBanco }).IsUnique();

        builder.Property(e => e.IdBanco).HasColumnName("Id_Banco").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(60).IsFixedLength();
    }
}
