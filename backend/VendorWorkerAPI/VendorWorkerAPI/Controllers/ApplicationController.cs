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

            var worker = await _context.Workers.FindAsync(workerId);
            if (worker == null) return Unauthorized("Worker not found");

            // 🔥 CATEGORY RESTRICTION (MAIN RULE)
            if (worker.Category != service.Category)
            {
                return Forbid("You can apply only to services in your category");
            }

            bool alreadyApplied = await _context.Applications.AnyAsync(a =>
                a.ServiceId == serviceId && a.WorkerId == workerId);

            if (alreadyApplied)
                return BadRequest("You have already applied for this service");

            if (request.ServiceLatitude == 0 || request.ServiceLongitude == 0)
                return BadRequest("Service location required");

            if (request.WorkerLatitude == 0 || request.WorkerLongitude == 0)
                return BadRequest("Worker location required");

            var application = new Application
            {
                ServiceId = serviceId,
                WorkerId = workerId,
                VendorId = service.VendorId,

                Status = "Pending",
                PaymentStatus = "Pending",
                EscrowStatus = "NONE",
                CreatedAt = DateTime.UtcNow,

                ServiceLatitude = request.ServiceLatitude,
                ServiceLongitude = request.ServiceLongitude,
                ServiceAddress = request.ServiceAddress,

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
                    a.PaymentStatus,
                    a.PaymentMethod,
                    a.EscrowStatus,

                    a.WorkerRated,
                    a.WorkerRating,
                    a.VendorRated,
                    a.VendorRating,

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
        // VENDOR: VIEW APPLICATIONS / JOBS
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
                    a.PaymentStatus,
                    a.PaymentMethod,
                    a.EscrowStatus,

                    WorkerName = a.Worker.Name,
                    ServiceName = a.Service.ServiceName,
                    Price = a.Service.Price,
                    ServiceDateTime = a.Service.ServiceDateTime,

                    a.VendorRated,
                    a.VendorRating
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
                return BadRequest("Invalid status");

            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null) return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound();
            if (app.VendorId != vendorId) return Forbid();

            app.Status = status;
            await _context.SaveChangesAsync();

            return Ok(new { message = $"Application {status}" });
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
            if (app.Status != "Accepted")
                return BadRequest("Job not active");

            app.Status = "Completed";
            app.PaymentStatus = "Pending";

            await _context.SaveChangesAsync();
            return Ok(new { message = "Job completed" });
        }

        // =====================================================
        // VENDOR: PAY (CASH / ONLINE DEMO)
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
            if (app.Status != "Completed")
                return BadRequest("Job not completed");

            app.PaymentStatus = "Paid";

            if (method == "Online")
            {
                app.PaymentMethod = "Online (Demo)";
                app.EscrowStatus = "HELD";
            }
            else
            {
                app.PaymentMethod = "Cash";
                app.EscrowStatus = "RELEASED";
            }

            if (app.Service != null)
                app.Service.Status = ServiceStatus.Completed;

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = $"Payment marked as {app.PaymentMethod}",
                escrow = app.EscrowStatus
            });
        }

        // =====================================================
        // ADMIN: RELEASE ESCROW
        // =====================================================
        [HttpPut("{id}/release-escrow")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> ReleaseEscrow(int id)
        {
            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound();

            if (app.PaymentStatus != "Paid")
                return BadRequest("Payment not completed");

            if (app.EscrowStatus == "RELEASED")
                return BadRequest("Already released");

            app.EscrowStatus = "RELEASED";
            app.Status = "Closed";

            await _context.SaveChangesAsync();
            return Ok(new { message = "Escrow released" });
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
                return BadRequest("Invalid rating");

            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound();
            if (app.PaymentStatus != "Paid")
                return BadRequest("Payment not completed");
            if (app.VendorRated)
                return BadRequest("Already rated");

            app.VendorRating = rating;
            app.VendorRated = true;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Worker rated" });
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
                return BadRequest("Invalid rating");

            var app = await _context.Applications.FindAsync(id);
            if (app == null) return NotFound();
            if (app.PaymentStatus != "Paid")
                return BadRequest("Payment not completed");
            if (app.WorkerRated)
                return BadRequest("Already rated");

            app.WorkerRating = rating;
            app.WorkerRated = true;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Vendor rated" });
        }
    }
}
