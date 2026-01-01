using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ServiceController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IWebHostEnvironment _env;

        public ServiceController(AppDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        // ===============================
        // GET: api/service
        // ===============================
        [HttpGet]
        public async Task<IActionResult> GetServices()
        {
            var services = await _context.Services.ToListAsync();
            return Ok(services);
        }

        // ===============================
        // POST: api/service
        // ===============================
        [HttpPost]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> CreateService([FromForm] ServiceCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (string.IsNullOrEmpty(_env.WebRootPath))
                return StatusCode(500, "wwwroot folder missing");

            string? imagePath = null;

            if (dto.Image != null)
            {
                string uploadsFolder = Path.Combine(_env.WebRootPath, "service-images");
                Directory.CreateDirectory(uploadsFolder);

                string fileName = Guid.NewGuid() + Path.GetExtension(dto.Image.FileName);
                string filePath = Path.Combine(uploadsFolder, fileName);

                using var stream = new FileStream(filePath, FileMode.Create);
                await dto.Image.CopyToAsync(stream);

                imagePath = "/service-images/" + fileName;
            }

            var service = new Service
            {
                ServiceName = dto.ServiceName,
                Category = dto.Category,
                Price = dto.Price,
                ImageUrl = imagePath
            };

            _context.Services.Add(service);
            await _context.SaveChangesAsync();

            return Ok(service);
        }

        // ===============================
        // PUT: api/service/{id}
        // ===============================
        [HttpPut("{id}")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UpdateService(int id, [FromForm] ServiceCreateDto dto)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null)
                return NotFound("Service not found");

            service.ServiceName = dto.ServiceName;
            service.Category = dto.Category;
            service.Price = dto.Price;

            if (dto.Image != null)
            {
                string uploadsFolder = Path.Combine(_env.WebRootPath, "service-images");
                Directory.CreateDirectory(uploadsFolder);

                string fileName = Guid.NewGuid() + Path.GetExtension(dto.Image.FileName);
                string filePath = Path.Combine(uploadsFolder, fileName);

                using var stream = new FileStream(filePath, FileMode.Create);
                await dto.Image.CopyToAsync(stream);

                service.ImageUrl = "/service-images/" + fileName;
            }

            await _context.SaveChangesAsync();
            return Ok(service);
        }

        // ===============================
        // DELETE: api/service/{id}
        // ===============================
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteService(int id)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null)
                return NotFound("Service not found");

            _context.Services.Remove(service);
            await _context.SaveChangesAsync();

            return Ok("Deleted successfully");
        }
    }
}
