using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
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
                return BadRequest("Booking data is required");

            // 🔴 Model validation
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // 🔐 Get CustomerId from JWT
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return Unauthorized("Invalid token");

            // 🔴 Validate Service exists
            bool serviceExists = await _context.Services
                .AnyAsync(s => s.Id == booking.ServiceId);

            if (!serviceExists)
                return BadRequest("Invalid ServiceId");

            // 🔒 Force values (security)
            booking.CustomerId = userId;
            booking.Status = "Pending";
            booking.CreatedAt = DateTime.UtcNow;

            _context.Bookings.Add(booking);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                Message = "Booking created successfully",
                booking.Id,
                booking.ServiceId,
                booking.Status,
                booking.CreatedAt
            });
        }

        // ================================
        // CUSTOMER: VIEW MY BOOKINGS
        // ================================
        [HttpGet("my")]
        [Authorize(Roles = "Customer")]
        public async Task<IActionResult> MyBookings()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return Unauthorized("Invalid token");

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
            if (id <= 0)
                return BadRequest("Invalid booking id");

            var booking = await _context.Bookings.FindAsync(id);

            if (booking == null)
                return NotFound("Booking not found");

            if (booking.Status != "Pending")
                return BadRequest("Only pending bookings can be accepted");

            booking.Status = "Accepted";
            await _context.SaveChangesAsync();

            return Ok(new
            {
                Message = "Booking accepted successfully",
                booking.Id,
                booking.Status
            });
        }
    }
}