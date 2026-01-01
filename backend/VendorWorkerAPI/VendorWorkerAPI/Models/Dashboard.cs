using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Dashboard
    {
        [Range(0, int.MaxValue)]
        public int TotalAdmins { get; set; }

        [Range(0, int.MaxValue)]
        public int TotalVendors { get; set; }

        [Range(0, int.MaxValue)]
        public int TotalWorkers { get; set; }

        [Range(0, int.MaxValue)]
        public int TotalBookings { get; set; }

        [Range(0, int.MaxValue)]
        public int TotalServices { get; set; }

        [Range(0, double.MaxValue)]
        public decimal TotalRevenue { get; set; }
    }
}