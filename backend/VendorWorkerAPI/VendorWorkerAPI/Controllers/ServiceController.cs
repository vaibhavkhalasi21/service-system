using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
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

    // =====================================================
    // WORKER: VIEW PUBLIC SERVICES
    // =====================================================
    [HttpGet("public")]
    [AllowAnonymous]
    public async Task<IActionResult> GetPublicServices()
    {
        var services = await _context.Services
            .Where(s => s.IsActive)
            .Include(s => s.Vendor)
            .OrderByDescending(s => s.CreatedAt)
            .Select(s => new
            {
                s.Id,
                s.ServiceName,
                s.Category,
                s.Price,
                s.ImageUrl,
                VendorName = s.Vendor.Name,
                ServiceDateTime = s.ServiceDateTime,
                CreatedAt = s.CreatedAt
            })
            .ToListAsync();

        return Ok(services);
    }

    // =====================================================
    // VENDOR: VIEW MY SERVICES
    // =====================================================
    [HttpGet("vendor")]
    [Authorize(Roles = "Vendor")]
    public async Task<IActionResult> GetVendorServices()
    {
        var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (vendorIdStr == null) return Unauthorized();

        int vendorId = int.Parse(vendorIdStr);

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
                ServiceDateTime = s.ServiceDateTime,
                CreatedAt = s.CreatedAt,
                UpdatedAt = s.UpdatedAt
            })
            .ToListAsync();

        return Ok(services);
    }

    // =====================================================
    // VENDOR: CREATE SERVICE
    // =====================================================
    [HttpPost]
    [Authorize(Roles = "Vendor")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> CreateService([FromForm] ServiceCreateDto dto)
    {
        var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (vendorIdStr == null) return Unauthorized();

        int vendorId = int.Parse(vendorIdStr);

        string? imagePath = null;

        if (dto.Image != null)
        {
            var folder = Path.Combine(_env.WebRootPath, "service-images");
            Directory.CreateDirectory(folder);

            var fileName = Guid.NewGuid() + Path.GetExtension(dto.Image.FileName);
            var fullPath = Path.Combine(folder, fileName);

            using var stream = new FileStream(fullPath, FileMode.Create);
            await dto.Image.CopyToAsync(stream);

            imagePath = "/service-images/" + fileName;
        }

        var service = new Service
        {
            ServiceName = dto.ServiceName,
            Category = dto.Category.ToString(),
            Price = dto.Price,
            ImageUrl = imagePath,
            VendorId = vendorId,
            IsActive = true,
            ServiceDateTime = dto.ServiceDateTime,
            CreatedAt = DateTime.UtcNow
        };

        _context.Services.Add(service);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Service created successfully" });
    }

    // =====================================================
    // VENDOR: UPDATE SERVICE
    // =====================================================
    [HttpPut("{id}")]
    [Authorize(Roles = "Vendor")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> UpdateService(int id, [FromForm] ServiceCreateDto dto)
    {
        var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (vendorIdStr == null) return Unauthorized();

        int vendorId = int.Parse(vendorIdStr);

        var service = await _context.Services.FindAsync(id);
        if (service == null) return NotFound();

        if (service.VendorId != vendorId) return Forbid();

        if (dto.Image != null)
        {
            var folder = Path.Combine(_env.WebRootPath, "service-images");
            Directory.CreateDirectory(folder);

            var fileName = Guid.NewGuid() + Path.GetExtension(dto.Image.FileName);
            var fullPath = Path.Combine(folder, fileName);

            using var stream = new FileStream(fullPath, FileMode.Create);
            await dto.Image.CopyToAsync(stream);

            service.ImageUrl = "/service-images/" + fileName;
        }

        service.ServiceName = dto.ServiceName;
        service.Category = dto.Category.ToString();
        service.Price = dto.Price;
        service.ServiceDateTime = dto.ServiceDateTime;
        service.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return Ok(new { message = "Service updated successfully" });
    }

    // =====================================================
    // VENDOR: DELETE SERVICE
    // =====================================================
    [HttpDelete("{id}")]
    [Authorize(Roles = "Vendor")]
    public async Task<IActionResult> DeleteService(int id)
    {
        var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (vendorIdStr == null) return Unauthorized();

        int vendorId = int.Parse(vendorIdStr);

        var service = await _context.Services.FindAsync(id);
        if (service == null) return NotFound();

        if (service.VendorId != vendorId) return Forbid();

        _context.Services.Remove(service);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Service deleted successfully" });
    }
}
