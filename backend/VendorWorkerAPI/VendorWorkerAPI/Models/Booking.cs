using System;
using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Booking
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ServiceId { get; set; }

        [Required]
        public string VendorId { get; set; } = null!;

        [Required]
        public string WorkerId { get; set; } = null!;

        [Required]
        [StringLength(20)]
        public string Status { get; set; } = "Pending";

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
