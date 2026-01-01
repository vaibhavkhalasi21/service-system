using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;
using VendorWorkerAPI.Services;

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

        // ================= REGISTER =================
        [AllowAnonymous]
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

                // ✅ BCrypt HASH (FIXED)
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),

                Phone = dto.Phone,
                ServiceType = dto.ServiceType,
                Address = dto.Address,
                Role = "Vendor"
            };

            _context.Vendors.Add(vendor);
            _context.SaveChanges();

            return Ok(new
            {
                message = "Vendor registered successfully"
            });
        }

        // ================= LOGIN =================
        [AllowAnonymous]
        [HttpPost("login")]
        public IActionResult Login([FromBody] VendorLoginDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // 1️⃣ Find vendor by email
            var vendor = _context.Vendors
                .FirstOrDefault(v => v.Email == dto.Email);

            // 2️⃣ Verify password using BCrypt
            if (vendor == null ||
                !BCrypt.Net.BCrypt.Verify(dto.Password, vendor.PasswordHash))
            {
                return Unauthorized("Invalid email or password");
            }

            // 3️⃣ Generate JWT
            var token = _jwt.GenerateToken(
                vendor.Id,
                vendor.Email,
                vendor.Role
            );

            // 4️⃣ Return response
            return Ok(new
            {
                message = "Login successful",
                token,
                vendorId = vendor.Id,
                vendorName = vendor.Name,
                vendorEmail = vendor.Email,
                role = vendor.Role
            });
        }

        // ================= PROFILE =================
        [Authorize(Roles = "Vendor")]
        [HttpGet("profile")]
        public IActionResult Profile()
        {
            return Ok(new
            {
                message = "JWT verified",
                userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value,
                email = User.FindFirst(System.Security.Claims.ClaimTypes.Email)?.Value,
                role = User.FindFirst(System.Security.Claims.ClaimTypes.Role)?.Value
            });
        }
    }
}