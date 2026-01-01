using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RatingController : ControllerBase
    {
        private readonly AppDbContext _context;

        public RatingController(AppDbContext context)
        {
            _context = context;
        }

        // ===============================
        // GET: api/rating
        // ===============================
        [HttpGet]
        public async Task<IActionResult> GetRatings()
        {
            var ratings = await _context.Ratings.ToListAsync();
            return Ok(ratings);
        }

        // ===============================
        // GET: api/rating/1
        // ===============================
        [HttpGet("{id}")]
        public async Task<IActionResult> GetRating(int id)
        {
            var rating = await _context.Ratings.FindAsync(id);

            if (rating == null)
                return NotFound("Rating not found");

            return Ok(rating);
        }

        // ===============================
        // POST: api/rating
        // ===============================
        [HttpPost]
        public async Task<IActionResult> AddRating([FromBody] Rating rating)
        {
            // 🔐 Validate request body
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            _context.Ratings.Add(rating);
            await _context.SaveChangesAsync();

            return CreatedAtAction(
                nameof(GetRating),
                new { id = rating.RatingId },
                rating
            );
        }

        // ===============================
        // PUT: api/rating/1
        // ===============================
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRating(int id, [FromBody] Rating rating)
        {
            if (id != rating.RatingId)
                return BadRequest("Rating ID mismatch");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var existingRating = await _context.Ratings.FindAsync(id);
            if (existingRating == null)
                return NotFound("Rating not found");

            // 🔐 Safe field update
            existingRating.WorkerId = rating.WorkerId;
            existingRating.UserName = rating.UserName;
            existingRating.Stars = rating.Stars;
            existingRating.Comment = rating.Comment;
            existingRating.RatingDate = rating.RatingDate;

            await _context.SaveChangesAsync();

            return Ok("Rating updated successfully");
        }

        // ===============================
        // DELETE: api/rating/1
        // ===============================
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRating(int id)
        {
            var rating = await _context.Ratings.FindAsync(id);

            if (rating == null)
                return NotFound("Rating not found");

            _context.Ratings.Remove(rating);
            await _context.SaveChangesAsync();

            return Ok("Rating deleted successfully");
        }
    }
}