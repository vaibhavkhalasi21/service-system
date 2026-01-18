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
            [FromBody] ApplyServiceRequest request)
        {
            if (request == null)
                return BadRequest("Request body missing");

            var workerIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(workerIdStr, out int workerId))
                return Unauthorized();

            var service = await _context.Services.FindAsync(serviceId);
            if (service == null)
                return NotFound("Service not found");

            var worker = await _context.Workers.FindAsync(workerId);
            if (worker == null)
                return Unauthorized("Worker not found");

            if (worker.Category != service.Category)
                return Forbid("You can apply only to services in your category");

            bool alreadyApplied = await _context.Applications.AnyAsync(a =>
                a.ServiceId == serviceId && a.WorkerId == workerId);

            if (alreadyApplied)
                return Conflict("You have already applied");

            if (!request.WorkerLatitude.HasValue || !request.WorkerLongitude.HasValue)
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



                // Service location from DB
                ServiceLatitude = service.Latitude,
                ServiceLongitude = service.Longitude,
                ServiceAddress = service.Address,

                // Worker location from request
                WorkerLatitude = request.WorkerLatitude.Value,
                WorkerLongitude = request.WorkerLongitude.Value
            };

            _context.Applications.Add(application);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Application submitted successfully" });
        }

        // =====================================================
        // WORKER: MY BOOKINGS (FIXED)
        // =====================================================
        [HttpGet("worker")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> GetWorkerApplications()
        {
            var workerIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(workerIdStr, out int workerId))
                return Unauthorized();

            var applications = await _context.Applications
                .Where(a => a.WorkerId == workerId)
                .Include(a => a.Service)
                    .ThenInclude(s => s.Vendor)
                .OrderByDescending(a => a.CreatedAt)
                .Select(a => new
                {
                    id = a.Id,
                    status = a.Status,
                    paymentStatus = a.PaymentStatus,

                    serviceName = a.Service.ServiceName,
                    category = a.Service.Category,
                    price = a.Service.Price,
                    serviceDateTime = a.Service.ServiceDateTime,
                    vendorName = a.Service.Vendor.Name,

                    // 🔥 LOCATION FIELDS (CRITICAL)
                    serviceLatitude = a.ServiceLatitude,
                    serviceLongitude = a.ServiceLongitude,
                    serviceAddress = a.ServiceAddress,

                    vendorRated = a.VendorRated,
                    vendorRating = a.VendorRating
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
            if (!int.TryParse(vendorIdStr, out int vendorId))
                return Unauthorized();

            var applications = await _context.Applications
                .Where(a => a.VendorId == vendorId)
                .Include(a => a.Service)
                .Include(a => a.Worker)
                .OrderByDescending(a => a.CreatedAt)
                .Select(a => new
                {
                    id = a.Id,

                    WorkerName = a.Worker.Name,
                    WorkerEmail = a.Worker.Email,

                    serviceName = a.Service.ServiceName,
                    category = a.Service.Category,

                    price = a.Service.Price,                     // ✅ FIX
                    serviceDateTime = a.Service.ServiceDateTime, // ✅ FIX

                    workerLatitude = a.WorkerLatitude,
                    workerLongitude = a.WorkerLongitude,

                    serviceLatitude = a.ServiceLatitude,
                    serviceLongitude = a.ServiceLongitude,
                    serviceAddress = a.ServiceAddress,

                    status = a.Status,
                    paymentStatus = a.PaymentStatus,
                    paymentMethod = a.PaymentMethod,

                    vendorRated = a.VendorRated,
                    vendorRating = a.VendorRating,

                    createdAt = a.CreatedAt
                })

                .ToListAsync();

            return Ok(applications);
        }

        // =====================================================
        // VENDOR: ACCEPT / REJECT
        // =====================================================
        [HttpPut("{id}/status")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> UpdateStatus(
            int id,
            [FromQuery] string status)
        {
            if (status != "Accepted" && status != "Rejected")
                return BadRequest("Invalid status");

            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(vendorIdStr, out int vendorId))
                return Unauthorized();

            var app = await _context.Applications.FindAsync(id);
            if (app == null)
                return NotFound();

            if (app.VendorId != vendorId)
                return Forbid();

            if (app.Status != "Pending")
                return Conflict("Already processed");

            app.Status = status;
            await _context.SaveChangesAsync();

            return Ok(new { message = $"Application {status}" });
        }

        // =====================================================
        // WORKER: MARK COMPLETED
        // =====================================================
        [HttpPut("{id}/complete")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> MarkCompleted(int id)
        {
            var workerIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(workerIdStr, out int workerId))
                return Unauthorized();

            var app = await _context.Applications.FindAsync(id);
            if (app == null)
                return NotFound();

            if (app.WorkerId != workerId)
                return Forbid();

            if (app.Status != "Accepted")
                return BadRequest("Job not active");

            app.Status = "Completed";
            app.PaymentStatus = "Pending";

            await _context.SaveChangesAsync();
            return Ok(new { message = "Job completed" });
        }
    }
}
