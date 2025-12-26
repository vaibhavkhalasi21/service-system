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
        public async Task<IActionResult> Register(WorkerRegisterDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (await _context.Workers.AnyAsync(w => w.Email == dto.Email))
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
        public async Task<IActionResult> Login(WorkerLoginDto dto)
        {
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
                worker.Role
            );

            return Ok(new
            {
                message = "Login successful",
                token,
                workerId = worker.Id,
                workerName = worker.Name,
                role = worker.Role
            });
        }

        // =============================
        // 🔒 PROFILE
        // =============================
        [Authorize(Roles = "Worker")]
        [HttpGet("profile")]
        public IActionResult Profile()
        {
            var id = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var email = User.FindFirstValue(ClaimTypes.Email);
            var role = User.FindFirstValue(ClaimTypes.Role);

            return Ok(new
            {
                workerId = id,
                email,
                role
            });
        }

        // =============================
        // 🔒 ADMIN ONLY
        // =============================
        [Authorize(Roles = "Admin")]
        [HttpGet("all")]
        public async Task<IActionResult> GetAllWorkers()
        {
            return Ok(await _context.Workers.ToListAsync());
        }
    }
}