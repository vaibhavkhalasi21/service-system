using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Service
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Service name is required")]
        [StringLength(150)]
        public string ServiceName { get; set; } = null!;

        [Required(ErrorMessage = "Category is required")]
        [StringLength(100)]
        public string Category { get; set; } = null!;

        [Required]
        [Range(1, 100000)]
        public decimal Price { get; set; }

        // Image path stored in DB
        public string? ImageUrl { get; set; }
    }
}
