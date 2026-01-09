using System;
using System.ComponentModel.DataAnnotations;
using VendorWorkerAPI.Models;   // 👈 THIS IS THE FIX

namespace VendorWorkerAPI.Models
{
    public class Application
    {
        [Key]
        public int Id { get; set; }

        public int ServiceId { get; set; }
        public Service Service { get; set; } = null!;

        public int VendorId { get; set; }
        public Vendor Vendor { get; set; } = null!;

        public int WorkerId { get; set; }
        public Worker Worker { get; set; } = null!;

        public string Status { get; set; } = "Pending";

        public string PaymentStatus { get; set; } = "Pending";

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
