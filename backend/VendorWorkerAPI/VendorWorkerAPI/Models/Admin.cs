using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Admin
    {
        [Key]
        public int AdminId { get; set; }

        [Required(ErrorMessage = "Name is required")]
        [StringLength(50, MinimumLength = 3)]
        public string Name { get; set; }

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress]
        [StringLength(100)]
        public string Email { get; set; }

        // 🔐 Store HASHED password
        [Required]
        public string PasswordHash { get; set; }

        [Required]
        public string Role { get; set; } = "Admin";
    }
}