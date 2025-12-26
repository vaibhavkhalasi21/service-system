using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VendorWorkerAPI.Models
{
    public class Application
    {
        [Key]
        public int ApplicationId { get; set; }

        [Required]
        public int BookingId { get; set; }

        [Required]
        public int WorkerId { get; set; }

        public string Status { get; set; } = "Pending";
        // Pending, Approved, Rejected

        public DateTime AppliedDate { get; set; } = DateTime.Now;

        // Navigation Properties (Optional but good)
        [ForeignKey("BookingId")]
        public Booking Booking { get; set; }

        [ForeignKey("WorkerId")]
        public User Worker { get; set; }
    }
}