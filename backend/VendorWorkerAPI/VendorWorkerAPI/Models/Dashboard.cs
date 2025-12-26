using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Dashboard
    {
        [Key]
        public int Id { get; set; }

        public int TotalAdmins { get; set; }
        public int TotalVendors { get; set; }
        public int TotalWorkers { get; set; }

        public int TotalBookings { get; set; }
        public int TotalServices { get; set; }

        public decimal TotalRevenue { get; set; }
    }
}