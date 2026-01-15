using System.ComponentModel.DataAnnotations;

public class Worker
{
    [Key]
    public int Id { get; set; }   // ❗ WorkerId नहीं

    public string Name { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string Phone { get; set; } = null!;
    public string Skill { get; set; } = null!;
    public string Address { get; set; } = null!;
    public string PasswordHash { get; set; } = null!;
    public string Role { get; set; } = "Worker";

    public bool IsActive { get; set; } = true;

    public double Latitude { get; set; }
    public double Longitude { get; set; }

    public DateTime? LocationUpdatedAt { get; set; }


}
