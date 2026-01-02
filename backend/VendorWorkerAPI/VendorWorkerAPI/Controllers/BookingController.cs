using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/booking")]
    public class BookingController : ControllerBase
    {
        private readonly AppDbContext _context;

        public BookingController(AppDbContext context)
        {
            _context = context;
        }

        // ===============================
        // WORKER: APPLY FOR SERVICE
        // ===============================
        [HttpPost("apply/{serviceId}")]
        [Authorize(Roles = "Worker")]
        public async Task<IActionResult> ApplyForService(int serviceId)
        {
            var workerId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (workerId == null) return Unauthorized();

            var service = await _context.Services.FindAsync(serviceId);
            if (service == null) return NotFound("Service not found");

            bool alreadyApplied = await _context.Bookings.AnyAsync(b =>
                b.ServiceId == serviceId && b.WorkerId == workerId);

            if (alreadyApplied)
                return BadRequest("Already applied");

            var booking = new Booking
            {
                ServiceId = serviceId,
                VendorId = service.VendorId,
                WorkerId = workerId
            };

            _context.Bookings.Add(booking);
            await _context.SaveChangesAsync();

            return Ok("Applied successfully");
        }

        // ===============================
        // VENDOR: VIEW BOOKING REQUESTS
        // ===============================
        [HttpGet("vendor")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> VendorBookings()
        {
            var vendorId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var bookings = await _context.Bookings
                .Where(b => b.VendorId == vendorId && b.Status == "Pending")
                .ToListAsync();

            return Ok(bookings);
        }

        // ===============================
        // VENDOR: ACCEPT BOOKING
        // ===============================
        [HttpPut("accept/{id}")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> AcceptBooking(int id)
        {
            var vendorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var booking = await _context.Bookings.FindAsync(id);

            if (booking == null) return NotFound();
            if (booking.VendorId != vendorId) return Forbid();

            booking.Status = "Accepted";
            await _context.SaveChangesAsync();

            return Ok("Booking accepted");
        }

        // ===============================
        // VENDOR: REJECT BOOKING
        // ===============================
        [HttpPut("reject/{id}")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> RejectBooking(int id)
        {
            var vendorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var booking = await _context.Bookings.FindAsync(id);

            if (booking == null) return NotFound();
            if (booking.VendorId != vendorId) return Forbid();

            booking.Status = "Rejected";
            await _context.SaveChangesAsync();

            return Ok("Booking rejected");
        }
    }
}
