using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models.DTOs
{
    public class WorkerLoginDto
    {
        [Required, EmailAddress]
        public string Email { get; set; }

        [Required]
        public string Password { get; set; }
    }
}