using System;
using System.Linq;
using MotosScan.Models;

namespace MotosScan.Data
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

            // Criar dados iniciais com modelos reais da Mottu
            var motos = new Moto[]
            {
                new Moto
                {
                    Modelo = "Honda CG 160",
                    Placa = "ABC1234",
                    Estado = "Bom",
                    Localizacao = "Pátio A",
                    UltimoCheckIn = DateTime.Now.AddDays(-5)
                },
                new Moto
                {
                    Modelo = "Honda Pop 110i",
                    Placa = "DEF5678",
                    Estado = "Excelente",
                    Localizacao = "Pátio B",
                    UltimoCheckIn = DateTime.Now.AddDays(-3)
                },
                new Moto
                {
                    Modelo = "Mottu Sport 110i",
                    Placa = "GHI9012",
                    Estado = "Regular",
                    Localizacao = "Pátio A",
                    UltimoCheckIn = DateTime.Now.AddDays(-7),
                    UltimoCheckOut = DateTime.Now.AddDays(-1)
                },
                new Moto
                {
                    Modelo = "Mottu-e",
                    Placa = "JKL3456",
                    Estado = "Bom",
                    Localizacao = "Saída",
                    UltimoCheckIn = DateTime.Now.AddDays(-10),
                    UltimoCheckOut = DateTime.Now.AddHours(-2)
                },
                new Moto
                {
                    Modelo = "Honda Biz 125",
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