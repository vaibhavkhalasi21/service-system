using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Models;

[ApiController]
[Route("api/[controller]")]
public class RatingController : ControllerBase
{
    private readonly AppDbContext _context;

    public RatingController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/rating
    [HttpGet]
    public async Task<IActionResult> GetRatings()
    {
        return Ok(await _context.Ratings.ToListAsync());
    }

    // GET: api/rating/1
    [HttpGet("{id}")]
    public async Task<IActionResult> GetRating(int id)
    {
        var rating = await _context.Ratings.FindAsync(id);
        if (rating == null)
            return NotFound("Rating not found");

        return Ok(rating);
    }

    // POST: api/rating
    [HttpPost]
    public async Task<IActionResult> AddRating(Rating rating)
    {
        _context.Ratings.Add(rating);
        await _context.SaveChangesAsync();
        return Ok("Rating added successfully");
    }

    // PUT: api/rating/1
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateRating(int id, Rating rating)
    {
        if (id != rating.RatingId)
            return BadRequest("ID mismatch");

        _context.Entry(rating).State = EntityState.Modified;
        await _context.SaveChangesAsync();
        return Ok("Rating updated");
    }

    // DELETE: api/rating/1
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteRating(int id)
    {
        var rating = await _context.Ratings.FindAsync(id);
        if (rating == null)
            return NotFound("Rating not found");

        _context.Ratings.Remove(rating);
        await _context.SaveChangesAsync();
        return Ok("Rating deleted");
    }
}