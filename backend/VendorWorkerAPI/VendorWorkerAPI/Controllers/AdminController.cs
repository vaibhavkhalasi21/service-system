using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;
using VendorWorkerAPI.Services;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/admin")]
    public class AdminController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly JwtTokenService _jwt;

        public AdminController(AppDbContext context, JwtTokenService jwt)
        {
            _context = context;
            _jwt = jwt;
        }

        // ===================== ADMIN AUTH =====================


        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> LoginAdmin([FromBody] LoginAdminDto dto)
        {
            var admin = await _context.Admins
                .FirstOrDefaultAsync(a => a.Email == dto.Email);

            if (admin == null ||
                !PasswordService.Verify(dto.Password, admin.PasswordHash))
                return Unauthorized("Invalid email or password");

            var token = _jwt.GenerateToken(admin.Id, admin.Email, "Admin");

            return Ok(new
            {
                adminId = admin.Id,
                admin.Email,
                role = "Admin",
                token
            });
        }

        // ===================== VENDOR CRUD =====================

        [Authorize(Roles = "Admin")]
        [HttpPost("vendors")]
        public async Task<IActionResult> CreateVendor([FromBody] VendorRegisterDto dto)
        {
            if (await _context.Vendors.AnyAsync(v => v.Email == dto.Email))
                return BadRequest("Vendor already exists");

            var vendor = new Vendor
            {
                Name = dto.Name,
                Email = dto.Email,
                Phone = dto.Phone,
                ServiceType = dto.ServiceType,
                Address = dto.Address,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
                Role = "Vendor",
                IsActive = true
            };

            _context.Vendors.Add(vendor);
            await _context.SaveChangesAsync();

            return Ok(new { vendor.Id, vendor.Email });
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("vendors/{id}")]
        public async Task<IActionResult> UpdateVendor(int id, [FromBody] VendorRegisterDto dto)
        {
            var vendor = await _context.Vendors.FindAsync(id);
            if (vendor == null)
                return NotFound("Vendor not found");

            vendor.Name = dto.Name;
            vendor.Phone = dto.Phone;
            vendor.ServiceType = dto.ServiceType;
            vendor.Address = dto.Address;

            await _context.SaveChangesAsync();
            return Ok("Vendor updated");
        }

        // ===================== BLOCK / UNBLOCK VENDOR =====================
        [Authorize(Roles = "Admin")]
        [HttpPut("vendors/{id}/status")]
        public async Task<IActionResult> UpdateVendorStatus(
            int id,
            [FromQuery] bool isActive)
        {
            var vendor = await _context.Vendors.FindAsync(id);
            if (vendor == null)
                return NotFound("Vendor not found");

            vendor.IsActive = isActive;
            await _context.SaveChangesAsync();

            return Ok(new
            {
                vendor.Id,
                vendor.Email,
                vendor.IsActive
            });
        }


        [Authorize(Roles = "Admin")]
        [HttpDelete("vendors/{id}")]
        public async Task<IActionResult> DeleteVendor(int id)
        {
            var vendor = await _context.Vendors.FindAsync(id);
            if (vendor == null)
                return NotFound("Vendor not found");

            vendor.IsActive = false;
            await _context.SaveChangesAsync();

            return Ok("Vendor disabled");
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("vendors")]
        public async Task<IActionResult> GetVendors()
        {
            var vendors = await _context.Vendors
                .Select(v => new
                {
                    v.Id,
                    v.Name,
                    v.Email,
                    v.IsActive
                })
                .ToListAsync();

            return Ok(vendors);
        }

        // ===================== WORKER CRUD =====================

        [Authorize(Roles = "Admin")]
        [HttpPost("workers")]
        public async Task<IActionResult> CreateWorker([FromBody] WorkerRegisterDto dto)
        {
            if (await _context.Workers.AnyAsync(w => w.Email == dto.Email))
                return BadRequest("Worker already exists");

            var worker = new Worker
            {
                Name = dto.Name,
                Email = dto.Email,
                Phone = dto.Phone,
                Skill = dto.Skill,
                Address = dto.Address,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
                Role = "Worker",
                IsActive = true
            };

            _context.Workers.Add(worker);
            await _context.SaveChangesAsync();

            return Ok(new { worker.Id, worker.Email });
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("workers/{id}")]
        public async Task<IActionResult> UpdateWorker(int id, [FromBody] WorkerRegisterDto dto)
        {
            var worker = await _context.Workers.FindAsync(id);
            if (worker == null)
                return NotFound("Worker not found");

            worker.Name = dto.Name;
            worker.Phone = dto.Phone;
            worker.Skill = dto.Skill;
            worker.Address = dto.Address;

            await _context.SaveChangesAsync();
            return Ok("Worker updated");
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("workers/{id}")]
        public async Task<IActionResult> DeleteWorker(int id)
        {
            var worker = await _context.Workers.FindAsync(id);
            if (worker == null)
                return NotFound("Worker not found");

            worker.IsActive = false;
            await _context.SaveChangesAsync();

            return Ok("Worker disabled");
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("workers")]
        public async Task<IActionResult> GetWorkers()
        {
            var workers = await _context.Workers
                .Select(w => new
                {
                    w.Id,
                    w.Name,
                    w.Email,
                    w.IsActive
                })
                .ToListAsync();

            return Ok(workers);
        }

        // ===================== BLOCK / UNBLOCK WORKER =====================
        [Authorize(Roles = "Admin")]
        [HttpPut("workers/{id}/status")]
        public async Task<IActionResult> UpdateWorkerStatus(
            int id,
            [FromQuery] bool isActive)
        {
            var worker = await _context.Workers.FindAsync(id);
            if (worker == null)
                return NotFound("Worker not found");

            worker.IsActive = isActive;
            await _context.SaveChangesAsync();

            return Ok(new
            {
                worker.Id,
                worker.Email,
                worker.IsActive
            });
        }


        // ===================== SERVICE CRUD =====================

        [Authorize(Roles = "Admin")]
        [HttpPost("services")]
        public async Task<IActionResult> CreateService([FromBody] Service service)
        {
            service.Status = ServiceStatus.Active;
            _context.Services.Add(service);
            await _context.SaveChangesAsync();

            return Ok(service.Id);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("services/{id}")]
        public async Task<IActionResult> UpdateService(int id, [FromBody] Service dto)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null)
                return NotFound("Service not found");

            service.ServiceName = dto.ServiceName;
            service.Category = dto.Category;
            service.Price = dto.Price;
            service.ImageUrl = dto.ImageUrl;
            service.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return Ok("Service updated");
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("services/{id}")]
        public async Task<IActionResult> DeleteService(int id)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null)
                return NotFound("Service not found");

            service.Status = ServiceStatus.Inactive;
            service.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return Ok("Service disabled");
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("services")]
        public async Task<IActionResult> GetServices()
        {
            var services = await _context.Services
                .Select(s => new
                {
                    s.Id,
                    s.ServiceName,
                    s.Price,
                    s.Status
                })
                .ToListAsync();

            return Ok(services);
        }

        // ===================== APPLICATIONS & PAYMENTS =====================

        [Authorize(Roles = "Admin")]
        [HttpGet("applications")]
        public async Task<IActionResult> GetApplications()
        {
            var apps = await _context.Applications
                .Include(a => a.Service)
                .Include(a => a.Vendor)
                .Include(a => a.Worker)
                .Select(a => new
                {
                    a.Id,
                    ServiceName = a.Service.ServiceName,
                    VendorName = a.Vendor.Name,
                    WorkerName = a.Worker.Name,
                    a.Status,
                    a.PaymentMethod,
                    a.PaymentStatus,
                    a.CreatedAt
                })
                .ToListAsync();

            return Ok(apps);
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("payments")]
        public async Task<IActionResult> GetPayments()
        {
            var payments = await _context.Applications
                .Include(a => a.Vendor)
                .Include(a => a.Worker)
                .Select(a => new
                {
                    ApplicationId = a.Id,
                    VendorName = a.Vendor.Name,
                    WorkerName = a.Worker.Name,
                    a.PaymentMethod,
                    a.PaymentStatus,
                    a.Status,
                    a.CreatedAt
                })
                .ToListAsync();

            return Ok(payments);
        }

        // ===================== VIEW ALL RATINGS (READ ONLY) =====================
        [Authorize(Roles = "Admin")]
        [HttpGet("ratings")]
        public async Task<IActionResult> GetAllRatings()
        {
            var ratings = await _context.Applications
                .Include(a => a.Service)
                .Include(a => a.Vendor)
                .Include(a => a.Worker)
                .Where(a => a.VendorRated || a.WorkerRated)
                .Select(a => new
                {
                    ApplicationId = a.Id,
                    ServiceName = a.Service.ServiceName,
                    VendorName = a.Vendor.Name,
                    WorkerName = a.Worker.Name,

                    // ⭐ RATINGS
                    VendorRating = a.VendorRating, // Vendor → Worker
                    WorkerRating = a.WorkerRating, // Worker → Vendor

                    a.CreatedAt
                })
                .ToListAsync();

            return Ok(ratings);
        }


    }
}
