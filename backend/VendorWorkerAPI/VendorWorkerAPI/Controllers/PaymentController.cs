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
        // DEMO: CREATE ONLINE PAYMENT (NO GATEWAY)
        // =====================================================
        [Authorize(Roles = "Vendor")]
        [HttpPost("create-demo-payment/{bookingId}")]
        public async Task<IActionResult> CreateDemoPayment(int bookingId)
        {
            var vendorId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier)!
            );

            var booking = await _context.Bookings
                .FirstOrDefaultAsync(b =>
                    b.Id == bookingId &&
                    b.VendorId == vendorId &&
                    b.Status == "CONFIRMED");

            if (booking == null)
                return BadRequest("Invalid booking");

            // 🔹 Create DEMO payment record
            var payment = new Payment
            {
                BookingId = booking.Id,
                VendorId = booking.VendorId,
                WorkerId = booking.WorkerId,
                Amount = booking.AgreedPrice,
                Status = "SUCCESS",
                EscrowStatus = "HELD",
                PaymentMethod = "Online (Demo)",
                CreatedAt = DateTime.UtcNow
            };

            _context.Payments.Add(payment);

            // 🔹 Update booking status
            booking.Status = "PAID";

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Online payment successful (Demo)",
                paymentStatus = payment.Status,
                escrowStatus = payment.EscrowStatus
            });
        }

        // =====================================================
        // ADMIN: RELEASE ESCROW (DEMO)
        // =====================================================
        [Authorize(Roles = "Admin")]
        [HttpPut("release-escrow/{paymentId}")]
        public async Task<IActionResult> ReleaseEscrow(int paymentId)
        {
            var payment = await _context.Payments.FindAsync(paymentId);
            if (payment == null)
                return NotFound("Payment not found");

            if (payment.Status != "SUCCESS")
                return BadRequest("Payment not successful");

            if (payment.EscrowStatus == "RELEASED")
                return BadRequest("Escrow already released");

            payment.EscrowStatus = "RELEASED";
            payment.ReleasedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Escrow released to worker (Demo)",
                escrowStatus = payment.EscrowStatus
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
