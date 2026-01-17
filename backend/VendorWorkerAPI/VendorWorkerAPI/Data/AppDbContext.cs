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

        public DbSet<Booking> Bookings { get; set; }
        public DbSet<Payment> Payments { get; set; }


        public DbSet<User> Users { get; set; }
        public DbSet<Service> Services { get; set; } // ✅
        

        public DbSet<Rating> Ratings { get; set; }
        public DbSet<Application> Applications { get; set; }
        public DbSet<Vendor> Vendors { get; set; }
        public DbSet<Worker> Workers { get; set; }
        public DbSet<Admin> Admins { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // ===== MONEY PRECISION (IMPORTANT) =====
            modelBuilder.Entity<Booking>()
                .Property(b => b.AgreedPrice)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Payment>()
                .Property(p => p.Amount)
                .HasPrecision(18, 2);

            // ===== APPLICATION RELATIONS =====
            modelBuilder.Entity<Application>()
                .HasOne(a => a.Worker)
                .WithMany()
                .HasForeignKey(a => a.WorkerId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Application>()
                .HasOne(a => a.Vendor)
                .WithMany()
                .HasForeignKey(a => a.VendorId)
                .OnDelete(DeleteBehavior.NoAction);

            // ===== BOOKING RELATIONS =====
            modelBuilder.Entity<Booking>()
                .HasOne(b => b.Vendor)
                .WithMany()
                .HasForeignKey(b => b.VendorId)
                .OnDelete(DeleteBehavior.NoAction);
        }

    }
}