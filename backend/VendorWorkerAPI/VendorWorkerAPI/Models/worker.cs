using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VendorWorkerAPI.Models
{
    public class Worker
    {
        [Key]
        [Column("WorkerId")]
        public int Id { get; set; }

        [Required(ErrorMessage = "Name is required")]
        [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [StringLength(150)]
        public string Email { get; set; }

        // Stored as hashed password
        [Required(ErrorMessage = "Password is required")]
        [Column("Password")]
        public string PasswordHash { get; set; }

        [Required(ErrorMessage = "Phone number is required")]
        [RegularExpression(@"^[6-9]\d{9}$", ErrorMessage = "Invalid phone number")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "Skill is required")]
        [StringLength(100)]
        [Column("Category")]
        public string Skill { get; set; }

        // Optional (UI only)
        [NotMapped]
        [StringLength(250)]
        public string Address { get; set; }

        // JWT Role (not stored in DB)
        [NotMapped]
        public string Role { get; set; } = "Worker";
    }
}