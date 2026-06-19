using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class VehiculoConfiguration : IEntityTypeConfiguration<Vehiculo>
{
    public void Configure(EntityTypeBuilder<Vehiculo> builder)
    {
        builder.ToTable("Tbl_Vehiculos");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.NumPlaca }).IsUnique();

        builder.Property(e => e.NumPlaca).HasColumnName("Num_Placa").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Color).HasColumnName("Color").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Tipo).HasColumnName("Tipo").HasMaxLength(25).IsFixedLength();
        builder.Property(e => e.Marca).HasColumnName("Marca").HasMaxLength(25).IsFixedLength();
        builder.Property(e => e.Linea).HasColumnName("Linea").HasMaxLength(25).IsFixedLength();
        builder.Property(e => e.Modelo).HasColumnName("Modelo").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Puertas).HasColumnName("Puertas").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.Cilindros).HasColumnName("Cilindros").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Motor).HasColumnName("motor").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.UnidadMedida).HasColumnName("Unidad_Medida").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.PresionLlantas).HasColumnName("Presion_Llantas");
        builder.Property(e => e.Combustible).HasColumnName("combustible").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.ServicioCada).HasColumnName("servicio_cada");
        builder.Property(e => e.Nit).HasColumnName("nit").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.FechaUltMov).HasColumnName("Fecha_Ult_Mov");

        builder.HasMany(e => e.OrdenesServicio)
               .WithOne(os => os.Vehiculo)
               .HasForeignKey(os => os.VehiculoId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(e => e.Presupuestos)
               .WithOne(p => p.Vehiculo)
               .HasForeignKey(p => p.VehiculoId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
