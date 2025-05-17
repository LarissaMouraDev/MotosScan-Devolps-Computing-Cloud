using System;
using System.Linq;
using MotoScan.Models;

namespace MotoScan.Data
{
    public static class DbInitializer
    {
        public static void Initialize(AppDbContext context)
        {
            context.Database.EnsureCreated();

            // Verificar se já existem motos cadastradas
            if (context.Motos.Any())
            {
                return; // DB já foi populado
            }

            // Criar dados iniciais (5 inserts com conteúdo significativo)
            var motos = new Moto[]
            {
                new Moto
                {
                    Modelo = "Honda CB 500",
                    Placa = "ABC1234",
                    Estado = "Bom",
                    Localizacao = "Pátio A",
                    UltimoCheckIn = DateTime.Now.AddDays(-5)
                },
                new Moto
                {
                    Modelo = "Yamaha Fazer 250",
                    Placa = "DEF5678",
                    Estado = "Excelente",
                    Localizacao = "Pátio B",
                    UltimoCheckIn = DateTime.Now.AddDays(-3)
                },
                new Moto
                {
                    Modelo = "Kawasaki Ninja 400",
                    Placa = "GHI9012",
                    Estado = "Regular",
                    Localizacao = "Pátio A",
                    UltimoCheckIn = DateTime.Now.AddDays(-7),
                    UltimoCheckOut = DateTime.Now.AddDays(-1)
                },
                new Moto
                {
                    Modelo = "Suzuki GSX-S750",
                    Placa = "JKL3456",
                    Estado = "Bom",
                    Localizacao = "Saída",
                    UltimoCheckIn = DateTime.Now.AddDays(-10),
                    UltimoCheckOut = DateTime.Now.AddHours(-2)
                },
                new Moto
                {
                    Modelo = "BMW R 1250 GS",
                    Placa = "MNO7890",
                    Estado = "Excelente",
                    Localizacao = "Pátio C",
                    UltimoCheckIn = DateTime.Now.AddDays(-1)
                }
            };

            context.Motos.AddRange(motos);
            context.SaveChanges();
        }
    }
}