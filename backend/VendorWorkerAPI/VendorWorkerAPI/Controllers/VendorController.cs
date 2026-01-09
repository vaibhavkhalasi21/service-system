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

            return Ok(new
            {
                userId = vendor.Id,
                name = vendor.Name,   // ✅ frontend ke liye
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
                    name = v.Name,     // ✅ REGISTERED NAME
                    email = v.Email,
                    role = v.Role
                })
                .FirstOrDefaultAsync();

            if (vendor == null)
                return NotFound("Vendor not found");

            return Ok(vendor);
        }


    }
}