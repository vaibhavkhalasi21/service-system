using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
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
            var admins = await _context.Admins.ToListAsync();
            return Ok(admins);
        }

        // ===================== REGISTER ADMIN =====================
        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<IActionResult> RegisterAdmin([FromBody] Admin admin)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            bool exists = await _context.Admins.AnyAsync(a => a.Email == admin.Email);
            if (exists)
                return BadRequest("Admin already exists");

            admin.Role = "Admin"; // ✅ NOW VALID

            _context.Admins.Add(admin);
            await _context.SaveChangesAsync();

            return Ok("Admin registered successfully");
        }

        // ===================== LOGIN ADMIN =====================
        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> LoginAdmin([FromBody] Admin login)
        {
            var admin = await _context.Admins
                .FirstOrDefaultAsync(a => a.Email == login.Email && a.Password == login.Password);

            if (admin == null)
                return Unauthorized("Invalid email or password");

            var token = _jwt.GenerateToken(
                admin.AdminId,
                admin.Email,
                admin.Role
            );

            return Ok(new
            {
                Message = "Admin login successful",
                Token = token,
                AdminId = admin.AdminId,
                Name = admin.Name,
                Email = admin.Email
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