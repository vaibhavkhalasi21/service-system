using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Booking
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ServiceId { get; set; }

        // 🔥 MUST BE STRING
        [Required]
        public string VendorId { get; set; } = null!;

        // 🔥 MUST BE STRING
        [Required]
        public string WorkerId { get; set; } = null!;

        public string Status { get; set; } = "Pending";
    }
}
