using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Service
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(150)]
        public string ServiceName { get; set; } = null!;

        // ✅ STRING (not enum)
        [Required]
        [StringLength(100)]
        public string Category { get; set; } = null!;

        [Required]
        [Range(1, 100000)]
        public decimal Price { get; set; }

        public string? ImageUrl { get; set; }

        [Required]
        public string VendorId { get; set; } = null!;

        public bool IsActive { get; set; } = true;

        // ✅ UTC timestamps
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }
    }
}
