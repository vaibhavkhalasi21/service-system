using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

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
        public async Task<IActionResult> AdminDashboard()
        {
            var dashboard = new Dashboard
            {
                TotalAdmins = await _context.Admins.CountAsync(),
                TotalVendors = await _context.Vendors.CountAsync(),
                TotalWorkers = await _context.Workers.CountAsync(),
                TotalBookings = await _context.Bookings.CountAsync(),
                TotalServices = await _context.Services.CountAsync(),
                TotalRevenue = await _context.Payments.AnyAsync()
                    ? await _context.Payments.SumAsync(p => p.Amount)
                    : 0
            };

            return Ok(dashboard);
        }

        // ===============================
        // 🔐 VENDOR DASHBOARD
        // ===============================
        [Authorize(Roles = "Vendor")]
        [HttpGet("vendor")]
        public async Task<IActionResult> VendorDashboard()
        {
            var dashboard = new
            {
                totalServices = await _context.Services.CountAsync(),
                totalBookings = await _context.Bookings.CountAsync(),
                totalRevenue = await _context.Payments.AnyAsync()
                    ? await _context.Payments.SumAsync(p => p.Amount)
                    : 0
            };

            return Ok(dashboard);
        }

        // ===============================
        // 🔐 WORKER DASHBOARD
        // ===============================
        [Authorize(Roles = "Worker")]
        [HttpGet("worker")]
        public async Task<IActionResult> WorkerDashboard()
        {
            var dashboard = new
            {
                totalBookings = await _context.Bookings.CountAsync(),
                totalRevenue = await _context.Payments.AnyAsync()
                    ? await _context.Payments.SumAsync(p => p.Amount)
                    : 0
            };

            return Ok(dashboard);
        }
    }
}