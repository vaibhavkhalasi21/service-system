using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models.DTOs
{
    public class ApplicationCreateDto
    {
        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid service id")]
        public int ServiceId { get; set; }
    }
}
