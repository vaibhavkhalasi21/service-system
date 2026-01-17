using VendorWorkerAPI.Models;

public class ServiceUpdateDto
{
    public string ServiceName { get; set; } = null!;
    public ServiceCategory Category { get; set; }
    public decimal Price { get; set; }
    public DateTime ServiceDateTime { get; set; }
    public string? Description { get; set; }
    public string? ImageUrl { get; set; }
}
