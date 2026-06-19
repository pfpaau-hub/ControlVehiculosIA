using System.Net.Http.Json;
using System.Text.Json;

namespace ControlVehiculos.Tests.Helpers;

public static class AuthHelper
{
    private static readonly JsonSerializerOptions JsonOpts =
        new(JsonSerializerOptions.Default) { PropertyNameCaseInsensitive = true };

    /// <summary>
    /// Registra un usuario y devuelve el token JWT.
    /// Idempotente: si el usuario ya existe, hace login.
    /// </summary>
    public static async Task<string> ObtenerTokenAsync(
        HttpClient client,
        string userName = "admin_test",
        string password = "Test123!")
    {
        // Intentar registrar
        var registerResp = await client.PostAsJsonAsync("/api/auth/register", new
        {
            UserName  = userName,
            Email     = $"{userName}@test.local",
            Password  = password,
            IdEmpresa = 1,
            Periodo   = "06/2026",
            IdCaja    = 1,
        });

        // Hacer login (independientemente de si register funcionó)
        var loginResp = await client.PostAsJsonAsync("/api/auth/login", new
        {
            UserName = userName,
            Password = password,
        });

        loginResp.EnsureSuccessStatusCode();

        var body = await loginResp.Content.ReadFromJsonAsync<JsonElement>();
        return body.GetProperty("token").GetString()!;
    }
}
