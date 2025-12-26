using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

[ApiController]
[Route("api/[controller]")]
public class PaymentController : ControllerBase
{
    private readonly AppDbContext _context;

    public PaymentController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/payment
    [HttpGet]
    public async Task<IActionResult> GetPayments()
    {
        return Ok(await _context.Payments.ToListAsync());
    }

    // GET: api/payment/1
    [HttpGet("{id}")]
    public async Task<IActionResult> GetPayment(int id)
    {
        var payment = await _context.Payments.FindAsync(id);
        if (payment == null)
            return NotFound("Payment not found");

        return Ok(payment);
    }

    // POST: api/payment
    [HttpPost]
    public async Task<IActionResult> AddPayment(Payment payment)
    {
        _context.Payments.Add(payment);
        await _context.SaveChangesAsync();
        return Ok("Payment added successfully");
    }

    // PUT: api/payment/1
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdatePayment(int id, Payment payment)
    {
        if (id != payment.PaymentId)
            return BadRequest("ID mismatch");

        _context.Entry(payment).State = EntityState.Modified;
        await _context.SaveChangesAsync();
        return Ok("Payment updated");
    }

    // DELETE: api/payment/1
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeletePayment(int id)
    {
        var payment = await _context.Payments.FindAsync(id);
        if (payment == null)
            return NotFound("Payment not found");

        _context.Payments.Remove(payment);
        await _context.SaveChangesAsync();
        return Ok("Payment deleted");
    }
}