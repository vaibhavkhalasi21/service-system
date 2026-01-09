using System.ComponentModel.DataAnnotations;

public class Service
{
    [Key]
    public int Id { get; set; }

    public string ServiceName { get; set; } = null!;
    public string Category { get; set; } = null!;
    public decimal Price { get; set; }

    public string? ImageUrl { get; set; }

    public int VendorId { get; set; }

    // ✅ ADD THIS
    public Vendor Vendor { get; set; } = null!;

    public bool IsActive { get; set; } = true;

    public DateTime ServiceDateTime { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
}
