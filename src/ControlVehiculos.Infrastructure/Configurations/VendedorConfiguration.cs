using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class VendedorConfiguration : IEntityTypeConfiguration<Vendedor>
{
    public void Configure(EntityTypeBuilder<Vendedor> builder)
    {
        builder.ToTable("Tbl_Vendedores");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdEmpleado }).IsUnique();

        builder.Property(e => e.IdEmpleado).HasColumnName("Id_Empleado").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(80).IsFixedLength();
        builder.Property(e => e.PorcComision).HasColumnName("porc_comision").HasPrecision(18, 2);
        builder.Property(e => e.Status).HasColumnName("status").HasMaxLength(1).IsFixedLength();

        builder.HasMany(e => e.LineasServicio)
               .WithOne(d => d.Vendedor)
               .HasForeignKey(d => d.VendedorId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(e => e.LineasPresupuesto)
               .WithOne(d => d.Vendedor)
               .HasForeignKey(d => d.VendedorId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
