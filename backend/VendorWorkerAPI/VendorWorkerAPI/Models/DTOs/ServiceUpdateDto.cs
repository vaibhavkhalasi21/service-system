public class ServiceUpdateDto
{
    public string ServiceName { get; set; } = null!;
    public string Category { get; set; } = null!;
    public decimal Price { get; set; }
    public DateTime ServiceDateTime { get; set; }
    public string? Description { get; set; }
    public IFormFile? Image { get; set; }
}
