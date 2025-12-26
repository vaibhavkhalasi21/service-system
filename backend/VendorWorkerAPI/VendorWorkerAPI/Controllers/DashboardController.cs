using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VendorWorkerAPI.Data;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/dashboard")]
    [Authorize]
    public class DashboardController : ControllerBase
    {
        private readonly AppDbContext _context;

        public DashboardController(AppDbContext context)
        {
            _context = context;
        }

        // ===============================
        // 🔐 ADMIN DASHBOARD
        // ===============================
        [Authorize(Roles = "Admin")]
        [HttpGet("admin")]
        public IActionResult AdminDashboard()
        {
            return Ok(new
            {
                totalVendors = _context.Vendors.Count(),
                totalWorkers = _context.Workers.Count(),
                totalBookings = _context.Bookings.Count(),
                totalServices = _context.Services.Count(),
                totalPayments = _context.Payments.Sum(p => p.Amount)
            });
        }

        // ===============================
        // 🔐 VENDOR DASHBOARD
        // ===============================
        [Authorize(Roles = "Vendor")]
        [HttpGet("vendor")]
        public IActionResult VendorDashboard()
        {
            return Ok(new
            {
                totalServices = _context.Services.Count(),
                totalBookings = _context.Bookings.Count(),
                totalPayments = _context.Payments.Sum(p => p.Amount)
            });
        }

        // ===============================
        // 🔐 WORKER DASHBOARD
        // ===============================
        [Authorize(Roles = "Worker")]
        [HttpGet("worker")]
        public IActionResult WorkerDashboard()
        {
            return Ok(new
            {
                totalBookings = _context.Bookings.Count(),
                totalPayments = _context.Payments.Sum(p => p.Amount)
            });
        }
    }
}