using System;
using System.ComponentModel.DataAnnotations;

namespace MotoScan.Models
{
    public class Moto
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Modelo { get; set; }

        [Required]
        [StringLength(20)]
        public string Placa { get; set; }

        [StringLength(50)]
        public string Estado { get; set; }

        [StringLength(100)]
        public string Localizacao { get; set; }

        public DateTime? UltimoCheckIn { get; set; }

        public DateTime? UltimoCheckOut { get; set; }

        [StringLength(255)]
        public string ImagemUrl { get; set; }
    }
}