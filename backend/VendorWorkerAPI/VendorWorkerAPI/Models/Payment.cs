using System;
using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Payment
    {
        [Key]
        public int PaymentId { get; set; }

        [Required(ErrorMessage = "User name is required")]
        [StringLength(100, ErrorMessage = "User name cannot exceed 100 characters")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Amount is required")]
        [Range(1, double.MaxValue, ErrorMessage = "Amount must be greater than 0")]
        public decimal Amount { get; set; }

        [Required(ErrorMessage = "Payment method is required")]
        [StringLength(50)]
        public string PaymentMethod { get; set; }   // UPI, Card, Cash

        [StringLength(20)]
        public string Status { get; set; } = "Success";   // Success / Failed

        [Required]
        public DateTime PaymentDate { get; set; } = DateTime.Now;
    }
}