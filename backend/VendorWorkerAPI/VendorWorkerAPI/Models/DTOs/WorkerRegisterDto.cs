using System.ComponentModel.DataAnnotations;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Models.DTOs
{
    public class WorkerRegisterDto
    {
        [Required(ErrorMessage = "Name is required")]
        [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters")]
        public string Name { get; set; } = null!;

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [StringLength(150, ErrorMessage = "Email cannot exceed 150 characters")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "Password is required")]
        [MinLength(6, ErrorMessage = "Password must be at least 6 characters")]
        [MaxLength(50, ErrorMessage = "Password cannot exceed 50 characters")]
        public string Password { get; set; } = null!;

        [Required(ErrorMessage = "Phone number is required")]
        [RegularExpression(@"^[6-9]\d{9}$", ErrorMessage = "Invalid Indian phone number")]
        public string Phone { get; set; } = null!;

        // 🔐 MAIN CHANGE: CATEGORY (ENUM)
        [Required(ErrorMessage = "Service category is required")]
        [EnumDataType(typeof(ServiceCategory), ErrorMessage = "Invalid service category")]
        public ServiceCategory Category { get; set; }

        [Required(ErrorMessage = "Address is required")]
        [StringLength(250, ErrorMessage = "Address cannot exceed 250 characters")]
        public string Address { get; set; } = null!;
    }
}
