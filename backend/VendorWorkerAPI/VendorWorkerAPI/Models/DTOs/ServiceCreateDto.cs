using System.ComponentModel.DataAnnotations;

public class ServiceCreateDto
{
    [Required]
    public string ServiceName { get; set; } = null!;

    [Required]
    public string Category { get; set; } = null!;

    [Required]
    public decimal Price { get; set; }

    [Required]
    public DateTime ServiceDateTime { get; set; }

    public IFormFile? Image { get; set; }

    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string? Address { get; set; }

}
