using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PaymentController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PaymentController(AppDbContext context)
        {
            _context = context;
        }

        // ===============================
        // GET: api/payment
        // ===============================
        [HttpGet]
        public async Task<IActionResult> GetPayments()
        {
            var payments = await _context.Payments.ToListAsync();
            return Ok(payments);
        }

        // ===============================
        // GET: api/payment/1
        // ===============================
        [HttpGet("{id}")]
        public async Task<IActionResult> GetPayment(int id)
        {
            var payment = await _context.Payments.FindAsync(id);

            if (payment == null)
                return NotFound("Payment not found");

            return Ok(payment);
        }

        // ===============================
        // POST: api/payment
        // ===============================
        [HttpPost]
        public async Task<IActionResult> AddPayment([FromBody] Payment payment)
        {
            // 🔐 Model validation
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            return CreatedAtAction(
                nameof(GetPayment),
                new { id = payment.PaymentId },
                payment
            );
        }

        // ===============================
        // PUT: api/payment/1
        // ===============================
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePayment(int id, [FromBody] Payment payment)
        {
            if (id != payment.PaymentId)
                return BadRequest("Payment ID mismatch");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var existingPayment = await _context.Payments.FindAsync(id);
            if (existingPayment == null)
                return NotFound("Payment not found");

            // Update fields safely
            existingPayment.UserName = payment.UserName;
            existingPayment.Amount = payment.Amount;
            existingPayment.PaymentMethod = payment.PaymentMethod;
            existingPayment.Status = payment.Status;
            existingPayment.PaymentDate = payment.PaymentDate;

            await _context.SaveChangesAsync();

            return Ok("Payment updated successfully");
        }

        // ===============================
        // DELETE: api/payment/1
        // ===============================
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePayment(int id)
        {
            var payment = await _context.Payments.FindAsync(id);

            if (payment == null)
                return NotFound("Payment not found");

            _context.Payments.Remove(payment);
            await _context.SaveChangesAsync();

            return Ok("Payment deleted successfully");
        }
    }
}