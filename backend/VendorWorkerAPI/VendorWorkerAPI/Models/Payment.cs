using System;

namespace VendorWorkerAPI.Models
{
    public class Payment
    {
        public int Id { get; set; }

        public int BookingId { get; set; }

        public int ApplicationId { get; set; }

        public int VendorId { get; set; }
        public int WorkerId { get; set; }

        public decimal Amount { get; set; }

        public ServiceCategory Category { get; set; }

        // ================= PAYMENT STATUS =================
        public string Status { get; set; } = "PENDING"; // PENDING / SUCCESS / FAILED
        public string PaymentMethod { get; set; } = "Online (Demo)"; // Cash / Online (Demo)
        public string EscrowStatus { get; set; } = "HELD"; // HELD / RELEASED

        // ================= TIMESTAMPS =================
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? ReleasedAt { get; set; }
    }
}
