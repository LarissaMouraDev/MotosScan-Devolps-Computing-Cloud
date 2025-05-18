using System;
using System.ComponentModel.DataAnnotations;

namespace MotosScan.Models
{
    public class Moto
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Modelo { get; set; } = string.Empty;

        [Required]
        [StringLength(20)]
        public string Placa { get; set; } = string.Empty;

        [StringLength(50)]
        public string Estado { get; set; } = "Bom";

        [StringLength(100)]
        public string Localizacao { get; set; } = "Pátio A";

        public DateTime? UltimoCheckIn { get; set; }

        public DateTime? UltimoCheckOut { get; set; }

        [StringLength(255)]
        public string? ImagemUrl { get; set; }
    }
}