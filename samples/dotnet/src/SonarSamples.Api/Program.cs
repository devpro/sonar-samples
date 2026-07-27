using SonarSamples.Api;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/add/{a}/{b}", (int a, int b) =>
{
    var result = MathService.Add(a, b);
    return Results.Ok(new { a, b, result });
});

app.MapGet("/greet/{name}", (string name) =>
{
    var message = MathService.Greet(name);
    return Results.Ok(new { message });
});

app.Run();

// Expose for test project
public partial class Program { }
