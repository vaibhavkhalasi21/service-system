using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class User
    {
        [Key]
        public int Id { get; set; } // Auto-increment by default

        [Required]
        [MaxLength(100)]
        public string Name { get; set; }

        [Required]
        [EmailAddress]
        [MaxLength(150)]
        public string Email { get; set; }

        [Required]
        [MaxLength(255)]
        public string PasswordHash { get; set; } // Store hashed password

        [Required]
        [MaxLength(50)]
        public string Role { get; set; } // "User", "Vendor", "Worker"
    }
}