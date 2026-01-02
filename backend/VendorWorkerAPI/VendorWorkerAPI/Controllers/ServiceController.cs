using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;

namespace VendorWorkerAPI.Controllers
{
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
                    CreatedAt = DateTime.SpecifyKind(s.CreatedAt, DateTimeKind.Utc)
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
            if (vendorId == null) return Unauthorized();

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
                    CreatedAt = DateTime.SpecifyKind(s.CreatedAt, DateTimeKind.Utc),
                    UpdatedAt = s.UpdatedAt == null
    ? (DateTime?)null
    : DateTime.SpecifyKind(s.UpdatedAt.Value, DateTimeKind.Utc)

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
                Category = dto.Category.ToString(), // ✅ enum → string
                Price = dto.Price,
                ImageUrl = imagePath,
                VendorId = vendorId,
                IsActive = true,
                CreatedAt = DateTime.UtcNow
            };

            _context.Services.Add(service);
            await _context.SaveChangesAsync();

            return Ok(service);
        }

        // ======================================
        // VENDOR: UPDATE SERVICE
        // ======================================
        [HttpPut("{id}")]
        [Authorize(Roles = "Vendor")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UpdateService(int id, [FromForm] ServiceCreateDto dto)
        {
            var vendorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorId == null) return Unauthorized();

            var service = await _context.Services.FindAsync(id);
            if (service == null) return NotFound();

            if (service.VendorId != vendorId) return Forbid();

            service.ServiceName = dto.ServiceName;
            service.Category = dto.Category.ToString(); // ✅ enum → string
            service.Price = dto.Price;
            service.UpdatedAt = DateTime.UtcNow;

            if (dto.Image != null)
            {
                var uploadsFolder = Path.Combine(_env.WebRootPath, "service-images");
                Directory.CreateDirectory(uploadsFolder);

                var fileName = Guid.NewGuid() + Path.GetExtension(dto.Image.FileName);
                var filePath = Path.Combine(uploadsFolder, fileName);

                using var stream = new FileStream(filePath, FileMode.Create);
                await dto.Image.CopyToAsync(stream);

                service.ImageUrl = "/service-images/" + fileName;
            }

            await _context.SaveChangesAsync();
            return Ok(service);
        }

        // ======================================
        // VENDOR: DELETE SERVICE
        // ======================================
        [HttpDelete("{id}")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> DeleteService(int id)
        {
            var vendorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorId == null) return Unauthorized();

            var service = await _context.Services.FindAsync(id);
            if (service == null) return NotFound();

            if (service.VendorId != vendorId) return Forbid();

            _context.Services.Remove(service);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Service deleted successfully" });
        }
    }
}
