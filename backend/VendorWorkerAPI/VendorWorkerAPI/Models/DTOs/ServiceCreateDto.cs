using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace VendorWorkerAPI.Models.DTOs
{
    public class ServiceCreateDto
    {
        [Required]
        public string ServiceName { get; set; }

        [Required]
        [Range(1, 100000)]
        public decimal Price { get; set; }

        // ✅ Image file
        public IFormFile? Image { get; set; }
    }
}
