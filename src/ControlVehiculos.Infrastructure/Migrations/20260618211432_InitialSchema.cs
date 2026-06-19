using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ControlVehiculos.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialSchema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    IdEmpresa = table.Column<int>(type: "int", nullable: false),
                    Periodo = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IdCaja = table.Column<int>(type: "int", nullable: false),
                    UserName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "bit", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SecurityStamp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "bit", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "bit", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "datetimeoffset", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "bit", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "empresas",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Nombre_Empresa = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: true),
                    Porcentaje_Iva_Anterior = table.Column<int>(type: "int", nullable: true),
                    Porcentaje_iva = table.Column<int>(type: "int", nullable: true),
                    Periodo = table.Column<string>(type: "nchar(7)", fixedLength: true, maxLength: 7, nullable: true),
                    Lmodifica_Precios = table.Column<int>(type: "int", nullable: true),
                    Sig_Orden_Servicio = table.Column<int>(type: "int", nullable: true),
                    Porcentaje_Utilidad = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: true),
                    apartirde = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Id_Bodega_Facturacion = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    IdCuentaCxp = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    LmodificaCostos = table.Column<int>(type: "int", nullable: false),
                    TotalDetalleLineas = table.Column<int>(type: "int", nullable: false),
                    IdCuentaEfectivo = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    IdCuentaBanco = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    IdCuentaCredito = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    IdCuentaAnticipo = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    IdCuentaDebito = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    IdCuentaDebitoFiscal = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    Direccion = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Telefonos = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Fax = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Nit = table.Column<string>(type: "nvarchar(15)", maxLength: 15, nullable: true),
                    IdContrasena = table.Column<int>(type: "int", nullable: false),
                    IdCuentaAnticipoProveedores = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    IdCuentaCxc = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    IdCuentaVtas = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    IdDeptoVtas = table.Column<string>(type: "nvarchar(3)", maxLength: 3, nullable: false),
                    IdCuentaDepTransitoCxc = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    Sig_numero_presupuesto = table.Column<int>(type: "int", nullable: false),
                    PorcentajeUtilidadSobre = table.Column<int>(type: "int", nullable: true),
                    FacturaCon = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    NombreComercial = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    IdCuentaRebajaSventa = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    UsaOrdenDespacho = table.Column<int>(type: "int", nullable: false),
                    OperaConMoneda = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    Tasa_cambio = table.Column<decimal>(type: "decimal(18,5)", precision: 18, scale: 5, nullable: true),
                    IngresaFechaAlFacturar = table.Column<int>(type: "int", nullable: true),
                    FacturacionMultibodega = table.Column<int>(type: "int", nullable: true),
                    IdCuentaRetencionIvaClientes = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    FacturaEnBaseAplantillas = table.Column<int>(type: "int", nullable: true),
                    UtilizaCorrelativoContrasenaspago = table.Column<int>(type: "int", nullable: true),
                    DirectorioLogo = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: true),
                    PermiteExistenciaNegativa = table.Column<int>(type: "int", nullable: true),
                    IdPropina = table.Column<string>(type: "nvarchar(15)", maxLength: 15, nullable: true),
                    TipoOrdenAActualizar = table.Column<int>(type: "int", nullable: true),
                    OrdenEnvioPosFActura = table.Column<int>(type: "int", nullable: true),
                    MascaraCantidad = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    AgenteRetenedorIva = table.Column<int>(type: "int", nullable: true),
                    RegimenFiscalIsr = table.Column<string>(type: "nvarchar(15)", maxLength: 15, nullable: true),
                    IdCuentaRetencionIsrClientes = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    TipoColaOrdenes = table.Column<int>(type: "int", nullable: true),
                    TipoCorrelOrden = table.Column<int>(type: "int", nullable: true),
                    ImprimeCopia = table.Column<bool>(type: "bit", nullable: false),
                    NumeroOrdenCompra = table.Column<string>(type: "nvarchar(15)", maxLength: 15, nullable: true),
                    CorrelativoComanda = table.Column<int>(type: "int", nullable: false),
                    FechaSistema = table.Column<DateTime>(type: "datetime2", nullable: true),
                    FormatoOcompra = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_empresas", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Bancos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Banco = table.Column<string>(type: "nchar(2)", fixedLength: true, maxLength: 2, nullable: false),
                    Nombre = table.Column<string>(type: "nchar(60)", fixedLength: true, maxLength: 60, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Bancos", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_bodega",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Bodega = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Nombre = table.Column<string>(type: "nchar(60)", fixedLength: true, maxLength: 60, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_bodega", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Cajas",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Caja = table.Column<int>(type: "int", nullable: false),
                    Observaciones = table.Column<string>(type: "nchar(50)", fixedLength: true, maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Cajas", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Cajeros",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Cajero = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Nombre = table.Column<string>(type: "nchar(50)", fixedLength: true, maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Cajeros", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Casas_Credito",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Casa = table.Column<string>(type: "nchar(2)", fixedLength: true, maxLength: 2, nullable: false),
                    Nombre = table.Column<string>(type: "nchar(60)", fixedLength: true, maxLength: 60, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Casas_Credito", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_colores",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Color = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    uno = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_colores", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Marcas",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Marca = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Marcas", x => x.Id);
                    table.UniqueConstraint("AK_Tbl_Marcas_Id_Empresa_Id_Marca", x => new { x.Id_Empresa, x.Id_Marca });
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Productos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Producto = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Descripcion = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: true),
                    Codigo_Barras = table.Column<string>(type: "nchar(18)", fixedLength: true, maxLength: 18, nullable: true),
                    Costo_Promedio = table.Column<decimal>(type: "decimal(12,5)", precision: 12, scale: 5, nullable: false),
                    Tipo = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: true),
                    Propiedad1 = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Propiedad2 = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Propiedad3 = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Propiedad4 = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    propiedad5 = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    propiedad6 = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Cantidad_Equivalente = table.Column<decimal>(type: "decimal(12,4)", precision: 12, scale: 4, nullable: true),
                    Id_Articulo = table.Column<string>(type: "nchar(5)", fixedLength: true, maxLength: 5, nullable: false),
                    Id_medida = table.Column<string>(type: "nchar(3)", fixedLength: true, maxLength: 3, nullable: false),
                    Id_medida1 = table.Column<string>(type: "nchar(3)", fixedLength: true, maxLength: 3, nullable: false),
                    Fecha_Alta = table.Column<DateTime>(type: "datetime2", nullable: true),
                    fotoproducto = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    minimo = table.Column<int>(type: "int", nullable: true),
                    maximo = table.Column<int>(type: "int", nullable: true),
                    Id_Depto = table.Column<string>(type: "nchar(3)", fixedLength: true, maxLength: 3, nullable: false),
                    Id_Linea = table.Column<string>(type: "nchar(2)", fixedLength: true, maxLength: 2, nullable: true),
                    Descripcion_Corta = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    ultimo_costo = table.Column<decimal>(type: "decimal(18,5)", precision: 18, scale: 5, nullable: true),
                    Precioa = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: true),
                    Preciob = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: true),
                    Precioc = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: true),
                    Fecha_Ult_Mov = table.Column<DateTime>(type: "datetime2", nullable: true),
                    usa_sub_productos = table.Column<string>(type: "nchar(1)", fixedLength: true, maxLength: 1, nullable: true),
                    Es_servicio = table.Column<int>(type: "int", nullable: false),
                    Aplicar_Descuento = table.Column<int>(type: "int", nullable: true),
                    Porcentaje_Utilidad = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Precio_sugerido = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Usuario = table.Column<string>(type: "nchar(80)", fixedLength: true, maxLength: 80, nullable: false),
                    Fecha_hora = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ubicacion = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Porc_Max_descuento = table.Column<decimal>(type: "decimal(5,2)", precision: 5, scale: 2, nullable: true),
                    estado = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: true),
                    Permite_modificar_precio = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Productos", x => x.Id);
                    table.UniqueConstraint("AK_Tbl_Productos_Id_Empresa_Id_Producto", x => new { x.Id_Empresa, x.Id_Producto });
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Proveedores",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Nit = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Nombre = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Credito_o_Contado = table.Column<int>(type: "int", nullable: false),
                    Dias_Credito = table.Column<int>(type: "int", nullable: false),
                    Contacto = table.Column<string>(type: "nchar(80)", fixedLength: true, maxLength: 80, nullable: false),
                    correo_electro = table.Column<string>(type: "nchar(80)", fixedLength: true, maxLength: 80, nullable: false),
                    direccion = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Colonia = table.Column<string>(type: "nchar(50)", fixedLength: true, maxLength: 50, nullable: false),
                    Apto = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    zona = table.Column<string>(type: "nchar(2)", fixedLength: true, maxLength: 2, nullable: false),
                    ciudad = table.Column<string>(type: "nchar(50)", fixedLength: true, maxLength: 50, nullable: false),
                    Telefono = table.Column<string>(type: "nchar(30)", fixedLength: true, maxLength: 30, nullable: false),
                    Tarjeta = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Num_Casa = table.Column<string>(type: "nchar(5)", fixedLength: true, maxLength: 5, nullable: false),
                    Municipio = table.Column<string>(type: "nchar(40)", fixedLength: true, maxLength: 40, nullable: false),
                    Telefono1 = table.Column<string>(type: "nchar(30)", fixedLength: true, maxLength: 30, nullable: false),
                    Tipo = table.Column<string>(type: "nchar(1)", fixedLength: true, maxLength: 1, nullable: false),
                    Local_Extranjero = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Fecha_ult_Mov = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Retiene_ISR = table.Column<string>(type: "nchar(2)", fixedLength: true, maxLength: 2, nullable: false),
                    Facturar_a = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Tipo_Precio = table.Column<string>(type: "nchar(1)", fixedLength: true, maxLength: 1, nullable: false),
                    Porcentaje_descuento = table.Column<int>(type: "int", nullable: false),
                    Identificacion = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Fecha_Ult_Mov_Prov = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Id_Concepto_servicio = table.Column<string>(type: "nchar(2)", fixedLength: true, maxLength: 2, nullable: false),
                    Tipo_Iva = table.Column<int>(type: "int", nullable: false),
                    Id_Cuenta_cxp = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    clasificacion = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Paga_iva = table.Column<int>(type: "int", nullable: false),
                    Limite_credito_cliente = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Es_agente_retenedor_iva = table.Column<int>(type: "int", nullable: true),
                    Tiene_exencion_iva = table.Column<int>(type: "int", nullable: true),
                    Tipo_agente_retenedor_iva = table.Column<string>(type: "nchar(2)", fixedLength: true, maxLength: 2, nullable: true),
                    Porcentaje_agente_retendor_iva = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: true),
                    Id_grupo_cliente = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: true),
                    Tipo_politica_credito = table.Column<int>(type: "int", nullable: false),
                    regimen_contribyente = table.Column<int>(type: "int", nullable: true),
                    beneficiario = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Proveedores", x => x.Id);
                    table.UniqueConstraint("AK_Tbl_Proveedores_Nit", x => x.Nit);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Series",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Autorizacion = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Serie = table.Column<string>(type: "nchar(5)", fixedLength: true, maxLength: 5, nullable: false),
                    Id_Tipo = table.Column<string>(type: "nchar(3)", fixedLength: true, maxLength: 3, nullable: false),
                    Del = table.Column<int>(type: "int", nullable: false),
                    Al = table.Column<int>(type: "int", nullable: false),
                    Actual = table.Column<int>(type: "int", nullable: false),
                    Fecha_Ingreso = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Descripcion = table.Column<string>(type: "nchar(30)", fixedLength: true, maxLength: 30, nullable: false),
                    Fecha_hora = table.Column<DateTime>(type: "datetime2", nullable: false),
                    status = table.Column<int>(type: "int", nullable: false),
                    Numero_Anios = table.Column<int>(type: "int", nullable: true),
                    Fecha_vencimiento = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Porcentaje_consumo = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Series", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Tipo_Vehiculos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Tipo = table.Column<string>(type: "nchar(25)", fixedLength: true, maxLength: 25, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Tipo_Vehiculos", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Vendedores",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Empleado = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Nombre = table.Column<string>(type: "nchar(80)", fixedLength: true, maxLength: 80, nullable: false),
                    porc_comision = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    status = table.Column<string>(type: "nchar(1)", fixedLength: true, maxLength: 1, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Vendedores", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RoleId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ProviderKey = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    RoleId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    LoginProvider = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Value = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Linea_Vehiculo",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Marca = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Id_Linea = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Linea_Vehiculo", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tbl_Linea_Vehiculo_Tbl_Marcas_Id_Empresa_Id_Marca",
                        columns: x => new { x.Id_Empresa, x.Id_Marca },
                        principalTable: "Tbl_Marcas",
                        principalColumns: new[] { "Id_Empresa", "Id_Marca" },
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_insumos_servicios",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_empresa = table.Column<int>(type: "int", nullable: false),
                    Id_producto = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Id_Producto1 = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Costo = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Cantidad = table.Column<decimal>(type: "decimal(18,0)", precision: 18, scale: 0, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_insumos_servicios", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tbl_insumos_servicios_Tbl_Productos_Id_empresa_Id_Producto1",
                        columns: x => new { x.Id_empresa, x.Id_Producto1 },
                        principalTable: "Tbl_Productos",
                        principalColumns: new[] { "Id_Empresa", "Id_Producto" },
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Tbl_insumos_servicios_Tbl_Productos_Id_empresa_Id_producto",
                        columns: x => new { x.Id_empresa, x.Id_producto },
                        principalTable: "Tbl_Productos",
                        principalColumns: new[] { "Id_Empresa", "Id_Producto" },
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "tbl_productos_comisiones",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Producto = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Tipo_comision = table.Column<int>(type: "int", nullable: false),
                    Valor_comision = table.Column<decimal>(type: "decimal(12,2)", precision: 12, scale: 2, nullable: false),
                    Porcentaje_comision = table.Column<decimal>(type: "decimal(12,2)", precision: 12, scale: 2, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tbl_productos_comisiones", x => x.Id);
                    table.ForeignKey(
                        name: "FK_tbl_productos_comisiones_Tbl_Productos_Id_Empresa_Id_Producto",
                        columns: x => new { x.Id_Empresa, x.Id_Producto },
                        principalTable: "Tbl_Productos",
                        principalColumns: new[] { "Id_Empresa", "Id_Producto" },
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Vehiculos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Num_Placa = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Color = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Tipo = table.Column<string>(type: "nchar(25)", fixedLength: true, maxLength: 25, nullable: false),
                    Marca = table.Column<string>(type: "nchar(25)", fixedLength: true, maxLength: 25, nullable: false),
                    Linea = table.Column<string>(type: "nchar(25)", fixedLength: true, maxLength: 25, nullable: false),
                    Modelo = table.Column<string>(type: "nchar(4)", fixedLength: true, maxLength: 4, nullable: false),
                    Puertas = table.Column<string>(type: "nchar(1)", fixedLength: true, maxLength: 1, nullable: false),
                    Cilindros = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    motor = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Unidad_Medida = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Presion_Llantas = table.Column<int>(type: "int", nullable: false),
                    combustible = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    servicio_cada = table.Column<int>(type: "int", nullable: false),
                    nit = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Fecha_Ult_Mov = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Vehiculos", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tbl_Vehiculos_Tbl_Proveedores_nit",
                        column: x => x.nit,
                        principalTable: "Tbl_Proveedores",
                        principalColumn: "Nit",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Orden_Servicio",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Orden = table.Column<int>(type: "int", nullable: false),
                    Num_Placa = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Facturar_a = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Observaciones = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Recibe_Orden = table.Column<string>(type: "nchar(4)", fixedLength: true, maxLength: 4, nullable: false),
                    Encargado = table.Column<string>(type: "nchar(4)", fixedLength: true, maxLength: 4, nullable: false),
                    Tarjeta = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Fecha = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    Nit = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Lectura_Actual = table.Column<int>(type: "int", nullable: false),
                    Proximo_Servicio = table.Column<int>(type: "int", nullable: false),
                    Fecha_Cierre = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Fecha_Facturacion = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Anticipo = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Autorizacion = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Serie = table.Column<string>(type: "nchar(5)", fixedLength: true, maxLength: 5, nullable: false),
                    tipo = table.Column<string>(type: "nchar(3)", fixedLength: true, maxLength: 3, nullable: false),
                    Numero = table.Column<decimal>(type: "decimal(10,0)", precision: 10, scale: 0, nullable: false),
                    ProveedorId = table.Column<int>(type: "int", nullable: true),
                    VehiculoId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Orden_Servicio", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tbl_Orden_Servicio_Tbl_Proveedores_ProveedorId",
                        column: x => x.ProveedorId,
                        principalTable: "Tbl_Proveedores",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Tbl_Orden_Servicio_Tbl_Vehiculos_VehiculoId",
                        column: x => x.VehiculoId,
                        principalTable: "Tbl_Vehiculos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Presupuesto_Orden_Servicio",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Orden = table.Column<int>(type: "int", nullable: false),
                    Num_Placa = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Facturar_a = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Observaciones = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Recibe_Orden = table.Column<string>(type: "nchar(4)", fixedLength: true, maxLength: 4, nullable: false),
                    Encargado = table.Column<string>(type: "nchar(4)", fixedLength: true, maxLength: 4, nullable: false),
                    Tarjeta = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Fecha = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    Nit = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Lectura_Actual = table.Column<int>(type: "int", nullable: false),
                    Proximo_Servicio = table.Column<int>(type: "int", nullable: false),
                    Fecha_Cierre = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Fecha_Facturacion = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Anticipo = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Autorizacion = table.Column<string>(type: "nchar(20)", fixedLength: true, maxLength: 20, nullable: false),
                    Serie = table.Column<string>(type: "nchar(5)", fixedLength: true, maxLength: 5, nullable: false),
                    tipo = table.Column<string>(type: "nchar(3)", fixedLength: true, maxLength: 3, nullable: false),
                    Numero = table.Column<decimal>(type: "decimal(10,0)", precision: 10, scale: 0, nullable: false),
                    ProveedorId = table.Column<int>(type: "int", nullable: true),
                    VehiculoId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Presupuesto_Orden_Servicio", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tbl_Presupuesto_Orden_Servicio_Tbl_Proveedores_ProveedorId",
                        column: x => x.ProveedorId,
                        principalTable: "Tbl_Proveedores",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Tbl_Presupuesto_Orden_Servicio_Tbl_Vehiculos_VehiculoId",
                        column: x => x.VehiculoId,
                        principalTable: "Tbl_Vehiculos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Orden_Servicio_Detalle",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Orden = table.Column<int>(type: "int", nullable: false),
                    Linea = table.Column<int>(type: "int", nullable: false),
                    Id_Servicio = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Descripcion = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Id_Empleado = table.Column<string>(type: "nchar(4)", fixedLength: true, maxLength: 4, nullable: false),
                    Fosa = table.Column<string>(type: "nchar(3)", fixedLength: true, maxLength: 3, nullable: false),
                    Precio = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    otros = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Total_Linea = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Cantidad = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Precio_Descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Total_Linea_Descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    otros_Descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    costo = table.Column<decimal>(type: "decimal(18,5)", precision: 18, scale: 5, nullable: false),
                    Valor_comision = table.Column<decimal>(type: "decimal(12,2)", precision: 12, scale: 2, nullable: false),
                    Porcentaje_comision = table.Column<decimal>(type: "decimal(12,2)", precision: 12, scale: 2, nullable: false),
                    OrdenServicioId = table.Column<int>(type: "int", nullable: true),
                    VendedorId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Orden_Servicio_Detalle", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tbl_Orden_Servicio_Detalle_Tbl_Orden_Servicio_OrdenServicioId",
                        column: x => x.OrdenServicioId,
                        principalTable: "Tbl_Orden_Servicio",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Tbl_Orden_Servicio_Detalle_Tbl_Vendedores_VendedorId",
                        column: x => x.VendedorId,
                        principalTable: "Tbl_Vendedores",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "tbl_presupuesto_orden_servicio_detalle",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Orden = table.Column<int>(type: "int", nullable: false),
                    Linea = table.Column<int>(type: "int", nullable: false),
                    Id_Servicio = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Descripcion = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Id_Empleado = table.Column<string>(type: "nchar(4)", fixedLength: true, maxLength: 4, nullable: false),
                    Fosa = table.Column<string>(type: "nchar(3)", fixedLength: true, maxLength: 3, nullable: false),
                    Precio = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    otros = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Total_Linea = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Cantidad = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Precio_Descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Total_Linea_Descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    otros_Descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    costo = table.Column<decimal>(type: "decimal(18,5)", precision: 18, scale: 5, nullable: false),
                    Valor_comision = table.Column<decimal>(type: "decimal(12,2)", precision: 12, scale: 2, nullable: false),
                    Porcentaje_comision = table.Column<decimal>(type: "decimal(12,2)", precision: 12, scale: 2, nullable: false),
                    Autorizado = table.Column<int>(type: "int", nullable: false),
                    PresupuestoId = table.Column<int>(type: "int", nullable: true),
                    VendedorId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tbl_presupuesto_orden_servicio_detalle", x => x.Id);
                    table.ForeignKey(
                        name: "FK_tbl_presupuesto_orden_servicio_detalle_Tbl_Presupuesto_Orden_Servicio_PresupuestoId",
                        column: x => x.PresupuestoId,
                        principalTable: "Tbl_Presupuesto_Orden_Servicio",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_tbl_presupuesto_orden_servicio_detalle_Tbl_Vendedores_VendedorId",
                        column: x => x.VendedorId,
                        principalTable: "Tbl_Vendedores",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Orden_Servicio_Detalle_Integracion",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Orden = table.Column<int>(type: "int", nullable: false),
                    Linea = table.Column<int>(type: "int", nullable: false),
                    Linea_det = table.Column<int>(type: "int", nullable: false),
                    Id_Producto = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Descripcion = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Cantidad = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Precio = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Id_Bodega = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Se_Cobra = table.Column<string>(type: "nchar(1)", fixedLength: true, maxLength: 1, nullable: false),
                    Total_Linea = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Precio_descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Total_Linea_descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Rebaja_Existencias = table.Column<int>(type: "int", nullable: false),
                    Costo = table.Column<decimal>(type: "decimal(18,5)", precision: 18, scale: 5, nullable: false),
                    Periodo = table.Column<string>(type: "nchar(7)", fixedLength: true, maxLength: 7, nullable: false),
                    fecha_hora = table.Column<DateTime>(type: "datetime2", nullable: true),
                    OrdenDetalleId = table.Column<int>(type: "int", nullable: true),
                    OrdenServicioId = table.Column<int>(type: "int", nullable: true),
                    BodegaId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Orden_Servicio_Detalle_Integracion", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tbl_Orden_Servicio_Detalle_Integracion_Tbl_Orden_Servicio_Detalle_OrdenDetalleId",
                        column: x => x.OrdenDetalleId,
                        principalTable: "Tbl_Orden_Servicio_Detalle",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Tbl_Orden_Servicio_Detalle_Integracion_Tbl_Orden_Servicio_OrdenServicioId",
                        column: x => x.OrdenServicioId,
                        principalTable: "Tbl_Orden_Servicio",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Tbl_Orden_Servicio_Detalle_Integracion_Tbl_bodega_BodegaId",
                        column: x => x.BodegaId,
                        principalTable: "Tbl_bodega",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Id_Empresa = table.Column<int>(type: "int", nullable: false),
                    Id_Orden = table.Column<int>(type: "int", nullable: false),
                    Linea = table.Column<int>(type: "int", nullable: false),
                    Linea_det = table.Column<int>(type: "int", nullable: false),
                    Id_Producto = table.Column<string>(type: "nchar(15)", fixedLength: true, maxLength: 15, nullable: false),
                    Descripcion = table.Column<string>(type: "nchar(100)", fixedLength: true, maxLength: 100, nullable: false),
                    Cantidad = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Precio = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Id_Bodega = table.Column<string>(type: "nchar(10)", fixedLength: true, maxLength: 10, nullable: false),
                    Se_Cobra = table.Column<string>(type: "nchar(1)", fixedLength: true, maxLength: 1, nullable: false),
                    Total_Linea = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Precio_descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Total_Linea_descuento = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Rebaja_Existencias = table.Column<int>(type: "int", nullable: false),
                    Costo = table.Column<decimal>(type: "decimal(18,5)", precision: 18, scale: 5, nullable: false),
                    Periodo = table.Column<string>(type: "nchar(7)", fixedLength: true, maxLength: 7, nullable: false),
                    fecha_hora = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Autorizado = table.Column<int>(type: "int", nullable: false),
                    PresupuestoDetalleId = table.Column<int>(type: "int", nullable: true),
                    PresupuestoId = table.Column<int>(type: "int", nullable: true),
                    BodegaId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion_Tbl_Presupuesto_Orden_Servicio_PresupuestoId",
                        column: x => x.PresupuestoId,
                        principalTable: "Tbl_Presupuesto_Orden_Servicio",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion_Tbl_bodega_BodegaId",
                        column: x => x.BodegaId,
                        principalTable: "Tbl_bodega",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion_tbl_presupuesto_orden_servicio_detalle_PresupuestoDetalleId",
                        column: x => x.PresupuestoDetalleId,
                        principalTable: "tbl_presupuesto_orden_servicio_detalle",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true,
                filter: "[NormalizedName] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true,
                filter: "[NormalizedUserName] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_empresas_Id_Empresa",
                table: "empresas",
                column: "Id_Empresa",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Bancos_Id_Empresa_Id_Banco",
                table: "Tbl_Bancos",
                columns: new[] { "Id_Empresa", "Id_Banco" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_bodega_Id_Empresa_Id_Bodega",
                table: "Tbl_bodega",
                columns: new[] { "Id_Empresa", "Id_Bodega" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Cajas_Id_Empresa_Id_Caja",
                table: "Tbl_Cajas",
                columns: new[] { "Id_Empresa", "Id_Caja" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Cajeros_Id_Empresa_Id_Cajero",
                table: "Tbl_Cajeros",
                columns: new[] { "Id_Empresa", "Id_Cajero" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Casas_Credito_Id_Empresa_Id_Casa",
                table: "Tbl_Casas_Credito",
                columns: new[] { "Id_Empresa", "Id_Casa" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_colores_Id_Empresa_Color",
                table: "Tbl_colores",
                columns: new[] { "Id_Empresa", "Color" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_insumos_servicios_Id_empresa_Id_producto_Id_Producto1",
                table: "Tbl_insumos_servicios",
                columns: new[] { "Id_empresa", "Id_producto", "Id_Producto1" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_insumos_servicios_Id_empresa_Id_Producto1",
                table: "Tbl_insumos_servicios",
                columns: new[] { "Id_empresa", "Id_Producto1" });

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Linea_Vehiculo_Id_Empresa_Id_Marca_Id_Linea",
                table: "Tbl_Linea_Vehiculo",
                columns: new[] { "Id_Empresa", "Id_Marca", "Id_Linea" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Marcas_Id_Empresa_Id_Marca",
                table: "Tbl_Marcas",
                columns: new[] { "Id_Empresa", "Id_Marca" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_Id_Empresa_Id_Orden",
                table: "Tbl_Orden_Servicio",
                columns: new[] { "Id_Empresa", "Id_Orden" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_ProveedorId",
                table: "Tbl_Orden_Servicio",
                column: "ProveedorId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_VehiculoId",
                table: "Tbl_Orden_Servicio",
                column: "VehiculoId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_Detalle_Id_Empresa_Id_Orden_Linea",
                table: "Tbl_Orden_Servicio_Detalle",
                columns: new[] { "Id_Empresa", "Id_Orden", "Linea" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_Detalle_OrdenServicioId",
                table: "Tbl_Orden_Servicio_Detalle",
                column: "OrdenServicioId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_Detalle_VendedorId",
                table: "Tbl_Orden_Servicio_Detalle",
                column: "VendedorId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_Detalle_Integracion_BodegaId",
                table: "Tbl_Orden_Servicio_Detalle_Integracion",
                column: "BodegaId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_Detalle_Integracion_Id_Empresa_Id_Orden_Linea_Linea_det",
                table: "Tbl_Orden_Servicio_Detalle_Integracion",
                columns: new[] { "Id_Empresa", "Id_Orden", "Linea", "Linea_det" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_Detalle_Integracion_OrdenDetalleId",
                table: "Tbl_Orden_Servicio_Detalle_Integracion",
                column: "OrdenDetalleId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Orden_Servicio_Detalle_Integracion_OrdenServicioId",
                table: "Tbl_Orden_Servicio_Detalle_Integracion",
                column: "OrdenServicioId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Presupuesto_Orden_Servicio_Id_Empresa_Id_Orden",
                table: "Tbl_Presupuesto_Orden_Servicio",
                columns: new[] { "Id_Empresa", "Id_Orden" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Presupuesto_Orden_Servicio_ProveedorId",
                table: "Tbl_Presupuesto_Orden_Servicio",
                column: "ProveedorId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Presupuesto_Orden_Servicio_VehiculoId",
                table: "Tbl_Presupuesto_Orden_Servicio",
                column: "VehiculoId");

            migrationBuilder.CreateIndex(
                name: "IX_tbl_presupuesto_orden_servicio_detalle_Id_Empresa_Id_Orden_Linea",
                table: "tbl_presupuesto_orden_servicio_detalle",
                columns: new[] { "Id_Empresa", "Id_Orden", "Linea" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_tbl_presupuesto_orden_servicio_detalle_PresupuestoId",
                table: "tbl_presupuesto_orden_servicio_detalle",
                column: "PresupuestoId");

            migrationBuilder.CreateIndex(
                name: "IX_tbl_presupuesto_orden_servicio_detalle_VendedorId",
                table: "tbl_presupuesto_orden_servicio_detalle",
                column: "VendedorId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion_BodegaId",
                table: "Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion",
                column: "BodegaId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion_Id_Empresa_Id_Orden_Linea_Linea_det",
                table: "Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion",
                columns: new[] { "Id_Empresa", "Id_Orden", "Linea", "Linea_det" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion_PresupuestoDetalleId",
                table: "Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion",
                column: "PresupuestoDetalleId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion_PresupuestoId",
                table: "Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion",
                column: "PresupuestoId");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Productos_Id_Empresa_Id_Producto",
                table: "Tbl_Productos",
                columns: new[] { "Id_Empresa", "Id_Producto" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_tbl_productos_comisiones_Id_Empresa_Id_Producto",
                table: "tbl_productos_comisiones",
                columns: new[] { "Id_Empresa", "Id_Producto" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Proveedores_Id_Empresa_Nit",
                table: "Tbl_Proveedores",
                columns: new[] { "Id_Empresa", "Nit" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Series_Id_Empresa_Autorizacion",
                table: "Tbl_Series",
                columns: new[] { "Id_Empresa", "Autorizacion" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Tipo_Vehiculos_Id_Empresa_Tipo",
                table: "Tbl_Tipo_Vehiculos",
                columns: new[] { "Id_Empresa", "Tipo" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Vehiculos_Id_Empresa_Num_Placa",
                table: "Tbl_Vehiculos",
                columns: new[] { "Id_Empresa", "Num_Placa" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Vehiculos_nit",
                table: "Tbl_Vehiculos",
                column: "nit");

            migrationBuilder.CreateIndex(
                name: "IX_Tbl_Vendedores_Id_Empresa_Id_Empleado",
                table: "Tbl_Vendedores",
                columns: new[] { "Id_Empresa", "Id_Empleado" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "empresas");

            migrationBuilder.DropTable(
                name: "Tbl_Bancos");

            migrationBuilder.DropTable(
                name: "Tbl_Cajas");

            migrationBuilder.DropTable(
                name: "Tbl_Cajeros");

            migrationBuilder.DropTable(
                name: "Tbl_Casas_Credito");

            migrationBuilder.DropTable(
                name: "Tbl_colores");

            migrationBuilder.DropTable(
                name: "Tbl_insumos_servicios");

            migrationBuilder.DropTable(
                name: "Tbl_Linea_Vehiculo");

            migrationBuilder.DropTable(
                name: "Tbl_Orden_Servicio_Detalle_Integracion");

            migrationBuilder.DropTable(
                name: "Tbl_Presupuesto_Orden_Servicio_Detalle_Integracion");

            migrationBuilder.DropTable(
                name: "tbl_productos_comisiones");

            migrationBuilder.DropTable(
                name: "Tbl_Series");

            migrationBuilder.DropTable(
                name: "Tbl_Tipo_Vehiculos");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "AspNetUsers");

            migrationBuilder.DropTable(
                name: "Tbl_Marcas");

            migrationBuilder.DropTable(
                name: "Tbl_Orden_Servicio_Detalle");

            migrationBuilder.DropTable(
                name: "Tbl_bodega");

            migrationBuilder.DropTable(
                name: "tbl_presupuesto_orden_servicio_detalle");

            migrationBuilder.DropTable(
                name: "Tbl_Productos");

            migrationBuilder.DropTable(
                name: "Tbl_Orden_Servicio");

            migrationBuilder.DropTable(
                name: "Tbl_Presupuesto_Orden_Servicio");

            migrationBuilder.DropTable(
                name: "Tbl_Vendedores");

            migrationBuilder.DropTable(
                name: "Tbl_Vehiculos");

            migrationBuilder.DropTable(
                name: "Tbl_Proveedores");
        }
    }
}
