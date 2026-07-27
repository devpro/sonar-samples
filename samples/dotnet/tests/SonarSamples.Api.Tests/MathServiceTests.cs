using SonarSamples.Api;

namespace SonarSamples.Api.Tests;

public class MathServiceTests
{
    [Fact]
    public void Add_ReturnsCorrectSum()
    {
        var result = MathService.Add(2, 3);
        Assert.Equal(5, result);
    }

    [Fact]
    public void Add_HandlesNegativeNumbers()
    {
        var result = MathService.Add(-1, 1);
        Assert.Equal(0, result);
    }

    [Fact]
    public void Subtract_ReturnsCorrectDifference()
    {
        var result = MathService.Subtract(10, 4);
        Assert.Equal(6, result);
    }

    [Theory]
    [InlineData("Bertrand", "Hello, Bertrand!")]
    [InlineData("world", "Hello, world!")]
    public void Greet_ReturnsExpectedMessage(string name, string expected)
    {
        var result = MathService.Greet(name);
        Assert.Equal(expected, result);
    }

    [Fact]
    public void Greet_FallsBackToWorld_WhenNameIsEmpty()
    {
        var result = MathService.Greet(string.Empty);
        Assert.Equal("Hello, world!", result);
    }
}
