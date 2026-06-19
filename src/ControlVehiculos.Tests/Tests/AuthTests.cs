using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using ControlVehiculos.Tests.Helpers;

namespace ControlVehiculos.Tests.Tests;

public class AuthTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly TestWebApplicationFactory _factory;
    private readonly HttpClient _client;

    public AuthTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
        _client  = factory.CreateClient();
        factory.CreateDbScope();
    }

    [Fact]
    public async Task Register_DebeCrearUsuario_Y_Devolver201()
    {
        var resp = await _client.PostAsJsonAsync("/api/auth/register", new
        {
            UserName  = $"user_{Guid.NewGuid():N}",
            Email     = "nuevo@test.local",
            Password  = "Test123!",
            IdEmpresa = 1,
            Periodo   = "06/2026",
            IdCaja    = 1,
        });

        Assert.Equal(HttpStatusCode.Created, resp.StatusCode);
    }

    [Fact]
    public async Task Login_ConCredencialesValidas_DebeDevolver200ConToken()
    {
        var userName = $"login_{Guid.NewGuid():N}";
        await _client.PostAsJsonAsync("/api/auth/register", new
        {
            UserName  = userName,
            Email     = $"{userName}@test.local",
            Password  = "Test123!",
            IdEmpresa = 1,
            Periodo   = "06/2026",
            IdCaja    = 1,
        });

        var resp = await _client.PostAsJsonAsync("/api/auth/login", new
        {
            UserName = userName,
            Password = "Test123!",
        });

        Assert.Equal(HttpStatusCode.OK, resp.StatusCode);

        var body = await resp.Content.ReadFromJsonAsync<JsonElement>();
        var token = body.GetProperty("token").GetString();
        Assert.False(string.IsNullOrWhiteSpace(token));
        Assert.Contains('.', token!);   // JWT tiene 3 segmentos separados por '.'
    }

    [Fact]
    public async Task Login_ConPasswordIncorrecta_DebeDevolver401()
    {
        var userName = $"wrong_{Guid.NewGuid():N}";
        await _client.PostAsJsonAsync("/api/auth/register", new
        {
            UserName  = userName,
            Email     = $"{userName}@test.local",
            Password  = "Test123!",
            IdEmpresa = 1,
            Periodo   = "06/2026",
            IdCaja    = 1,
        });

        var resp = await _client.PostAsJsonAsync("/api/auth/login", new
        {
            UserName = userName,
            Password = "Incorrecta99!",
        });

        Assert.Equal(HttpStatusCode.Unauthorized, resp.StatusCode);
    }

    [Fact]
    public async Task Me_SinToken_DebeDevolver401()
    {
        var resp = await _client.GetAsync("/api/auth/me");
        Assert.Equal(HttpStatusCode.Unauthorized, resp.StatusCode);
    }

    [Fact]
    public async Task Me_ConTokenValido_DebeDevolver200()
    {
        var token = await AuthHelper.ObtenerTokenAsync(_client, $"me_{Guid.NewGuid():N}");

        using var req = new HttpRequestMessage(HttpMethod.Get, "/api/auth/me");
        req.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);

        var resp = await _client.SendAsync(req);
        Assert.Equal(HttpStatusCode.OK, resp.StatusCode);
    }
}
