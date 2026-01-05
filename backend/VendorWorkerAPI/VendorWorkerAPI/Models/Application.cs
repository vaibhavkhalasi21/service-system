using VendorWorkerAPI.Models;

public class Application
{
    public int Id { get; set; }

    public int ServiceId { get; set; }

    // 🔥 FIX HERE
    public int WorkerId { get; set; }   // ✅ INT

    public int VendorId { get; set; }

    public string Status { get; set; } = "Pending";

    public DateTime CreatedAt { get; set; }

    // Navigation
    public User Worker { get; set; }
    public Service Service { get; set; }
}
