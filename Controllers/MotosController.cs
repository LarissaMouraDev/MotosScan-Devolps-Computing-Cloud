using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotosScan.Data;
using MotosScan.Models;
using MotosScan.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace MotosScan.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MotosController : ControllerBase
    {
        private readonly AppDbContext _dbContext;
        private readonly ImagemService _imagemService;

        public MotosController(AppDbContext dbContext, ImagemService imagemService)
        {
            _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
            _imagemService = imagemService ?? throw new ArgumentNullException(nameof(imagemService));
        }

        // GET: api/Motos
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Moto>>> GetMotos()
        {
            return await _dbContext.Motos.ToListAsync();
        }

        // GET: api/Motos/5
        [HttpGet("{id:int}")]
        public async Task<ActionResult<Moto>> GetMoto(int id)
        {
            var moto = await _dbContext.Motos.FindAsync(id);

            if (moto == null)
            {
                return NotFound();
            }

            return moto;
        }

        // GET: api/Motos/placa/ABC1234
        [HttpGet("placa/{placa}")]
        public async Task<ActionResult<Moto>> GetMotoByPlaca(string placa)
        {
            var moto = await _dbContext.Motos.FirstOrDefaultAsync(m => m.Placa == placa);

            if (moto == null)
            {
                return NotFound();
            }

            return moto;
        }

        // POST: api/Motos
        [HttpPost]
        public async Task<ActionResult<Moto>> PostMoto(Moto moto)
        {
            _dbContext.Motos.Add(moto);
            await _dbContext.SaveChangesAsync();

            return CreatedAtAction(nameof(GetMoto), new { id = moto.Id }, moto);
        }

        // PUT: api/Motos/5
        [HttpPut("{id:int}")]
        public async Task<IActionResult> PutMoto(int id, Moto moto)
        {
            if (id != moto.Id)
            {
                return BadRequest();
            }

            _dbContext.Entry(moto).State = EntityState.Modified;

            try
            {
                await _dbContext.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MotoExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: api/Motos/5
        [HttpDelete("{id:int}")]
        public async Task<IActionResult> DeleteMoto(int id)
        {
            var moto = await _dbContext.Motos.FindAsync(id);
            if (moto == null)
            {
                return NotFound();
            }

            _dbContext.Motos.Remove(moto);
            await _dbContext.SaveChangesAsync();

            return NoContent();
        }

        // POST: api/Motos/checkin
        [HttpPost("checkin")]
        public async Task<IActionResult> CheckIn(IFormFile imagem, [FromQuery] string placa)
        {
            if (imagem == null || imagem.Length == 0)
            {
                return BadRequest("Imagem não fornecida");
            }

            // Buscar moto pela placa
            var moto = await _dbContext.Motos.FirstOrDefaultAsync(m => m.Placa == placa);
            if (moto == null)
            {
                return NotFound($"Moto com placa {placa} não encontrada");
            }

            // Salvar a imagem
            var nomeArquivo = await _imagemService.SalvarImagem(imagem, "Checkin");

            // Atualizar informações de check-in
            moto.UltimoCheckIn = DateTime.Now;
            moto.Localizacao = "Pátio A"; // Em produção, seria o resultado da análise da imagem
            moto.ImagemUrl = nomeArquivo;

            _dbContext.Entry(moto).State = EntityState.Modified;
            await _dbContext.SaveChangesAsync();

            return Ok(new
            {
                mensagem = "Check-in realizado com sucesso",
                dataHora = moto.UltimoCheckIn,
                localizacao = moto.Localizacao
            });
        }

        // POST: api/Motos/checkout
        [HttpPost("checkout")]
        public async Task<IActionResult> CheckOut(IFormFile imagem, [FromQuery] string placa)
        {
            if (imagem == null || imagem.Length == 0)
            {
                return BadRequest("Imagem não fornecida");
            }

            // Buscar moto pela placa
            var moto = await _dbContext.Motos.FirstOrDefaultAsync(m => m.Placa == placa);
            if (moto == null)
            {
                return NotFound($"Moto com placa {placa} não encontrada");
            }

            // Salvar a imagem
            var nomeArquivo = await _imagemService.SalvarImagem(imagem, "Checkout");

            // Atualizar informações de check-out
            moto.UltimoCheckOut = DateTime.Now;
            moto.Localizacao = "Saída"; // Em produção, seria o resultado da análise da imagem

            _dbContext.Entry(moto).State = EntityState.Modified;
            await _dbContext.SaveChangesAsync();

            return Ok(new
            {
                mensagem = "Check-out realizado com sucesso",
                dataHora = moto.UltimoCheckOut
            });
        }

        private bool MotoExists(int id)
        {
            return _dbContext.Motos.Any(e => e.Id == id);
        }
    }
}