using Xunit;

using SonarSamples.Api;

namespace SonarSamples.Api.Tests;

public class ShowcaseTests
{
    private readonly Showcase _showcase = new();

    [Fact]
    public void DescribeRole_ReturnsLabel()
    {
        Assert.Equal("administrator", _showcase.DescribeRole("administrator"));
    }

    [Fact]
    public void Classify_AllPositive()
    {
        Assert.Equal("all-positive", _showcase.Classify(1, 1, 1, 1));
    }

    [Fact]
    public void Classify_Unclassified()
    {
        Assert.Equal("unclassified", _showcase.Classify(0, 0, 0, 0));
    }

    [Fact]
    public void HashPassword_ReturnsHexDigest()
    {
        Assert.Equal(32, _showcase.HashPassword("x").Length);
    }

    [Fact]
    public void GetPassword_IsExposed()
    {
        Assert.NotEmpty(_showcase.GetPassword());
    }
}
