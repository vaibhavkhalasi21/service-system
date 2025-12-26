using Microsoft.AspNetCore.Mvc;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ServiceController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ServiceController(AppDbContext context)
        {
            _context = context;
        }

        // GET all services
        [HttpGet]
        public async Task<IActionResult> GetServices()
        {
            var services = await _context.Services.ToListAsync();
            return Ok(services);
        }

        // GET service by Id
        [HttpGet("{id}")]
        public async Task<IActionResult> GetService(int id)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null) return NotFound();
            return Ok(service);
        }

        // POST create service
        [HttpPost]
        public async Task<IActionResult> CreateService(Service service)
        {
            _context.Services.Add(service);
            await _context.SaveChangesAsync();
            return Ok(service);
        }

        // PUT update service
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateService(int id, Service updatedService)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null) return NotFound();

            service.ServiceName = updatedService.ServiceName;
            service.Price = updatedService.Price;

            await _context.SaveChangesAsync();
            return Ok(service);
        }

        // DELETE service
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteService(int id)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null) return NotFound();

            _context.Services.Remove(service);
            await _context.SaveChangesAsync();
            return Ok("Deleted successfully");
        }
    }
}