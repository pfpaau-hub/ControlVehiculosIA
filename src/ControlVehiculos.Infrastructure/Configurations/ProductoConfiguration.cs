using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ControlVehiculos.Infrastructure.Entities;

namespace ControlVehiculos.Infrastructure.Configurations;

public class ProductoConfiguration : IEntityTypeConfiguration<Producto>
{
    public void Configure(EntityTypeBuilder<Producto> builder)
    {
        builder.ToTable("Tbl_Productos");
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Id).HasColumnName("Id").ValueGeneratedOnAdd();
        builder.Property(e => e.IdEmpresa).HasColumnName("Id_Empresa").IsRequired();

        builder.HasIndex(e => new { e.IdEmpresa, e.IdProducto }).IsUnique();

        builder.Property(e => e.IdProducto).HasColumnName("Id_Producto").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Descripcion).HasColumnName("Descripcion").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.CodigoBarras).HasColumnName("Codigo_Barras").HasMaxLength(18).IsFixedLength();
        builder.Property(e => e.CostoPromedio).HasColumnName("Costo_Promedio").HasPrecision(12, 5);
        builder.Property(e => e.Tipo).HasColumnName("Tipo").HasMaxLength(10).IsFixedLength();
        builder.Property(e => e.Propiedad1).HasColumnName("Propiedad1").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad2).HasColumnName("Propiedad2").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad3).HasColumnName("Propiedad3").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad4).HasColumnName("Propiedad4").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad5).HasColumnName("propiedad5").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.Propiedad6).HasColumnName("propiedad6").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.CantidadEquivalente).HasColumnName("Cantidad_Equivalente").HasPrecision(12, 4);
        builder.Property(e => e.IdArticulo).HasColumnName("Id_Articulo").HasMaxLength(5).IsFixedLength();
        builder.Property(e => e.IdMedida).HasColumnName("Id_medida").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.IdMedida1).HasColumnName("Id_medida1").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.FechaAlta).HasColumnName("Fecha_Alta");
        builder.Property(e => e.FotoProducto).HasColumnName("fotoproducto").HasMaxLength(200);
        builder.Property(e => e.Minimo).HasColumnName("minimo");
        builder.Property(e => e.Maximo).HasColumnName("maximo");
        builder.Property(e => e.IdDepto).HasColumnName("Id_Depto").HasMaxLength(3).IsFixedLength();
        builder.Property(e => e.IdLinea).HasColumnName("Id_Linea").HasMaxLength(2).IsFixedLength();
        builder.Property(e => e.DescripcionCorta).HasColumnName("Descripcion_Corta").HasMaxLength(100).IsFixedLength();
        builder.Property(e => e.UltimoCosto).HasColumnName("ultimo_costo").HasPrecision(18, 5);
        builder.Property(e => e.Precioa).HasColumnName("Precioa").HasPrecision(18, 2);
        builder.Property(e => e.Preciob).HasColumnName("Preciob").HasPrecision(18, 2);
        builder.Property(e => e.Precioc).HasColumnName("Precioc").HasPrecision(18, 2);
        builder.Property(e => e.FechaUltMov).HasColumnName("Fecha_Ult_Mov");
        builder.Property(e => e.UsaSubProductos).HasColumnName("usa_sub_productos").HasMaxLength(1).IsFixedLength();
        builder.Property(e => e.EsServicio).HasColumnName("Es_servicio");
        builder.Property(e => e.AplicarDescuento).HasColumnName("Aplicar_Descuento");
        builder.Property(e => e.PorcentajeUtilidad).HasColumnName("Porcentaje_Utilidad").HasPrecision(18, 2);
        builder.Property(e => e.PrecioSugerido).HasColumnName("Precio_sugerido").HasPrecision(18, 2);
        builder.Property(e => e.Usuario).HasColumnName("Usuario").HasMaxLength(80).IsFixedLength();
        builder.Property(e => e.FechaHora).HasColumnName("Fecha_hora");
        builder.Property(e => e.Ubicacion).HasColumnName("ubicacion").HasMaxLength(20).IsFixedLength();
        builder.Property(e => e.PorcMaxDescuento).HasColumnName("Porc_Max_descuento").HasPrecision(5, 2);
        builder.Property(e => e.Estado).HasColumnName("estado").HasMaxLength(15).IsFixedLength();
        builder.Property(e => e.PermiteModificarPrecio).HasColumnName("Permite_modificar_precio");

        builder.HasOne(e => e.Comision).WithOne(c => c.Producto)
               .HasForeignKey<ProductoComision>(c => new { c.IdEmpresa, c.IdProducto })
               .HasPrincipalKey<Producto>(p => new { p.IdEmpresa, p.IdProducto })
               .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(e => e.InsumosComoServicio)
               .WithOne(i => i.Servicio)
               .HasForeignKey(i => new { i.IdEmpresa, i.IdProducto })
               .HasPrincipalKey(p => new { p.IdEmpresa, p.IdProducto })
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(e => e.InsumosComoInsumo)
               .WithOne(i => i.Insumo)
               .HasForeignKey(i => new { i.IdEmpresa, i.IdProducto1 })
               .HasPrincipalKey(p => new { p.IdEmpresa, p.IdProducto })
               .OnDelete(DeleteBehavior.Restrict);
    }
}
