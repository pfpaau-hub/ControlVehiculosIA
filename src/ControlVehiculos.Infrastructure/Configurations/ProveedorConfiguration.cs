using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class ProveedorConfiguration : IEntityTypeConfiguration<Proveedor>
{
    public void Configure(EntityTypeBuilder<Proveedor> builder)
    {
        builder.ToTable("Tbl_Proveedores");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.Nit }).IsUnique();

        builder.Property(e => e.Nit).HasColumnName("Nit").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.Nombre).HasColumnName("Nombre").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.CreditoOContado).HasColumnName("Credito_o_Contado");
        builder.Property(e => e.DiasCredito).HasColumnName("Dias_Credito");
        builder.Property(e => e.Contacto).HasColumnName("Contacto").HasMaxLength(80).IsFixedLength();
        builder.Property(e => e.CorreoElectro).HasColumnName("correo_electro").HasMaxLength(80).IsFixedLength();
        builder.Property(e => e.Direccion).HasColumnName("direccion").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.Colonia).HasColumnName("Colonia").HasMaxLength(50).IsFixedLength();
        builder.Property(e => e.Apto).HasColumnName("Apto").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Zona).HasColumnName("zona").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.Ciudad).HasColumnName("ciudad").HasMaxLength(50).IsFixedLength();
        builder.Property(e => e.Telefono).HasColumnName("Telefono").HasMaxLength(30).IsFixedLength();
        builder.Property(e => e.Tarjeta).HasColumnName("Tarjeta").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.NumCasa).HasColumnName("Num_Casa").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.Municipio).HasColumnName("Municipio").HasMaxLength(40).IsFixedLength();
        builder.Property(e => e.Telefono1).HasColumnName("Telefono1").HasMaxLength(30).IsFixedLength();
        builder.Property(e => e.Tipo).HasColumnName("Tipo").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.LocalExtranjero).HasColumnName("Local_Extranjero").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.FechaUltMov).HasColumnName("Fecha_ult_Mov");
        builder.Property(e => e.RetieneIsr).HasColumnName("Retiene_ISR").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.FacturarA).HasColumnName("Facturar_a").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.TipoPrecio).HasColumnName("Tipo_Precio").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.PorcentajeDescuento).HasColumnName("Porcentaje_descuento");
        builder.Property(e => e.Identificacion).HasColumnName("Identificacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.FechaUltMovProv).HasColumnName("Fecha_Ult_Mov_Prov");
        builder.Property(e => e.IdConceptoServicio).HasColumnName("Id_Concepto_servicio").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.TipoIva).HasColumnName("Tipo_Iva");
        builder.Property(e => e.IdCuentaCxp).HasColumnName("Id_Cuenta_cxp").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Clasificacion).HasColumnName("clasificacion").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.PagaIva).HasColumnName("Paga_iva");
        builder.Property(e => e.LimiteCreditoCliente).HasColumnName("Limite_credito_cliente").HasPrecision(18, 2);
        builder.Property(e => e.EsAgenteRetenedorIva).HasColumnName("Es_agente_retenedor_iva");
        builder.Property(e => e.TieneExencionIva).HasColumnName("Tiene_exencion_iva");
        builder.Property(e => e.TipoAgenteRetenedorIva).HasColumnName("Tipo_agente_retenedor_iva").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.PorcentajeAgenteRetendorIva).HasColumnName("Porcentaje_agente_retendor_iva").HasPrecision(18, 2);
        builder.Property(e => e.IdGrupoCliente).HasColumnName("Id_grupo_cliente").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.TipoPoliticaCredito).HasColumnName("Tipo_politica_credito");
        builder.Property(e => e.RegimenContribyente).HasColumnName("regimen_contribyente");
        builder.Property(e => e.Beneficiario).HasColumnName("beneficiario").HasMaxLength(200);

        builder.HasMany(e => e.Vehiculos)
               .WithOne()
               .HasForeignKey(v => v.Nit)
               .HasPrincipalKey(p => p.Nit)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(e => e.OrdenesServicio)
               .WithOne(os => os.Proveedor)
               .HasForeignKey(os => os.ProveedorId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(e => e.Presupuestos)
               .WithOne(p => p.Proveedor)
               .HasForeignKey(p => p.ProveedorId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
