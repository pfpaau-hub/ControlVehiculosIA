using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class PresupuestoOrdenServicioConfiguration : IEntityTypeConfiguration<PresupuestoOrdenServicio>
{
    public void Configure(EntityTypeBuilder<PresupuestoOrdenServicio> builder)
    {
        builder.ToTable("Tbl_Presupuesto_Orden_Servicio");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdOrden }).IsUnique();

        builder.Property(e => e.IdOrden).HasColumnName("Id_Orden");
        builder.Property(e => e.NumPlaca).HasColumnName("Num_Placa").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.FacturarA).HasColumnName("Facturar_a").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.Observaciones).HasColumnName("Observaciones").HasMaxLength(200);
        builder.Property(e => e.RecibeOrden).HasColumnName("Recibe_Orden").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Encargado).HasColumnName("Encargado").HasMaxLength(4).IsFixedLength();
        builder.Property(e => e.Tarjeta).HasColumnName("Tarjeta").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.Fecha).HasColumnName("Fecha");
        builder.Property(e => e.Status).HasColumnName("Status");
        builder.Property(e => e.Nit).HasColumnName("Nit").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.LecturaActual).HasColumnName("Lectura_Actual");
        builder.Property(e => e.ProximoServicio).HasColumnName("Proximo_Servicio");
        builder.Property(e => e.FechaCierre).HasColumnName("Fecha_Cierre");
        builder.Property(e => e.FechaFacturacion).HasColumnName("Fecha_Facturacion");
        builder.Property(e => e.Anticipo).HasColumnName("Anticipo").HasPrecision(18, 2);
        builder.Property(e => e.Autorizacion).HasColumnName("Autorizacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.Serie).HasColumnName("Serie").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.Tipo).HasColumnName("tipo").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.Numero).HasColumnName("Numero").HasPrecision(10, 0);
        builder.Property(e => e.ProveedorId).HasColumnName("ProveedorId");
        builder.Property(e => e.VehiculoId).HasColumnName("VehiculoId");

        builder.HasMany(e => e.Detalles).WithOne(d => d.Presupuesto)
               .HasForeignKey(d => d.PresupuestoId).OnDelete(DeleteBehavior.Cascade);
    }
}
