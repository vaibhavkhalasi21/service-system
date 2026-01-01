using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VendorWorkerAPI.Models
{
    public class Application
    {
        [Key]
        public int ApplicationId { get; set; }

        [Required(ErrorMessage = "BookingId is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid BookingId")]
        public int BookingId { get; set; }

        [Required(ErrorMessage = "WorkerId is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid WorkerId")]
        public int WorkerId { get; set; }

        [Required]
        [StringLength(20)]
        [RegularExpression("Pending|Approved|Rejected",
            ErrorMessage = "Status must be Pending, Approved, or Rejected")]
        public string Status { get; set; } = "Pending";

        public DateTime AppliedDate { get; set; } = DateTime.Now;

        // ================= Navigation Properties =================
        [ForeignKey("BookingId")]
        public Booking Booking { get; set; }

        [ForeignKey("WorkerId")]
        public User Worker { get; set; }
    }
}