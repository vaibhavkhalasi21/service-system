using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class User
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
        public string PasswordHash { get; set; }

        [Required(ErrorMessage = "Role is required")]
        [RegularExpression("^(Customer|Vendor|Worker|Admin)$",
            ErrorMessage = "Invalid role")]
        public string Role { get; set; }
    }
}