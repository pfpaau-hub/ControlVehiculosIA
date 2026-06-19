using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class SerieConfiguration : IEntityTypeConfiguration<Serie>
{
    public void Configure(EntityTypeBuilder<Serie> builder)
    {
        builder.ToTable("Tbl_Series");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.Autorizacion }).IsUnique();

        builder.Property(e => e.Autorizacion).HasColumnName("Autorizacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.SerieCodigo).HasColumnName("Serie").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.IdTipo).HasColumnName("Id_Tipo").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.Del).HasColumnName("Del");
        builder.Property(e => e.Al).HasColumnName("Al");
        builder.Property(e => e.Actual).HasColumnName("Actual");
        builder.Property(e => e.FechaIngreso).HasColumnName("Fecha_Ingreso");
        builder.Property(e => e.Descripcion).HasColumnName("Descripcion").HasMaxLength(30).IsFixedLength();
        builder.Property(e => e.FechaHora).HasColumnName("Fecha_hora");
        builder.Property(e => e.Status).HasColumnName("status");
        builder.Property(e => e.NumeroAnios).HasColumnName("Numero_Anios");
        builder.Property(e => e.FechaVencimiento).HasColumnName("Fecha_vencimiento");
        builder.Property(e => e.PorcentajeConsumo).HasColumnName("Porcentaje_consumo");
    }
}
