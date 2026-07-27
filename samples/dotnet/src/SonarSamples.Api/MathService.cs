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

        // Intentional code smell: string concatenation in a loop pattern avoided,
        // but Sonar will still flag the cognitive complexity of the null check below.
        string result = "Hello, " + name + "!";
        return result;
    }

    /// <summary>
    /// Divides a by b. Intentionally missing a zero-check so Sonar flags it.
    /// </summary>
    public static double Divide(double a, double b)
    {
        // Sonar S3217 / S2583 will flag the missing guard on b == 0
        return a / b;
    }
}
