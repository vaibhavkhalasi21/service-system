using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;

[ApiController]
[Route("api/service")]
public class ServiceController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IWebHostEnvironment _env;

    public ServiceController(AppDbContext context, IWebHostEnvironment env)
    {
        _context = context;
        _env = env;
    }

    // ======================================
    // WORKER: VIEW ALL ACTIVE SERVICES
    // ======================================
    [HttpGet("public")]
    [AllowAnonymous]
    public async Task<IActionResult> GetPublicServices()
    {
        var services = await _context.Services
            .Where(s => s.IsActive)
            .OrderByDescending(s => s.CreatedAt)
            .Select(s => new
            {
                s.Id,
                s.ServiceName,
                s.Category,
                s.Price,
                s.ImageUrl,

                // 🔥 Vendor name via subquery
                VendorName = _context.Vendors
                    .Where(v => v.Id.ToString() == s.VendorId)
                    .Select(v => v.Name)
                    .FirstOrDefault(),

                ServiceDateTime = DateTime.SpecifyKind(
                    s.ServiceDateTime,
                    DateTimeKind.Utc
                ),

                CreatedAt = DateTime.SpecifyKind(
                    s.CreatedAt,
                    DateTimeKind.Utc
                )
            })
            .ToListAsync();

        return Ok(services);
    }

    // ======================================
    // VENDOR: VIEW MY SERVICES
    // ======================================
    [HttpGet("vendor")]
    [Authorize(Roles = "Vendor")]
    public async Task<IActionResult> GetVendorServices()
    {
        var vendorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (vendorId == null)
            return Unauthorized();

        var services = await _context.Services
            .Where(s => s.VendorId == vendorId)
            .OrderByDescending(s => s.CreatedAt)
            .Select(s => new
            {
                s.Id,
                s.ServiceName,
                s.Category,
                s.Price,
                s.ImageUrl,
                s.IsActive,

                VendorName = _context.Vendors
                    .Where(v => v.Id.ToString() == s.VendorId)
                    .Select(v => v.Name)
                    .FirstOrDefault(),

                ServiceDateTime = DateTime.SpecifyKind(
                    s.ServiceDateTime,
                    DateTimeKind.Utc
                ),

                CreatedAt = DateTime.SpecifyKind(
                    s.CreatedAt,
                    DateTimeKind.Utc
                ),

                UpdatedAt = s.UpdatedAt == null
                    ? (DateTime?)null
                    : DateTime.SpecifyKind(
                        s.UpdatedAt.Value,
                        DateTimeKind.Utc
                    )
            })
            .ToListAsync();

        return Ok(services);
    }

    // ======================================
    // VENDOR: CREATE SERVICE
    // ======================================
    [HttpPost]
    [Authorize(Roles = "Vendor")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> CreateService([FromForm] ServiceCreateDto dto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var vendorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (vendorId == null)
            return Unauthorized();

        string? imagePath = null;

        if (dto.Image != null)
        {
            var uploadsFolder = Path.Combine(_env.WebRootPath, "service-images");
            Directory.CreateDirectory(uploadsFolder);

            var fileName = Guid.NewGuid() + Path.GetExtension(dto.Image.FileName);
            var filePath = Path.Combine(uploadsFolder, fileName);

            using var stream = new FileStream(filePath, FileMode.Create);
            await dto.Image.CopyToAsync(stream);

            imagePath = "/service-images/" + fileName;
        }

        var service = new Service
        {
            ServiceName = dto.ServiceName,
            Category = dto.Category.ToString(),
            Price = dto.Price,
            ImageUrl = imagePath,
            VendorId = vendorId, // ✅ STRING
            IsActive = true,
            ServiceDateTime = DateTime.SpecifyKind(
                dto.ServiceDateTime,
                DateTimeKind.Utc
            ),
            CreatedAt = DateTime.UtcNow
        };

        _context.Services.Add(service);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Service created successfully" });
    }

    // ======================================
    // VENDOR: DELETE SERVICE
    // ======================================
    [HttpDelete("{id}")]
    [Authorize(Roles = "Vendor")]
    public async Task<IActionResult> DeleteService(int id)
    {
        var vendorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (vendorId == null)
            return Unauthorized();

        var service = await _context.Services.FindAsync(id);
        if (service == null)
            return NotFound("Service not found");

        if (service.VendorId != vendorId)
            return Forbid();

        _context.Services.Remove(service);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Service deleted successfully" });
    }
}
