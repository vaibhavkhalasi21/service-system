using Microsoft.EntityFrameworkCore;
using VendorWorkerAPI.Models;

namespace VendorWorkerAPI.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Service> Services { get; set; }
        public DbSet<Booking> Bookings { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<Rating> Ratings { get; set; }
        public DbSet<Application> Applications { get; set; }
        public DbSet<Vendor> Vendors { get; set; }
        public DbSet<Worker> Workers { get; set; }
        public DbSet<Admin> Admins { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Worker>()
                .HasIndex(w => w.Email)
                .IsUnique();

            base.OnModelCreating(modelBuilder);
        }
    }
}