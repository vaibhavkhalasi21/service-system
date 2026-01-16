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
        // WORKER: APPLY FOR A SERVICE (UPDATED WITH LOCATION)
        // =====================================================
        [HttpPost("apply/{serviceId}")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> ApplyForService(
     int serviceId,
     [FromBody] ApplyServiceRequest request
 )
        {
            var workerIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (workerIdStr == null) return Unauthorized();

            int workerId = int.Parse(workerIdStr);

            var service = await _context.Services.FindAsync(serviceId);
            if (service == null) return NotFound("Service not found");

            bool alreadyApplied = await _context.Applications.AnyAsync(a =>
                a.ServiceId == serviceId && a.WorkerId == workerId);

            if (alreadyApplied)
                return BadRequest("You have already applied for this service");

            // 🔒 Validate locations
            if (request.ServiceLatitude == 0 || request.ServiceLongitude == 0)
                return BadRequest("Service location is required");

            if (request.WorkerLatitude == 0 || request.WorkerLongitude == 0)
                return BadRequest("Worker location is required");

            var application = new Application
            {
                ServiceId = serviceId,
                WorkerId = workerId,
                VendorId = service.VendorId,

                Status = "Pending",
                PaymentStatus = "Pending",
                CreatedAt = DateTime.UtcNow,

                // 📍 SERVICE LOCATION
                ServiceLatitude = request.ServiceLatitude,
                ServiceLongitude = request.ServiceLongitude,
                ServiceAddress = request.ServiceAddress,

                // 📍 WORKER LOCATION (NEW)
                WorkerLatitude = request.WorkerLatitude,
                WorkerLongitude = request.WorkerLongitude
            };

            _context.Applications.Add(application);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Application submitted successfully" });
        }


        // =====================================================
        // WORKER: VIEW MY APPLICATIONS
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
                    a.PaymentMethod,

                    a.WorkerRated,
                    a.WorkerRating,
                    a.VendorRated,
                    a.VendorRating,

                    ServiceName = a.Service.ServiceName,
                    Category = a.Service.Category,
                    Price = a.Service.Price,
                   
                    ServiceDateTime = a.Service.ServiceDateTime,
                    VendorName = a.Service.Vendor.Name,

                    // 📍 LOCATION
                    a.ServiceLatitude,
                    a.ServiceLongitude,
                    a.ServiceAddress
                })
                .ToListAsync();

            return Ok(applications);
        }

        // =====================================================
        // VENDOR: VIEW APPLICATIONS / JOBS (WITH LOCATION + ADDRESS)
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
                    // 🔑 IDs
                    a.Id,

                    // 🔄 STATUS
                    a.Status,
                    a.PaymentStatus,
                    a.PaymentMethod,

                    // 👤 WORKER
                    WorkerName = a.Worker.Name,
                    WorkerEmail = a.Worker.Email,

                    // 🛠 SERVICE (🔥 REQUIRED BY VENDOR JOB TAB)
                    ServiceName = a.Service.ServiceName,
                    Price = a.Service.Price,
                    ServiceDateTime = a.Service.ServiceDateTime,

                    // 📍 SERVICE LOCATION
                    a.ServiceLatitude,
                    a.ServiceLongitude,
                    a.ServiceAddress,

                    // 📍 WORKER LOCATION
                    a.WorkerLatitude,
                    a.WorkerLongitude,

                    // ⭐ RATINGS
                    a.VendorRated,
                    a.VendorRating
                })
                .ToListAsync();

            return Ok(applications);
        }
        // =====================================================
        // VENDOR: VIEW PENDING APPLICATIONS ONLY
        // =====================================================
        [HttpGet("vendor/applications")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> GetVendorApplicationRequests()
        {
            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null) return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var applications = await _context.Applications
                .Where(a => a.VendorId == vendorId && a.Status == "Pending")
                .Include(a => a.Service)
                .Include(a => a.Worker)
                .OrderByDescending(a => a.CreatedAt)
                .Select(a => new
                {
                    a.Id,
                    a.Status,
                    a.CreatedAt,

                    // 👤 WORKER
                    WorkerName = a.Worker.Name,
                    WorkerEmail = a.Worker.Email,

                    // 🛠 SERVICE
                    ServiceName = a.Service.ServiceName,
                    Category = a.Service.Category,

                    // 📍 LOCATIONS
                    a.WorkerLatitude,
                    a.WorkerLongitude,
                    a.ServiceLatitude,
                    a.ServiceLongitude,
                    a.ServiceAddress
                })
                .ToListAsync();

            return Ok(applications);
        }


        // =====================================================
        // VENDOR: ACCEPT / REJECT APPLICATION
        // =====================================================
        [HttpPut("{id}/status")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> UpdateStatus(
            int id,
            [FromQuery] string status
        )
        {
            if (status != "Accepted" && status != "Rejected")
                return BadRequest("Status must be Accepted or Rejected");

            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null) return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound("Application not found");

            if (app.VendorId != vendorId)
                return Forbid();

            app.Status = status;
            await _context.SaveChangesAsync();

            return Ok(new { message = $"Application {status} successfully" });
        }

        // =====================================================
        // WORKER: MARK JOB COMPLETED
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
            return Ok(new { message = "Job marked as completed" });
        }

        // =====================================================
        // VENDOR: MARK PAYMENT AS PAID
        // =====================================================
        [HttpPut("{id}/pay")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> MarkPaid(
            int id,
            [FromQuery] string method
        )
        {
            if (method != "Cash" && method != "Online")
                return BadRequest("Invalid payment method");

            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null) return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var app = await _context.Applications
                .Include(a => a.Service)
                .FirstOrDefaultAsync(a => a.Id == id);

            if (app == null) return NotFound();
            if (app.VendorId != vendorId) return Forbid();
            if (app.Status != "Completed") return BadRequest("Job not completed");

            app.PaymentStatus = "Paid";
            app.PaymentMethod = method;

            if (app.Service != null)
                app.Service.Status = ServiceStatus.Completed;

            await _context.SaveChangesAsync();
            return Ok(new { message = $"Payment marked as paid via {method}" });
        }

        // =====================================================
        // VENDOR: RATE WORKER
        // =====================================================
        [HttpPost("{id}/rate-worker")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> RateWorker(
            int id,
            [FromQuery] int rating
        )
        {
            if (rating < 1 || rating > 5)
                return BadRequest("Rating must be between 1 and 5");

            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound();

            if (app.PaymentStatus != "Paid")
                return BadRequest("Payment not completed");

            if (app.VendorRated)
                return BadRequest("Worker already rated");

            app.VendorRating = rating;
            app.VendorRated = true;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Worker rated successfully" });
        }

        // =====================================================
        // WORKER: RATE VENDOR
        // =====================================================
        [HttpPost("{id}/rate-vendor")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> RateVendor(
            int id,
            [FromQuery] int rating
        )
        {
            if (rating < 1 || rating > 5)
                return BadRequest("Rating must be between 1 and 5");

            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound();

            if (app.PaymentStatus != "Paid")
                return BadRequest("Payment not completed");

            if (app.WorkerRated)
                return BadRequest("Vendor already rated");

            app.WorkerRating = rating;
            app.WorkerRated = true;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Vendor rated successfully" });
        }
    }
}
