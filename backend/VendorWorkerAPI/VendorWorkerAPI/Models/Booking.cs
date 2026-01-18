using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VendorWorkerAPI.Models
{
    public class Booking
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ServiceId { get; set; }

        [Required]
        public int VendorId { get; set; }

        [Required]
        public int WorkerId { get; set; }

        public string Status { get; set; } = "Pending";

        public decimal AgreedPrice { get; set; }

        public ServiceCategory Category { get; set; }


        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // ================= NAVIGATION =================
        [ForeignKey(nameof(ServiceId))]
        public Service Service { get; set; } = null!;

        [ForeignKey(nameof(VendorId))]
        public Vendor? Vendor { get; set; } = null!;

        [ForeignKey(nameof(WorkerId))]
        public User Worker { get; set; } = null!;

        public string PaymentStatus { get; set; } = "Pending"; // Pending / Paid
        public string? PaymentMethod { get; set; }             // Cash / Online (Demo)

    }
}
