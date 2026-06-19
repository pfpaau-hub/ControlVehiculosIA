using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class MarcaConfiguration : IEntityTypeConfiguration<Marca>
{
    public void Configure(EntityTypeBuilder<Marca> builder)
    {
        builder.ToTable("Tbl_Marcas");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdMarca }).IsUnique();
        builder.Property(e => e.IdMarca).HasColumnName("Id_Marca").HasMaxLength(10).IsFixedLength();

        builder.HasMany(e => e.Lineas)
               .WithOne(l => l.Marca)
               .HasForeignKey(l => new { l.IdEmpresa, l.IdMarca })
               .HasPrincipalKey(m => new { m.IdEmpresa, m.IdMarca })
               .OnDelete(DeleteBehavior.Restrict);
    }
}
