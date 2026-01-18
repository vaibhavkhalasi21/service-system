using System.ComponentModel.DataAnnotations;
using VendorWorkerAPI.Models;

public class ServiceCreateDto
{
    [Required]
    public string ServiceName { get; set; } = null!;

    // 🔥 IMPORTANT FIX
    [Required]
    [EnumDataType(typeof(ServiceCategory))]
    public int Category { get; set; }

    [Required]
    public decimal Price { get; set; }

    [Required]
    public DateTime ServiceDateTime { get; set; }

    public int? VendorId { get; set; }

    public IFormFile? Image { get; set; }

    [Required]
    public double Latitude { get; set; }

    [Required]
    public double Longitude { get; set; }

    public string? Address { get; set; }
}
