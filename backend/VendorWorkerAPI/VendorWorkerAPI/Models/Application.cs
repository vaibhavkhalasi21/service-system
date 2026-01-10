using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Application
    {
        [Key]
        public int Id { get; set; }

        // ================= RELATIONS =================
        public int ServiceId { get; set; }
        public Service Service { get; set; } = null!;

        public int WorkerId { get; set; }
        public Worker Worker { get; set; } = null!;

        public int VendorId { get; set; }
        public Vendor Vendor { get; set; } = null!;

        // ================= STATUS =================
        public string Status { get; set; } = "Pending";
        public string PaymentStatus { get; set; } = "Pending";

        // ================= RATINGS =================
        public int? VendorRating { get; set; }   // Vendor → Worker
        public bool VendorRated { get; set; } = false;

        public int? WorkerRating { get; set; }   // Worker → Vendor
        public bool WorkerRated { get; set; } = false;

        // ================= TIMESTAMPS =================
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
