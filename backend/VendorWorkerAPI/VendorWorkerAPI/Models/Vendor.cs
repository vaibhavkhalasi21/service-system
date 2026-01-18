using System.ComponentModel.DataAnnotations;
using VendorWorkerAPI.Models;

public class Vendor
{
    [Key]
    public int Id { get; set; }

    public string Name { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string PasswordHash { get; set; } = null!;
    public string Phone { get; set; } = null!;
    public string ServiceType { get; set; } = null!;
    public string Address { get; set; } = null!;
    public string Role { get; set; } = "Vendor";
    public bool IsActive { get; set; } = true;

    
}
