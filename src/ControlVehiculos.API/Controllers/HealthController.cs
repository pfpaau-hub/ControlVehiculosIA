using Microsoft.AspNetCore.Mvc;

namespace ControlVehiculos.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() =>
        Ok(new { status = "ok", timestamp = DateTime.UtcNow, version = "1.0.0" });
}
