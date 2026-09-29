namespace SonarSamples.Api;

public static class MathService
{
    /// <summary>Adds two integers.</summary>
    public static int Add(int a, int b) => a + b;

    /// <summary>Subtracts b from a.</summary>
    public static int Subtract(int a, int b) => a - b;

    /// <summary>Returns a greeting string.</summary>
    public static string Greet(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            name = "world";
        }

        return $"Hello, {name}!";
    }

    /// <summary>Divides a by b.</summary>
    public static double Divide(double a, double b) => a / b;
}
