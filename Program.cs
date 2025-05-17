using Microsoft.EntityFrameworkCore;
using MotoScan.Data;
using MotoScan.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();

// Configure Oracle
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseOracle(builder.Configuration.GetConnectionString("OracleConnection")));

// Add ImagemService
builder.Services.AddScoped<ImagemService>();

// Configure Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
    {
        Title = "API de Check-in/Check-out de Motos",
        Version = "v1",
        Description = "API para gerenciamento de check-in e check-out de motos"
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();

    // Inicializar o banco de dados com dados de teste
    using (var scope = app.Services.CreateScope())
    {
        var services = scope.ServiceProvider;
        var context = services.GetRequiredService<AppDbContext>();
        DbInitializer.Initialize(context);
    }
}

app.UseHttpsRedirection();
app.UseStaticFiles(); // Para servir arquivos estáticos (imagens)
app.UseAuthorization();
app.MapControllers();

app.Run();