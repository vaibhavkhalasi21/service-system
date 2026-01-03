using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Models.DTOs
{
    public class ServiceCreateDto
    {
        [Required]
        [StringLength(150)]
        public string ServiceName { get; set; } = null!;

        // ✅ ENUM → Swagger dropdown
        [Required]
        public ServiceCategory Category { get; set; }

        [Required]
        [Range(1, 100000)]
        public decimal Price { get; set; }

        // 🔥 REQUIRED: when service is needed
        [Required]
        public DateTime ServiceDateTime { get; set; }

        public IFormFile? Image { get; set; }
    }
}
