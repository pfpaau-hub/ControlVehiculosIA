using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.DependencyInjection;
using ControlVehiculos.Infrastructure.Data;
using ControlVehiculos.Infrastructure.Entities;
using ControlVehiculos.Application.Common;

namespace ControlVehiculos.Tests;

/// <summary>
/// Reemplaza SQL Server por EF Core InMemory para tests de integración.
/// InMemory soporta BeginTransactionAsync (devuelve NullTransaction — no-op).
/// La DB se aísla por factory instance usando un GUID en el nombre.
/// </summary>
public class TestWebApplicationFactory : WebApplicationFactory<Program>
{
    // Nombre único por factory — evita que tests paralelos compartan datos
    private readonly string _dbName = $"TestDb_{Guid.NewGuid():N}";

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Test");

        builder.ConfigureServices(services =>
        {
            // 1. Remover DbContextOptions<AppDbContext>
            var dbOptsDescriptor = services.SingleOrDefault(d =>
                d.ServiceType == typeof(DbContextOptions<AppDbContext>));
            if (dbOptsDescriptor != null) services.Remove(dbOptsDescriptor);

            // 2. Remover IDbContextOptionsConfiguration<AppDbContext>
            //    (nuevo en EF Core 8+ — guarda el UseSqlServer lambda)
            var configType = typeof(IDbContextOptionsConfiguration<AppDbContext>);
            var configDescriptors = services.Where(d => d.ServiceType == configType).ToList();
            foreach (var d in configDescriptors) services.Remove(d);

            // 3. Remover IEmpresaContext real (usa HttpContext — no disponible en tests)
            var empresaDescriptor = services.SingleOrDefault(d =>
                d.ServiceType == typeof(IEmpresaContext));
            if (empresaDescriptor != null) services.Remove(empresaDescriptor);

            // 4. Registrar IEmpresaContext de test
            services.AddScoped<IEmpresaContext, TestEmpresaContext>();

            // 5. Registrar DbContext con InMemory (un nombre único por factory)
            // Suprimir TransactionIgnoredWarning: InMemory acepta BeginTransaction
            // pero es no-op — está bien para tests (no hay rollback real).
            services.AddDbContext<AppDbContext>(options =>
                options
                    .UseInMemoryDatabase(_dbName)
                    .ConfigureWarnings(w =>
                        w.Ignore(InMemoryEventId.TransactionIgnoredWarning)));
        });
    }

    /// <summary>
    /// Crea el esquema (EnsureCreated), seedea datos mínimos de empresa,
    /// y devuelve el scope para uso adicional del test.
    /// </summary>
    public IServiceScope CreateDbScope()
    {
        var scope = Services.CreateScope();
        var db    = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        db.Database.EnsureCreated();

        // Seed empresa 1 si no existe (necesaria para IdOrden/IdPresupuesto counters)
        if (!db.Empresas.IgnoreQueryFilters().Any(e => e.IdEmpresa == 1))
        {
            db.Empresas.Add(new Empresa
            {
                IdEmpresa            = 1,
                NombreEmpresa        = "Taller Test",
                SigOrdenServicio     = 1,
                SigNumeroPresupuesto = 1,
                TotalDetalleLineas   = 50,
            });
            db.SaveChanges();
        }

        return scope;
    }
}

public class TestEmpresaContext : IEmpresaContext
{
    public int IdEmpresa => 1;
    public string Periodo   => "06/2026";
    public int IdCaja       => 1;
}
