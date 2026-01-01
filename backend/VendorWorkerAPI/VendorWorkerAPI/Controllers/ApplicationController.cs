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

        // ===================== GET ALL APPLICATIONS =====================
        [HttpGet]
        public async Task<IActionResult> GetApplications()
        {
            var applications = await _context.Applications
                .Include(a => a.Booking)
                .Include(a => a.Worker)
                .ToListAsync();

            return Ok(applications);
        }

        // ===================== GET APPLICATION BY ID =====================
        [HttpGet("{id}")]
        public async Task<IActionResult> GetApplication(int id)
        {
            if (id <= 0)
                return BadRequest("Invalid application id");

            var application = await _context.Applications
                .Include(a => a.Booking)
                .Include(a => a.Worker)
                .FirstOrDefaultAsync(a => a.ApplicationId == id);

            if (application == null)
                return NotFound("Application not found");

            return Ok(application);
        }

        // ===================== APPLY =====================
        [HttpPost]
        public async Task<IActionResult> Apply([FromBody] Application application)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Check Booking exists
            bool bookingExists = await _context.Bookings
                .AnyAsync(b => b.Id == application.BookingId);
            if (!bookingExists)
                return BadRequest("Invalid BookingId");

            // Check Worker exists
            bool workerExists = await _context.Workers
                .AnyAsync(w => w.Id == application.WorkerId);
            if (!workerExists)
                return BadRequest("Invalid WorkerId");

            // Prevent duplicate application
            bool alreadyApplied = await _context.Applications.AnyAsync(a =>
                a.BookingId == application.BookingId &&
                a.WorkerId == application.WorkerId);
            if (alreadyApplied)
                return BadRequest("Worker has already applied for this booking");

            application.Status = "Pending";
            application.AppliedDate = DateTime.UtcNow;

            _context.Applications.Add(application);
            await _context.SaveChangesAsync();

            return Ok("Application submitted successfully");
        }

        // ===================== UPDATE STATUS =====================
        [HttpPut("{id}/status")]
        public async Task<IActionResult> UpdateStatus(int id, [FromBody] string status)
        {
            if (id <= 0)
                return BadRequest("Invalid application id");

            if (string.IsNullOrEmpty(status))
                return BadRequest("Status is required");

            if (status != "Pending" && status != "Approved" && status != "Rejected")
                return BadRequest("Status must be Pending, Approved, or Rejected");

            var application = await _context.Applications.FindAsync(id);
            if (application == null)
                return NotFound("Application not found");

            application.Status = status;
            await _context.SaveChangesAsync();

            return Ok("Application status updated successfully");
        }

        // ===================== DELETE APPLICATION =====================
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteApplication(int id)
        {
            if (id <= 0)
                return BadRequest("Invalid application id");

            var application = await _context.Applications.FindAsync(id);
            if (application == null)
                return NotFound("Application not found");

            _context.Applications.Remove(application);
            await _context.SaveChangesAsync();

            return Ok("Application deleted successfully");
        }
    }
}