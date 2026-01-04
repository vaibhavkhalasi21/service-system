public class Service
{
    public int Id { get; set; }

    public string ServiceName { get; set; } = null!;

    public string Category { get; set; } = null!;

    public decimal Price { get; set; }

    public string? ImageUrl { get; set; }

    // 🔥 FIXED
    
    public string VendorId { get; set; } = null!;

    public bool IsActive { get; set; } = true;

    public DateTime ServiceDateTime { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
}
