using System;
using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Payment
    {
        [Key]
        public int PaymentId { get; set; }

        [Required]
        public string UserName { get; set; }

        [Required]
        public decimal Amount { get; set; }

        [Required]
        public string PaymentMethod { get; set; }   // UPI, Card, Cash

        public string Status { get; set; }          // Success, Failed

        public DateTime PaymentDate { get; set; } = DateTime.Now;
    }
}