using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;
using VendorWorkerAPI.Services;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/vendor")]
    public class VendorController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly JwtTokenService _jwt;

        public VendorController(AppDbContext context, JwtTokenService jwt)
        {
            _context = context;
            _jwt = jwt;
        }

        // ================= REGISTER (ADMIN ONLY) =================
        [Authorize(Roles = "Admin")]
        [HttpPost("register")]
        public IActionResult Register([FromBody] VendorRegisterDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            bool exists = _context.Vendors.Any(v => v.Email == dto.Email);
            if (exists)
                return BadRequest("Email already exists");

            var vendor = new Vendor
            {
                Name = dto.Name,
                Email = dto.Email,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
                Phone = dto.Phone,
                ServiceType = dto.ServiceType,
                Address = dto.Address,
                Role = "Vendor",
                IsActive = true
            };

            _context.Vendors.Add(vendor);
            _context.SaveChanges();

            return Ok(new { message = "Vendor registered successfully" });
        }

        // ================= LOGIN =================
        [AllowAnonymous]
        [HttpPost("login")]
        public IActionResult Login([FromBody] VendorLoginDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var vendor = _context.Vendors
                .FirstOrDefault(v => v.Email == dto.Email);

            if (vendor == null)
                return Unauthorized("Invalid email or password");

            if (!vendor.IsActive)
                return Unauthorized("Vendor account is blocked");

            if (!BCrypt.Net.BCrypt.Verify(dto.Password, vendor.PasswordHash))
                return Unauthorized("Invalid email or password");

            var token = _jwt.GenerateToken(
                vendor.Id,
                vendor.Email,
                vendor.Role
            );

            return Ok(new
            {
                userId = vendor.Id,
                name = vendor.Name,
                email = vendor.Email,
                role = vendor.Role,
                token = token
            });
        }

        // ================= PROFILE =================
        [Authorize(Roles = "Vendor")]
        [HttpGet("profile")]
        public async Task<IActionResult> Profile()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return Unauthorized();

            var vendor = await _context.Vendors
                .Where(v => v.Id.ToString() == userId)
                .Select(v => new
                {
                    v.Id,
                    name = v.Name,
                    email = v.Email,
                    role = v.Role
                })
                .FirstOrDefaultAsync();

            if (vendor == null)
                return NotFound("Vendor not found");

            return Ok(vendor);
        }

        // ================= CREATE SERVICE =================
        [Authorize(Roles = "Vendor")]
        [HttpPost("service")]
        public async Task<IActionResult> CreateService(
            [FromBody] ServiceCreateDto dto
        )
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null)
                return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            var service = new Service
            {
                ServiceName = dto.ServiceName,
                Category = (ServiceCategory)dto.Category,
                Price = dto.Price,
                ServiceDateTime = dto.ServiceDateTime,

                Latitude = dto.Latitude,
                Longitude = dto.Longitude,
                Address = dto.Address,

                VendorId = vendorId,
                Status = ServiceStatus.Active,
                CreatedAt = DateTime.UtcNow
            };

            _context.Services.Add(service);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Service created successfully",
                serviceId = service.Id
            });
        }

        // =====================================================
        // ✅ DEMO: RELEASE PAYMENT (ESCROW → WORKER)
        // =====================================================
        [Authorize(Roles = "Vendor")]
        [HttpPut("{applicationId}/release-payment")]
        public async Task<IActionResult> ReleasePayment(int applicationId)
        {
            var vendorIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (vendorIdStr == null)
                return Unauthorized();

            int vendorId = int.Parse(vendorIdStr);

            // 🔹 Payment is linked to ApplicationId (Demo model)
            var payment = await _context.Payments
                .FirstOrDefaultAsync(p => p.BookingId == applicationId);

            if (payment == null)
                return NotFound("Payment not found");

            if (payment.VendorId != vendorId)
                return Forbid();

            if (payment.Status != "SUCCESS")
                return BadRequest("Payment not completed");

            if (payment.EscrowStatus != "HELD")
                return BadRequest("Escrow already released");

            // ✅ RELEASE ESCROW
            payment.EscrowStatus = "RELEASED";
            payment.ReleasedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Payment released to worker (Demo)",
                escrowStatus = payment.EscrowStatus
            });
        }
    }
}
