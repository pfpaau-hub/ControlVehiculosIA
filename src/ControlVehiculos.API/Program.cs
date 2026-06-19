using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using ControlVehiculos.Application.Common;
using ControlVehiculos.Infrastructure.Data;
using ControlVehiculos.Infrastructure.Entities;
using ControlVehiculos.API.Services;

var builder = WebApplication.CreateBuilder(args);

// ── Base de datos ──────────────────────────────────────────────────
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// ── ASP.NET Identity (UserManager/SignInManager sin cambiar el esquema de auth)
builder.Services.AddIdentityCore<AppUser>(options =>
    {
        options.Password.RequireDigit           = true;
        options.Password.RequiredLength         = 6;
        options.Password.RequireNonAlphanumeric = false;
        options.Password.RequireUppercase       = false;
        options.Lockout.MaxFailedAccessAttempts = 5;
        options.Lockout.DefaultLockoutTimeSpan  = TimeSpan.FromMinutes(15);
    })
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<AppDbContext>()
    .AddSignInManager()
    .AddDefaultTokenProviders();

// ── Contexto de empresa (multi-tenant via JWT) ─────────────────────
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<IEmpresaContext, HttpEmpresaContext>();
builder.Services.AddScoped<TokenService>();
builder.Services.AddScoped<PresupuestoService>();

// ── JWT Authentication ─────────────────────────────────────────────
var jwtKey = builder.Configuration["Jwt:Key"]
    ?? throw new InvalidOperationException("Jwt:Key no está configurado");

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer           = true,
            ValidateAudience         = true,
            ValidateLifetime         = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer              = builder.Configuration["Jwt:Issuer"],
            ValidAudience            = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey         = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

builder.Services.AddAuthorization();

// ── Controllers + Swagger ──────────────────────────────────────────
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title   = "ControlVehiculos API",
        Version = "v1",
        Description = "API para el sistema de gestión de taller automotriz"
    });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name         = "Authorization",
        Type         = SecuritySchemeType.ApiKey,
        Scheme       = "Bearer",
        BearerFormat = "JWT",
        In           = ParameterLocation.Header,
        Description  = "Ingrese: Bearer {token}"
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme { Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" } },
            Array.Empty<string>()
        }
    });
});

// ── CORS ──────────────────────────────────────────────────────────
var allowedOrigins = builder.Configuration
    .GetSection("Cors:AllowedOrigins").Get<string[]>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("DevPolicy", policy =>
        policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());

    if (allowedOrigins?.Length > 0)
    {
        options.AddPolicy("ProdPolicy", policy =>
            policy.WithOrigins(allowedOrigins).AllowAnyMethod().AllowAnyHeader());
    }
});

var app = builder.Build();

// ── Seed de datos mínimos para desarrollo ─────────────────────────
if (app.Environment.IsDevelopment())
{
    using var scope = app.Services.CreateScope();
    var db          = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    var userMgr     = scope.ServiceProvider.GetRequiredService<UserManager<AppUser>>();
    var roleMgr     = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();

    db.Database.EnsureCreated();

    if (!db.Empresas.Any())
    {
        db.Empresas.Add(new Empresa
        {
            IdEmpresa            = 1,
            NombreEmpresa        = "Taller Demo",
            SigOrdenServicio     = 1001,
            SigNumeroPresupuesto = 101,
            TotalDetalleLineas   = 50,
        });
        db.SaveChanges();
    }

    foreach (var role in new[] { "Admin", "Cajero", "Mecanico" })
        if (!await roleMgr.RoleExistsAsync(role))
            await roleMgr.CreateAsync(new IdentityRole(role));

    if (await userMgr.FindByNameAsync("admin") is null)
    {
        var admin = new AppUser
        {
            UserName  = "admin",
            Email     = "admin@taller.demo",
            IdEmpresa = 1,
        };
        await userMgr.CreateAsync(admin, "Admin123!");
        await userMgr.AddToRoleAsync(admin, "Admin");
    }
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseCors("DevPolicy");
}
else
{
    app.UseCors("ProdPolicy");
}

app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();

// Required for WebApplicationFactory in integration tests
public partial class Program { }
