using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.DTOs;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;
using VendorWorkerAPI.Services;


namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly JwtTokenService _jwt;

        public UsersController(AppDbContext context, JwtTokenService jwt)
        {
            _context = context;
            _jwt = jwt;
        }

        // ================= REGISTER =================
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] UserRegisterDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            bool emailExists = await _context.Users
                .AnyAsync(u => u.Email == dto.Email);

            if (emailExists)
                return BadRequest("Email already registered");

            var user = new User
            {
                Name = dto.Name,
                Email = dto.Email,
                PasswordHash = HashPassword(dto.Password),
                Role = "Customer"
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return Ok("User registered successfully");
        }

        // ================= LOGIN =================
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserLoginDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            string hashedPassword = HashPassword(dto.Password);

            var user = await _context.Users
                .FirstOrDefaultAsync(u =>
                    u.Email == dto.Email &&
                    u.PasswordHash == hashedPassword);

            if (user == null)
                return Unauthorized("Invalid email or password");

            var token = _jwt.GenerateToken(user.Id, user.Email, user.Role);

            return Ok(new
            {
                message = "Login successful",
                token,
                user.Id,
                user.Name,
                user.Email,
                user.Role
            });
        }

        // ================= PASSWORD HASH =================
        private static string HashPassword(string password)
        {
            using var sha = SHA256.Create();
            var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            return Convert.ToHexString(bytes).ToLower();
        }
    }
}