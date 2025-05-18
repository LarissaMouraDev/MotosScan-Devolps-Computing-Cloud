using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using MotosScan.Data;
using MotosScan.Data;
using MotosScan.Services;

var builder = WebApplication.CreateBuilder(args);

// Adicionar serviços ao container
builder.Services.AddControllers();

// Configurar Entity Framework com SQLite
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("SqliteConnection")));

// Registrar serviços
builder.Services.AddScoped<ImagemService>();

// Configurar Swagger/OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "MotosScan API",
        Version = "v1",
        Description = "API para gerenciamento de frota de motos da Mottu",
        Contact = new OpenApiContact
        {
            Name = "Equipe MotosScan",
            Email = "equipe@motosscan.com"
        }
    });
});

var app = builder.Build();

// Configurar pipeline de requisições HTTP
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

// Ativar Swagger em todos os ambientes
app.UseSwagger();
app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "MotosScan API v1"));

// Criar o banco de dados e inicializar com dados de exemplo
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<AppDbContext>();
        // Garantir que o banco seja criado
        context.Database.EnsureCreated();
        // Inicializar com dados de exemplo
        DbInitializer.Initialize(context);
        Console.WriteLine("Banco de dados criado e inicializado com sucesso!");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Erro ao inicializar o banco de dados: {ex.Message}");
    }
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();
app.MapControllers();

app.Run();