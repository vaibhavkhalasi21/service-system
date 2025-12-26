using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Vendor
    {
        [Key]
        public int Id { get; set; }

        [Required, MaxLength(100)]
        public string Name { get; set; }

        [Required, EmailAddress, MaxLength(150)]
        public string Email { get; set; }

        [Required, MaxLength(255)]
        public string PasswordHash { get; set; } // 🔐 HASHED (IMPORTANT)

        public string Phone { get; set; }
        public string ServiceType { get; set; }
        public string Address { get; set; }

        // 🔑 JWT ROLE
        [Required]
        public string Role { get; set; } = "Vendor";
    }
}
