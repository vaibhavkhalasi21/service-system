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
            if (workerIdStr == null)
                return Unauthorized();

            int workerId = int.Parse(workerIdStr);

            var service = await _context.Services.FindAsync(serviceId);
            if (service == null)
                return NotFound("Service not found");

            bool alreadyApplied = await _context.Applications.AnyAsync(a =>
                a.ServiceId == serviceId &&
                a.WorkerId == workerId);

            if (alreadyApplied)
                return BadRequest("You have already applied for this service");

            var application = new Application
            {
                ServiceId = serviceId,
                WorkerId = workerId,
                VendorId = service.VendorId,
                PaymentStatus = "Pending",
                Status = "Pending",
                CreatedAt = DateTime.UtcNow
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
            if (workerIdStr == null)
                return Unauthorized();

            int workerId = int.Parse(workerIdStr);

            var applications = await _context.Applications
     .Where(a => a.WorkerId == workerId)
     .Include(a => a.Service)
         .ThenInclude(s => s.Vendor) // ✅ ADD THIS
     .OrderByDescending(a => a.CreatedAt)
     .Select(a => new
     {
         a.Id,
         a.Status,
         a.PaymentStatus,
         a.CreatedAt,
         ServiceName = a.Service.ServiceName,
         Category = a.Service.Category,
         Price = a.Service.Price,
         ServiceDateTime = a.Service.ServiceDateTime,
         VendorName = a.Service.Vendor.Name // ✅ ADD THIS
     })
     .ToListAsync();


            return Ok(applications);
        }

        // =====================================================
        // VENDOR: VIEW APPLICATIONS FOR MY SERVICES
        // =====================================================
        [HttpGet("vendor")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> GetVendorApplications()
        {
            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null)
                return Unauthorized();

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
        // VENDOR: ACCEPT / REJECT APPLICATION
        // =====================================================
        [HttpPut("{id}/status")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> UpdateStatus(
            int id,
            [FromQuery] string status)
        {
            if (status != "Accepted" && status != "Rejected")
                return BadRequest("Status must be Accepted or Rejected");

            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null)
                return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var application = await _context.Applications.FindAsync(id);
            if (application == null)
                return NotFound("Application not found");

            if (application.VendorId != vendorId)
                return Forbid();

            application.Status = status;
            await _context.SaveChangesAsync();

            return Ok(new { message = $"Application {status.ToLower()} successfully" });
        }

        // ===============================
        // WORKER: MARK JOB COMPLETED
        // ===============================
        [HttpPut("{id}/complete")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> MarkCompleted(int id )
        {
            var workerIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (workerIdStr == null)
                return Unauthorized();

            int workerId = int.Parse(workerIdStr);

            var application = await _context.Applications.FindAsync(id);
            if (application == null)
                return NotFound("Application not found");

            if (application.WorkerId != workerId)
                return Forbid();

            if (application.Status != "Accepted")
                return BadRequest("Job is not active");

            application.Status = "Completed";
            application.PaymentStatus = "Pending"; // 🔥 important
            await _context.SaveChangesAsync();

            return Ok(new { message = "Job marked as completed" });
        }




        // ===============================
        // VENDOR: MARK PAYMENT AS PAID
        // ===============================
        [HttpPut("{id}/pay")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> MarkPaymentPaid(int id)
        {
            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null)
                return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var application = await _context.Applications.FindAsync(id);
            if (application == null)
                return NotFound();

            if (application.VendorId != vendorId)
                return Forbid();

            if (!string.Equals(application.Status, "Completed", StringComparison.OrdinalIgnoreCase))
                return BadRequest("Job not completed yet");


            application.PaymentStatus = "Paid";
            await _context.SaveChangesAsync();

            return Ok(new { message = "Payment marked as paid" });
        }




        // =====================================================
        // VENDOR: DELETE APPLICATION
        // =====================================================
        [HttpDelete("{id}")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> DeleteApplication(int id)
        {
            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null)
                return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var application = await _context.Applications.FindAsync(id);
            if (application == null)
                return NotFound();

            if (application.VendorId != vendorId)
                return Forbid();

            _context.Applications.Remove(application);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Application deleted successfully" });
        }
    }
}
