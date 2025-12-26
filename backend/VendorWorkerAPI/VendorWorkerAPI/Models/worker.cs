using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VendorWorkerAPI.Models
{
    public class Worker
    {
        [Key]
        [Column("WorkerId")]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        [Required, EmailAddress]
        public string Email { get; set; }

        // maps to SQL column: Password
        [Required]
        [Column("Password")]
        public string PasswordHash { get; set; }

        public string Phone { get; set; }

        // maps to SQL column: Category
        [Column("Category")]
        public string Skill { get; set; }

        // optional (not in DB yet)
        [NotMapped]
        public string Address { get; set; }

        // optional (not in DB yet)
        [NotMapped]
        public string Role { get; set; } = "Worker";
    }
}