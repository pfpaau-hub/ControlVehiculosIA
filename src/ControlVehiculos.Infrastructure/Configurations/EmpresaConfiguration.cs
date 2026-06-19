using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class EmpresaConfiguration : IEntityTypeConfiguration<Empresa>
{
    public void Configure(EntityTypeBuilder<Empresa> builder)
    {
        builder.ToTable("empresas");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();
        builder.HasIndex(e => e.IdEmpresa).IsUnique();

        builder.Property(e => e.NombreEmpresa).HasColumnName("Nombre_Empresa").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.PorcentajeIvaAnterior).HasColumnName("Porcentaje_Iva_Anterior");
        builder.Property(e => e.PorcentajeIva).HasColumnName("Porcentaje_iva");
        builder.Property(e => e.Periodo).HasColumnName("Periodo").HasMaxLength(7).IsFixedLength();
        builder.Property(e => e.LmodificaPrecios).HasColumnName("Lmodifica_Precios");
        builder.Property(e => e.SigOrdenServicio).HasColumnName("Sig_Orden_Servicio");
        builder.Property(e => e.PorcentajeUtilidad).HasColumnName("Porcentaje_Utilidad").HasPrecision(18, 2);
        builder.Property(e => e.Apartirde).HasColumnName("apartirde");
        builder.Property(e => e.IdBodegaFacturacion).HasColumnName("Id_Bodega_Facturacion").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.SigNumeroPresupuesto).HasColumnName("Sig_numero_presupuesto");
        builder.Property(e => e.TasaCambio).HasColumnName("Tasa_cambio").HasPrecision(18, 5);
        builder.Property(e => e.ImprimeCopia).HasColumnName("ImprimeCopia");
        builder.Property(e => e.FechaSistema).HasColumnName("FechaSistema");
    }
}
