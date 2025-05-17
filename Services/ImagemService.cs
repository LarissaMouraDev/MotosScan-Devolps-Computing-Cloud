using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace MotoScan.Services
{
    public class ImagemService
    {
        private readonly string _baseDir;

        public ImagemService(IWebHostEnvironment env)
        {
            _baseDir = Path.Combine(env.WebRootPath, "Imagens");

            // Garantir que os diretórios existam
            if (!Directory.Exists(Path.Combine(_baseDir, "Checkin")))
                Directory.CreateDirectory(Path.Combine(_baseDir, "Checkin"));

            if (!Directory.Exists(Path.Combine(_baseDir, "Checkout")))
                Directory.CreateDirectory(Path.Combine(_baseDir, "Checkout"));
        }

        public async Task<string> SalvarImagem(IFormFile arquivo, string tipo)
        {
            if (arquivo == null || arquivo.Length == 0)
                return null;

            var diretorio = Path.Combine(_baseDir, tipo);

            // Criar um nome de arquivo único
            var nomeArquivo = $"{Guid.NewGuid()}_{arquivo.FileName}";
            var caminhoCompleto = Path.Combine(diretorio, nomeArquivo);

            // Salvar o arquivo
            using (var stream = new FileStream(caminhoCompleto, FileMode.Create))
            {
                await arquivo.CopyToAsync(stream);
            }

            return nomeArquivo;
        }

        public string AnalisarImagem(string caminhoImagem)
        {
            // Simulação de análise de imagem
            // Em produção, aqui você chamaria AWS Rekognition ou similar
            return "Análise de imagem simulada: Moto identificada";
        }
    }
}