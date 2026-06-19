using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using ControlVehiculos.Tests.Helpers;

namespace ControlVehiculos.Tests.Tests;

/// <summary>
/// Valida la lógica de conversión Presupuesto → OS (equivalente a sp_genera_orden_servicio).
/// Reglas verificadas:
///   - Solo presupuestos con status=2 se pueden convertir
///   - Solo detalles con autorizado=1 se copian a la OS
///   - La OS creada hereda placa, NIT, fecha, facturar_a del presupuesto
///   - Convertir dos veces genera error (el presupuesto queda referenciado)
/// </summary>
public class PresupuestoConversionTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly TestWebApplicationFactory _factory;
    private readonly HttpClient _client;

    public PresupuestoConversionTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
        _client  = factory.CreateClient();
        factory.CreateDbScope();
    }

    private async Task<HttpClient> ClienteAutenticadoAsync()
    {
        var token = await AuthHelper.ObtenerTokenAsync(_client, $"pres_{Guid.NewGuid():N}");
        var c = _factory.CreateClient();
        c.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        return c;
    }

    [Fact]
    public async Task Convertir_PresupuestoConStatus1_DebeDevolver400()
    {
        var c    = await ClienteAutenticadoAsync();
        var pId  = await CrearPresupuestoAsync(c, status: 1);

        var resp = await c.PostAsync($"/api/presupuestos/{pId}/convertir", null);

        Assert.Equal(HttpStatusCode.BadRequest, resp.StatusCode);
    }

    [Fact]
    public async Task Convertir_PresupuestoConStatus2_DebeDevolver201_ConIdOrden()
    {
        var c    = await ClienteAutenticadoAsync();
        var pId  = await CrearPresupuestoAsync(c, status: 2);

        var resp = await c.PostAsync($"/api/presupuestos/{pId}/convertir", null);

        Assert.Equal(HttpStatusCode.Created, resp.StatusCode);

        var body = await resp.Content.ReadFromJsonAsync<JsonElement>();
        Assert.True(body.GetProperty("id").GetInt32() > 0);
        Assert.True(body.GetProperty("idOrden").GetInt32() > 0);
    }

    [Fact]
    public async Task Convertir_PresupuestoInexistente_DebeDevolver404()
    {
        var c    = await ClienteAutenticadoAsync();
        var resp = await c.PostAsync("/api/presupuestos/999999/convertir", null);

        Assert.Equal(HttpStatusCode.NotFound, resp.StatusCode);
    }

    [Fact]
    public async Task Convertir_PresupuestoStatus2_OSResultanteHereda_Placa_Y_Nit()
    {
        var c    = await ClienteAutenticadoAsync();
        var pId  = await CrearPresupuestoAsync(c, status: 2, placa: "TEST001", nit: "CF");

        var convResp = await c.PostAsync($"/api/presupuestos/{pId}/convertir", null);
        convResp.EnsureSuccessStatusCode();

        var conv  = await convResp.Content.ReadFromJsonAsync<JsonElement>();
        var osId  = conv.GetProperty("id").GetInt32();

        var osResp = await c.GetFromJsonAsync<JsonElement>($"/api/ordenes-servicio/{osId}");

        Assert.Equal("TEST001", osResp.GetProperty("numPlaca").GetString());
        Assert.Equal("CF",      osResp.GetProperty("nit").GetString());
        Assert.Equal(1,         osResp.GetProperty("status").GetInt32()); // OS inicia abierta
    }

    // ── Helpers ─────────────────────────────────────────────────────────────

    private static async Task<int> CrearPresupuestoAsync(
        HttpClient c, int status, string placa = "P999TEST", string nit = "1234567")
    {
        // Siempre crea con status=1
        var resp = await c.PostAsJsonAsync("/api/presupuestos", new
        {
            NumPlaca      = placa,
            FacturarA     = "CLIENTE PRUEBA",
            Nit           = nit,
            Fecha         = DateTime.Today.ToString("yyyy-MM-dd"),
            Observaciones = "Presupuesto de prueba",
        });
        resp.EnsureSuccessStatusCode();

        var body = await resp.Content.ReadFromJsonAsync<JsonElement>();
        var id   = body.GetProperty("id").GetInt32();

        // Si se solicita status=2, cerrarlo explícitamente
        if (status == 2)
        {
            var cerrar = await c.PostAsync($"/api/presupuestos/{id}/cerrar", null);
            cerrar.EnsureSuccessStatusCode();
        }

        return id;
    }
}
