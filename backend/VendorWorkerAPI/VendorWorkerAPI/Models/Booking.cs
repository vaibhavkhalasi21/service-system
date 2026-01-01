using System;
using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Booking
    {
        [Key]
        public int Id { get; set; }

        // 🔐 Logged-in Customer Id (from JWT)
        [Required(ErrorMessage = "CustomerId is required")]
        [StringLength(100, ErrorMessage = "Invalid CustomerId")]
        public string CustomerId { get; set; }

        // 🔗 Service reference
        [Required(ErrorMessage = "ServiceId is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid ServiceId")]
        public int ServiceId { get; set; }

        // 📌 Pending / Accepted / Completed / Cancelled
        [Required(ErrorMessage = "Status is required")]
        [StringLength(20)]
        [RegularExpression("Pending|Accepted|Completed|Cancelled",
            ErrorMessage = "Status must be Pending, Accepted, Completed, or Cancelled")]
        public string Status { get; set; }

        // ⏱ Auto set at booking creation
        [Required]
        public DateTime CreatedAt { get; set; }
    }
}