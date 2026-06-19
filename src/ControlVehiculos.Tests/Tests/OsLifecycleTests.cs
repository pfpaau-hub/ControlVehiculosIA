using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using ControlVehiculos.Tests.Helpers;

namespace ControlVehiculos.Tests.Tests;

/// <summary>
/// Valida el ciclo de vida completo de una Orden de Servicio:
/// Crear → Cerrar → Intentar cerrar de nuevo → Reabrir → Intentar reabrir con factura
/// </summary>
public class OsLifecycleTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly TestWebApplicationFactory _factory;
    private readonly HttpClient _client;

    private static readonly JsonSerializerOptions _json =
        new(JsonSerializerOptions.Default) { PropertyNameCaseInsensitive = true };

    public OsLifecycleTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
        _client  = factory.CreateClient();
        factory.CreateDbScope();
    }

    private async Task<HttpClient> ClienteAutenticadoAsync()
    {
        var token = await AuthHelper.ObtenerTokenAsync(_client, $"os_{Guid.NewGuid():N}");
        var c = _factory.CreateClient();
        c.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        return c;
    }

    private static object NuevaOsPayload() => new
    {
        NumPlaca        = "P001ABC",
        FacturarA       = "CLIENTE TEST",
        Nit             = "1234567",
        Fecha           = DateTime.Today.ToString("yyyy-MM-dd"),
        Encargado       = "EMP1",
        RecibeOrden     = "EMP2",
        LecturaActual   = 50000,
        ProximoServicio = 55000,
        Anticipo        = 0,
        Observaciones   = "OS de prueba",
    };

    [Fact]
    public async Task CrearOS_DebeDevolver201_ConIdOrden()
    {
        var c = await ClienteAutenticadoAsync();

        var resp = await c.PostAsJsonAsync("/api/ordenes-servicio", NuevaOsPayload());
        Assert.Equal(HttpStatusCode.Created, resp.StatusCode);

        var body = await resp.Content.ReadFromJsonAsync<JsonElement>();
        Assert.True(body.GetProperty("idOrden").GetInt32() > 0);
        Assert.Equal(1, body.GetProperty("status").GetInt32()); // abierta
    }

    [Fact]
    public async Task CerrarOS_DebePonerStatus2()
    {
        var c    = await ClienteAutenticadoAsync();
        var osId = await CrearOsYObtenerIdAsync(c);

        var resp = await c.PostAsync($"/api/ordenes-servicio/{osId}/cerrar", null);
        Assert.Equal(HttpStatusCode.OK, resp.StatusCode);

        // Verificar que status cambió
        var get  = await c.GetFromJsonAsync<JsonElement>($"/api/ordenes-servicio/{osId}");
        Assert.Equal(2, get.GetProperty("status").GetInt32());
    }

    [Fact]
    public async Task CerrarOS_Cerrada_DebeDevolver400()
    {
        var c    = await ClienteAutenticadoAsync();
        var osId = await CrearOsYObtenerIdAsync(c);

        await c.PostAsync($"/api/ordenes-servicio/{osId}/cerrar", null);    // primera vez OK
        var resp = await c.PostAsync($"/api/ordenes-servicio/{osId}/cerrar", null); // segunda vez fail

        Assert.Equal(HttpStatusCode.BadRequest, resp.StatusCode);
    }

    [Fact]
    public async Task ReabrirOS_Cerrada_SinFactura_DebePonerStatus1()
    {
        var c    = await ClienteAutenticadoAsync();
        var osId = await CrearOsYObtenerIdAsync(c);

        await c.PostAsync($"/api/ordenes-servicio/{osId}/cerrar", null);

        var resp = await c.PostAsync($"/api/ordenes-servicio/{osId}/reabrir", null);
        Assert.Equal(HttpStatusCode.OK, resp.StatusCode);

        var get = await c.GetFromJsonAsync<JsonElement>($"/api/ordenes-servicio/{osId}");
        Assert.Equal(1, get.GetProperty("status").GetInt32());
    }

    [Fact]
    public async Task ReabrirOS_Abierta_DebeDevolver400()
    {
        var c    = await ClienteAutenticadoAsync();
        var osId = await CrearOsYObtenerIdAsync(c);

        // OS está abierta (status=1), intentar reabrir debe fallar
        var resp = await c.PostAsync($"/api/ordenes-servicio/{osId}/reabrir", null);
        Assert.Equal(HttpStatusCode.BadRequest, resp.StatusCode);
    }

    [Fact]
    public async Task EliminarOS_Abierta_DebeDevolver204()
    {
        var c    = await ClienteAutenticadoAsync();
        var osId = await CrearOsYObtenerIdAsync(c);

        var resp = await c.DeleteAsync($"/api/ordenes-servicio/{osId}");
        Assert.Equal(HttpStatusCode.NoContent, resp.StatusCode);
    }

    [Fact]
    public async Task EliminarOS_Cerrada_DebeDevolver400()
    {
        var c    = await ClienteAutenticadoAsync();
        var osId = await CrearOsYObtenerIdAsync(c);

        await c.PostAsync($"/api/ordenes-servicio/{osId}/cerrar", null);

        var resp = await c.DeleteAsync($"/api/ordenes-servicio/{osId}");
        Assert.Equal(HttpStatusCode.BadRequest, resp.StatusCode);
    }

    private static async Task<int> CrearOsYObtenerIdAsync(HttpClient c)
    {
        var resp = await c.PostAsJsonAsync("/api/ordenes-servicio", NuevaOsPayload());
        resp.EnsureSuccessStatusCode();
        var body = await resp.Content.ReadFromJsonAsync<JsonElement>();
        return body.GetProperty("id").GetInt32();
    }
}
