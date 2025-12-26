using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookingController : ControllerBase
    {
        private readonly AppDbContext _context;

        public BookingController(AppDbContext context)
        {
            _context = context;
        }

        // ================================
        // CUSTOMER: CREATE BOOKING
        // ================================
        [HttpPost]
        [Authorize(Roles = "Customer")]
        public async Task<IActionResult> CreateBooking([FromBody] Booking booking)
        {
            if (booking == null)
                return BadRequest("Invalid booking data");

            // 🔐 CustomerId TOKEN માંથી
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return Unauthorized("Invalid token");

            booking.CustomerId = userId;     // 👈 AUTO SET
            booking.Status = "Pending";
            booking.CreatedAt = DateTime.UtcNow;

            _context.Bookings.Add(booking);
            await _context.SaveChangesAsync();

            return Ok(booking);
        }

        // ================================
        // CUSTOMER: VIEW MY BOOKINGS
        // ================================
        [HttpGet("my")]
        [Authorize(Roles = "Customer")]
        public async Task<IActionResult> MyBookings()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var bookings = await _context.Bookings
                .Where(b => b.CustomerId == userId)
                .ToListAsync();

            return Ok(bookings);
        }

        // ================================
        // VENDOR: VIEW ALL BOOKINGS
        // ================================
        [HttpGet]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> GetAllBookings()
        {
            var bookings = await _context.Bookings.ToListAsync();
            return Ok(bookings);
        }

        // ================================
        // VENDOR: ACCEPT BOOKING
        // ================================
        [HttpPut("accept/{id}")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> AcceptBooking(int id)
        {
            var booking = await _context.Bookings.FindAsync(id);

            if (booking == null)
                return NotFound("Booking not found");

            booking.Status = "Accepted";
            await _context.SaveChangesAsync();

            return Ok(booking);
        }
    }
}
