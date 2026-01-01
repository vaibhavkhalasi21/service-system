using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models.DTOs
{
    public class VendorRegisterDto
    {
        [Required(ErrorMessage = "Name is required")]
        [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [StringLength(150)]
        public string Email { get; set; }

        [Required(ErrorMessage = "Password is required")]
        [MinLength(6, ErrorMessage = "Password must be at least 6 characters")]
        [MaxLength(50, ErrorMessage = "Password cannot exceed 50 characters")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Phone number is required")]
        [RegularExpression(@"^[6-9]\d{9}$", ErrorMessage = "Invalid Indian phone number")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "Service type is required")]
        [StringLength(100, ErrorMessage = "Service type cannot exceed 100 characters")]
        public string ServiceType { get; set; }

        [Required(ErrorMessage = "Address is required")]
        [StringLength(250, ErrorMessage = "Address cannot exceed 250 characters")]
        public string Address { get; set; }
    }
}