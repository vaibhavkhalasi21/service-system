using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;
using VendorWorkerAPI.Services;
using System.Security.Cryptography;
using System.Text;

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
        public IActionResult Register(VendorRegisterDto dto)
        {
            if (_context.Vendors.Any(v => v.Email == dto.Email))
                return BadRequest("Email already exists");

            var vendor = new Vendor
            {
                Name = dto.Name,
                Email = dto.Email,
                PasswordHash = HashPassword(dto.Password),
                Phone = dto.Phone,
                ServiceType = dto.ServiceType,
                Address = dto.Address,
                Role = "Vendor"
            };

            _context.Vendors.Add(vendor);
            _context.SaveChanges();

            return Ok("Vendor registered successfully");
        }

        // ================= LOGIN =================
        [AllowAnonymous]
        [HttpPost("login")]
        public IActionResult Login(VendorLoginDto dto)
        {
            var hash = HashPassword(dto.Password);

            var vendor = _context.Vendors
                .FirstOrDefault(v => v.Email == dto.Email && v.PasswordHash == hash);

            if (vendor == null)
                return Unauthorized("Invalid credentials");

            var token = _jwt.GenerateToken(vendor.Id, vendor.Email, vendor.Role);

            return Ok(new
            {
                token,
                vendor.Id,
                vendor.Name,
                vendor.Email,
                vendor.Role
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

        // ================= PASSWORD HASH =================
        private string HashPassword(string password)
        {
            using var sha = SHA256.Create();
            var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            return Convert.ToHexString(bytes).ToLower();
        }
    }
}
