using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;
using VendorWorkerAPI.Models.DTOs;
using VendorWorkerAPI.Services;
using System.Security.Claims;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/worker")]
    public class WorkerController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly JwtTokenService _jwt;

        public WorkerController(AppDbContext context, JwtTokenService jwt)
        {
            _context = context;
            _jwt = jwt;
        }

        // =============================
        // ✅ REGISTER
        // =============================
        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] WorkerRegisterDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            bool exists = await _context.Workers.AnyAsync(w => w.Email == dto.Email);
            if (exists)
                return BadRequest(new { message = "Email already registered" });

            var worker = new Worker
            {
                Name = dto.Name,
                Email = dto.Email,
                Phone = dto.Phone,
                Skill = dto.Skill,
                Address = dto.Address,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
                Role = "Worker"
            };

            _context.Workers.Add(worker);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Worker registered successfully",
                workerId = worker.Id
            });
        }

        // =============================
        // 🔐 LOGIN
        // =============================
        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] WorkerLoginDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var worker = await _context.Workers
                .FirstOrDefaultAsync(w => w.Email == dto.Email);

            if (worker == null ||
                !BCrypt.Net.BCrypt.Verify(dto.Password, worker.PasswordHash))
            {
                return Unauthorized(new { message = "Invalid email or password" });
            }

            var token = _jwt.GenerateToken(
                worker.Id,
                worker.Email,
                "Worker"
            );

            return Ok(new
            {
                message = "Login successful",
                token,
                workerId = worker.Id,
                workerName = worker.Name,
                role = "Worker"
            });
        }

        // =============================
        // 🔒 PROFILE
        // =============================
        [Authorize(Roles = "Worker")]
        [HttpGet("profile")]
        public IActionResult Profile()
        {
            return Ok(new
            {
                workerId = User.FindFirstValue(ClaimTypes.NameIdentifier),
                email = User.FindFirstValue(ClaimTypes.Email),
                role = User.FindFirstValue(ClaimTypes.Role)
            });
        }

        // =============================
        // 🔒 ADMIN ONLY
        // =============================
        [Authorize(Roles = "Admin")]
        [HttpGet("all")]
        public async Task<IActionResult> GetAllWorkers()
        {
            var workers = await _context.Workers
                .Select(w => new
                {
                    w.Id,
                    w.Name,
                    w.Email,
                    w.Phone,
                    w.Skill
                })
                .ToListAsync();

            return Ok(workers);
        }
    }
}