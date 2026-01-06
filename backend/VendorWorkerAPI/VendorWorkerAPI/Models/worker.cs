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
}
