using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace VendorWorkerAPI.Models.DTOs
{
    public class ServiceCreateDto
    {
        [Required]
        [StringLength(150)]
        public string ServiceName { get; set; } = null!;

        [Required]
        [StringLength(100)]
        public string Category { get; set; } = null!;

        [Required]
        [Range(1, 100000)]
        public decimal Price { get; set; }

        public IFormFile? Image { get; set; }
    }
}
