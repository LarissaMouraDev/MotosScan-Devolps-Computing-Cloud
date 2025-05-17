using Microsoft.EntityFrameworkCore;
using MotoScan.Models;

namespace MotoScan.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Moto> Motos { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configuração de índices e restrições
            modelBuilder.Entity<Moto>()
                .HasIndex(m => m.Placa)
                .IsUnique();
        }
    }
}