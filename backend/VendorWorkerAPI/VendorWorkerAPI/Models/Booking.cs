using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VendorWorkerAPI.Models
{
    public class Booking
    {
        [Key]
        public int Id { get; set; }

        // 🔐 Logged-in Customer Id (from JWT)
        [Required]
        public string CustomerId { get; set; }

        // 🔗 Service reference
        [Required]
        public int ServiceId { get; set; }

        // 📌 Pending / Accepted / Completed
        [Required]
        [MaxLength(20)]
        public string Status { get; set; }

        // ⏱ Auto set at booking creation
        [Required]
        public DateTime CreatedAt { get; set; }
    }
}
