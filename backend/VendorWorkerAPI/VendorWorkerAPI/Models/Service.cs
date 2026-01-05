using System;
using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Service
    {
        [Key]
        public int Id { get; set; }

        // ===============================
        // BASIC DETAILS
        // ===============================
        [Required]
        public string ServiceName { get; set; } = null!;

        [Required]
        public string Category { get; set; } = null!;

        [Required]
        public decimal Price { get; set; }

        // ===============================
        // IMAGE (OPTIONAL)
        // ===============================
        public string? ImageUrl { get; set; }

        // ===============================
        // VENDOR OWNERSHIP (CRITICAL)
        // ===============================
        [Required]
        public string VendorId { get; set; } = null!;

        // ===============================
        // STATUS
        // ===============================
        public bool IsActive { get; set; } = true;

        // ===============================
        // TIME FIELDS
        // ===============================

        // 🗓 When service is scheduled
        [Required]
        public DateTime ServiceDateTime { get; set; }

        // 🕒 When service was created
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // ✏ When service was last updated
        public DateTime? UpdatedAt { get; set; }
    }
}
