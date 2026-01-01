using System;
using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Rating
    {
        [Key]
        public int RatingId { get; set; }

        [Required(ErrorMessage = "WorkerId is required")]
        public int WorkerId { get; set; }

        [Required(ErrorMessage = "User name is required")]
        [StringLength(100, ErrorMessage = "User name cannot exceed 100 characters")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Stars rating is required")]
        [Range(1, 5, ErrorMessage = "Stars must be between 1 and 5")]
        public int Stars { get; set; }   // ⭐ 1–5

        [StringLength(500, ErrorMessage = "Comment cannot exceed 500 characters")]
        public string Comment { get; set; }

        [Required]
        public DateTime RatingDate { get; set; } = DateTime.Now;
    }
}