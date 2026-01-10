using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/application")]
    public class ApplicationController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ApplicationController(AppDbContext context)
        {
            _context = context;
        }

        // =====================================================
        // WORKER: APPLY FOR A SERVICE
        // =====================================================
        [HttpPost("apply/{serviceId}")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> ApplyForService(int serviceId)
        {
            var workerIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (workerIdStr == null) return Unauthorized();

            int workerId = int.Parse(workerIdStr);

            var service = await _context.Services.FindAsync(serviceId);
            if (service == null) return NotFound("Service not found");

            bool alreadyApplied = await _context.Applications.AnyAsync(a =>
                a.ServiceId == serviceId && a.WorkerId == workerId);

            if (alreadyApplied)
                return BadRequest("You have already applied");

            var application = new Application
            {
                ServiceId = serviceId,
                WorkerId = workerId,
                VendorId = service.VendorId,
                Status = "Pending",
                PaymentStatus = "Pending",
                CreatedAt = DateTime.UtcNow
            };

            _context.Applications.Add(application);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Application submitted successfully" });
        }

        // =====================================================
        // WORKER: VIEW MY APPLICATIONS (🔥 FIXED)
        // =====================================================
        [HttpGet("worker")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> GetWorkerApplications()
        {
            var workerIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (workerIdStr == null) return Unauthorized();

            int workerId = int.Parse(workerIdStr);

            var applications = await _context.Applications
                .Where(a => a.WorkerId == workerId)
                .Include(a => a.Service)
                    .ThenInclude(s => s.Vendor)
                .OrderByDescending(a => a.CreatedAt)
                .Select(a => new
                {
                    a.Id,
                    a.Status,
                    a.CreatedAt,
                    a.PaymentStatus,

                    // ⭐ RATINGS
                    a.WorkerRated,
                    a.WorkerRating,
                    a.VendorRated,
                    a.VendorRating,

                    // ⭐ DISPLAY DATA
                    ServiceName = a.Service.ServiceName,
                    Category = a.Service.Category,
                    Price = a.Service.Price,
                    ServiceDateTime = a.Service.ServiceDateTime,
                    VendorName = a.Service.Vendor.Name
                })
                .ToListAsync();

            return Ok(applications);
        }

        // =====================================================
        // VENDOR: VIEW APPLICATIONS
        // =====================================================
        [HttpGet("vendor")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> GetVendorApplications()
        {
            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null) return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var applications = await _context.Applications
                .Where(a => a.VendorId == vendorId)
                .Include(a => a.Service)
                .Include(a => a.Worker)
                .OrderByDescending(a => a.CreatedAt)
                .Select(a => new
                {
                    a.Id,
                    a.Status,
                    a.CreatedAt,
                    a.PaymentStatus,

                    a.VendorRated,
                    a.VendorRating,

                    WorkerName = a.Worker.Name,
                    WorkerEmail = a.Worker.Email,
                    ServiceName = a.Service.ServiceName,
                    Price = a.Service.Price,
                    ServiceDateTime = a.Service.ServiceDateTime
                })
                .ToListAsync();

            return Ok(applications);
        }

        // =====================================================
        // WORKER: MARK COMPLETED
        // =====================================================
        [HttpPut("{id}/complete")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> MarkCompleted(int id)
        {
            var workerIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (workerIdStr == null) return Unauthorized();

            int workerId = int.Parse(workerIdStr);

            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound();

            if (app.WorkerId != workerId) return Forbid();
            if (app.Status != "Accepted") return BadRequest("Job not active");

            app.Status = "Completed";
            app.PaymentStatus = "Pending";

            await _context.SaveChangesAsync();
            return Ok();
        }

        // =====================================================
        // VENDOR: MARK PAID
        // =====================================================
        [HttpPut("{id}/pay")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> MarkPaid(int id)
        {
            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null) return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var app = await _context.Applications
                .Include(a => a.Service)
                .FirstOrDefaultAsync(a => a.Id == id);

            if (app == null) return NotFound();
            if (app.VendorId != vendorId) return Forbid();
            if (app.Status != "Completed") return BadRequest();

            app.PaymentStatus = "Paid";
            app.Service.Status = ServiceStatus.Completed;

            await _context.SaveChangesAsync();
            return Ok();
        }

        // =====================================================
        // VENDOR: RATE WORKER
        // =====================================================
        [HttpPost("{id}/rate-worker")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> RateWorker(int id, [FromQuery] int rating)
        {
            if (rating < 1 || rating > 5) return BadRequest();

            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound();
            if (app.PaymentStatus != "Paid") return BadRequest();
            if (app.VendorRated) return BadRequest();

            app.VendorRating = rating;
            app.VendorRated = true;

            await _context.SaveChangesAsync();
            return Ok();
        }

        // =====================================================
        // WORKER: RATE VENDOR
        // =====================================================
        [HttpPost("{id}/rate-vendor")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> RateVendor(int id, [FromQuery] int rating)
        {
            if (rating < 1 || rating > 5) return BadRequest();

            var app = await _context.Applications.FindAsync(id);

            if (app == null) return NotFound();
            if (app.PaymentStatus != "Paid") return BadRequest();
            if (app.WorkerRated) return BadRequest();

            app.WorkerRating = rating;
            app.WorkerRated = true;

            await _context.SaveChangesAsync();
            return Ok();
        }
    }
}
