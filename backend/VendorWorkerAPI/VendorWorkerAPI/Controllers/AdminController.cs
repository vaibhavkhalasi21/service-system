using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Services;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AdminController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly JwtTokenService _jwt;

        public AdminController(AppDbContext context, JwtTokenService jwt)
        {
            _context = context;
            _jwt = jwt;
        }

        // ===================== GET ALL ADMINS =====================
        [Authorize(Roles = "Admin")]
        [HttpGet]
        public async Task<IActionResult> GetAllAdmins()
        {
            var admins = await _context.Admins
                .Select(a => new
                {
                    a.AdminId,
                    a.Name,
                    a.Email,
                    a.Role
                })
                .ToListAsync();

            return Ok(admins);
        }

        // ===================== REGISTER ADMIN =====================
        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<IActionResult> RegisterAdmin([FromBody] RegisterAdminDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            bool exists = await _context.Admins.AnyAsync(a => a.Email == dto.Email);
            if (exists)
                return BadRequest("Admin already exists");

            var admin = new Admin
            {
                Name = dto.Name,
                Email = dto.Email,
                PasswordHash = PasswordHasher.HashPassword(dto.Password),
                Role = "Admin"
            };

            _context.Admins.Add(admin);
            await _context.SaveChangesAsync();

            return Ok("Admin registered successfully");
        }

        // ===================== LOGIN ADMIN =====================
        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> LoginAdmin([FromBody] LoginAdminDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var admin = await _context.Admins
                .FirstOrDefaultAsync(a => a.Email == dto.Email);

            if (admin == null ||
                !PasswordHasher.VerifyPassword(dto.Password, admin.PasswordHash))
                return Unauthorized("Invalid email or password");

            var token = _jwt.GenerateToken(
                admin.AdminId,
                admin.Email,
                admin.Role
            );

            return Ok(new
            {
                Message = "Login successful",
                Token = token,
                admin.AdminId,
                admin.Name,
                admin.Email,
                admin.Role
            });
        }

        // ===================== DELETE ADMIN =====================
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAdmin(int id)
        {
            var admin = await _context.Admins.FindAsync(id);
            if (admin == null)
                return NotFound("Admin not found");

            _context.Admins.Remove(admin);
            await _context.SaveChangesAsync();

            return Ok("Admin deleted successfully");
        }
    }
}