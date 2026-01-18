using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using VendorWorkerAPI.Data;

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

        // =====================================================
        // ⚠️ LEGACY / READ-ONLY
        // VENDOR: VIEW BOOKING REQUESTS
        // =====================================================
        // NOTE:
        // - Do NOT apply / accept / reject here
        // - ApplicationController is the source of truth
        // - This endpoint is READ-ONLY (safe to keep)
        // =====================================================
        [HttpGet("vendor")]
        [Authorize(Roles = "Vendor")]
        public async Task<IActionResult> VendorBookings()
        {
            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(vendorIdStr, out int vendorId))
                return Unauthorized("Invalid vendor token");

            var bookings = await _context.Bookings
                .Where(b => b.VendorId == vendorId)
                .Include(b => b.Service)
                .Include(b => b.Worker)
                .OrderByDescending(b => b.CreatedAt)
                .Select(b => new
                {
                    b.Id,
                    b.Status,
                    WorkerName = b.Worker.Name,
                    ServiceName = b.Service.ServiceName,
                    Price = b.Service.Price,
                    b.CreatedAt
                })
                .ToListAsync();

            return Ok(bookings);
        }
    }
}
