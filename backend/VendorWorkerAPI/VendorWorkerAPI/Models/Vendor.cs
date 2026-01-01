using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Vendor
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Name is required")]
        [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [StringLength(150)]
        public string Email { get; set; }

        [Required(ErrorMessage = "Password hash is required")]
        [StringLength(255)]
        public string PasswordHash { get; set; } // 🔐 HASHED ONLY

        [Required(ErrorMessage = "Phone number is required")]
        [RegularExpression(@"^[6-9]\d{9}$", ErrorMessage = "Invalid phone number")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "Service type is required")]
        [StringLength(100)]
        public string ServiceType { get; set; }

        [Required(ErrorMessage = "Address is required")]
        [StringLength(250)]
        public string Address { get; set; }

        [Required]
        [RegularExpression("^Vendor$", ErrorMessage = "Invalid role")]
        public string Role { get; set; } = "Vendor";
    }
}