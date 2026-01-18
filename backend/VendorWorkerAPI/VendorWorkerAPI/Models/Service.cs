using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using VendorWorkerAPI.Models;

public class Service
{
    [Key]
    public int Id { get; set; }

    [Required]
    public string ServiceName { get; set; } = null!;

    [Required]
    public ServiceCategory Category { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal Price { get; set; }

    public string? ImageUrl { get; set; }

    // 🔗 Vendor Relation
    [Required]
    public int VendorId { get; set; }          // ✅ FIXED
    public Vendor Vendor { get; set; } = null!;

    // 🔥 SERVICE LIFECYCLE
    [Required]
    public ServiceStatus Status { get; set; } = ServiceStatus.Active;

    // ⏱ Service Timing
    [Required]
    public DateTime ServiceDateTime { get; set; }

    // ⏳ Optional expiry
    public DateTime? ExpiresAt { get; set; }

    // 🕒 Audit fields
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }

    // 📍 LOCATION
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string? Address { get; set; }
}
