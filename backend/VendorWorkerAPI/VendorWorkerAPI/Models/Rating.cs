using System;
using System.ComponentModel.DataAnnotations;

namespace VendorWorkerAPI.Models
{
    public class Rating
    {
        [Key]
        public int RatingId { get; set; }

        [Required]
        public int WorkerId { get; set; }

        [Required]
        public string UserName { get; set; }

        [Range(1, 5)]
        public int Stars { get; set; }   // 1 to 5

        public string Comment { get; set; }

        public DateTime RatingDate { get; set; } = DateTime.Now;
    }
}