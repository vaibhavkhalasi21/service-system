using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/payments")]
    public class PaymentController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PaymentController(AppDbContext context)
        {
            _context = context;
        }

        // =====================================================
        // VENDOR: ONLINE PAYMENT (DEMO)
        // =====================================================
        [Authorize(Roles = "Vendor")]
        [HttpPost("create-demo-payment/{applicationId}")]
        public async Task<IActionResult> CreateDemoPayment(int applicationId)
        {
            var vendorId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier)!
            );

            var app = await _context.Applications
                .Include(a => a.Service)
                .FirstOrDefaultAsync(a =>
                    a.Id == applicationId &&
                    a.VendorId == vendorId &&
                    a.Status == "Completed" &&
                    a.PaymentStatus == "Pending"
                );

            if (app == null)
                return BadRequest("Invalid application or already paid");

            var alreadyPaid = await _context.Payments
                .AnyAsync(p => p.ApplicationId == applicationId);

            if (alreadyPaid)
                return BadRequest("Payment already exists");

            var payment = new Payment
            {
                ApplicationId = app.Id,
                VendorId = app.VendorId,
                WorkerId = app.WorkerId,
                Amount = app.Service.Price,
                Status = "SUCCESS",
                EscrowStatus = "HELD",
                PaymentMethod = "Online (Demo)",
                CreatedAt = DateTime.UtcNow
            };

            _context.Payments.Add(payment);

            // ✅ update application
            app.PaymentStatus = "Paid";
            app.PaymentMethod = "Online (Demo)";

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Online payment successful (Demo)",
                paymentStatus = payment.Status,
                escrowStatus = payment.EscrowStatus
            });
        }

        // =====================================================
        // VENDOR: CASH PAYMENT (DEMO)
        // =====================================================
        [Authorize(Roles = "Vendor")]
        [HttpPost("create-cash-payment/{applicationId}")]
        public async Task<IActionResult> CreateCashPayment(int applicationId)
        {
            var vendorId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier)!
            );

            var app = await _context.Applications
                .Include(a => a.Service)
                .FirstOrDefaultAsync(a =>
                    a.Id == applicationId &&
                    a.VendorId == vendorId &&
                    a.Status == "Completed" &&
                    a.PaymentStatus == "Pending"
                );

            if (app == null)
                return BadRequest("Invalid application or already paid");

            var alreadyPaid = await _context.Payments
                .AnyAsync(p => p.ApplicationId == applicationId);

            if (alreadyPaid)
                return BadRequest("Payment already exists");

            var payment = new Payment
            {
                ApplicationId = app.Id,
                VendorId = app.VendorId,
                WorkerId = app.WorkerId,
                Amount = app.Service.Price,
                Status = "SUCCESS",
                EscrowStatus = "RELEASED",
                PaymentMethod = "Cash",
                CreatedAt = DateTime.UtcNow,
                ReleasedAt = DateTime.UtcNow
            };

            _context.Payments.Add(payment);

            // ✅ update application
            app.PaymentStatus = "Paid";
            app.PaymentMethod = "Cash";

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Cash payment recorded successfully",
                paymentStatus = payment.Status
            });
        }

        // =====================================================
        // VENDOR / WORKER: VIEW PAYMENTS
        // =====================================================
        [Authorize]
        [HttpGet("my-payments")]
        public async Task<IActionResult> GetMyPayments()
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier)!
            );
            var role = User.FindFirstValue(ClaimTypes.Role);

            IQueryable<Payment> query = _context.Payments;

            if (role == "Vendor")
                query = query.Where(p => p.VendorId == userId);
            else if (role == "Worker")
                query = query.Where(p => p.WorkerId == userId);
            else
                return Forbid();

            var payments = await query
                .OrderByDescending(p => p.CreatedAt)
                .Select(p => new
                {
                    p.Id,
                    p.Amount,
                    p.Status,
                    p.PaymentMethod,
                    p.EscrowStatus,
                    p.CreatedAt,
                    p.ReleasedAt
                })
                .ToListAsync();

            return Ok(payments);
        }
    }
}
