using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ApplicationController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ApplicationController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/application
        [HttpGet]
        public async Task<IActionResult> GetApplications()
        {
            var applications = await _context.Applications
                .Include(a => a.Booking)
                .Include(a => a.Worker)
                .ToListAsync();

            return Ok(applications);
        }

        // GET: api/application/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetApplication(int id)
        {
            var application = await _context.Applications
                .Include(a => a.Booking)
                .Include(a => a.Worker)
                .FirstOrDefaultAsync(a => a.ApplicationId == id);

            if (application == null)
                return NotFound("Application not found");

            return Ok(application);
        }

        // POST: api/application
        [HttpPost]
        public async Task<IActionResult> Apply(Application application)
        {
            _context.Applications.Add(application);
            await _context.SaveChangesAsync();

            return Ok("Application submitted successfully");
        }

        // PUT: api/application/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateStatus(int id, string status)
        {
            var application = await _context.Applications.FindAsync(id);

            if (application == null)
                return NotFound("Application not found");

            application.Status = status;
            await _context.SaveChangesAsync();

            return Ok("Application status updated");
        }

        // DELETE: api/application/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteApplication(int id)
        {
            var application = await _context.Applications.FindAsync(id);

            if (application == null)
                return NotFound("Application not found");

            _context.Applications.Remove(application);
            await _context.SaveChangesAsync();

            return Ok("Application deleted");
        }
    }
}