using System.Security.Cryptography;
using System.Text;

namespace SonarSamples.Api;

/// <summary>
/// Deliberate issues, kept in one class so the SonarQube dashboard has something to show on a first run.
/// <para>
/// Every rule referenced here was verified to actually fire against SonarQube Community.
/// Rules that depend on the analyser <em>proving</em> a condition (such as division by zero) are avoided on purpose: they stay silent on simple sample code and make it look as though analysis did nothing.
/// </para>
/// </summary>
public class Showcase
{
    /// <summary>S2068 (Vulnerability): hard-coded credentials.</summary>
    private const string Password = "admin-super-secret-2026";

    /// <summary>S4790: weak hashing algorithm (Security Hotspot).</summary>
    public string HashPassword(string value)
    {
        using var md5 = MD5.Create();
        return Convert.ToHexString(md5.ComputeHash(Encoding.UTF8.GetBytes(value)));
    }

    /// <summary>S1192: the same string literal is duplicated three or more times.</summary>
    public string DescribeRole(string role)
    {
        if (role == "administrator")
        {
            return "administrator";
        }

        if (role == "auditor")
        {
            return "administrator";
        }

        return "administrator";
    }

    /// <summary>S3776: cognitive complexity above the threshold; S1066: mergeable ifs.</summary>
    public string Classify(int a, int b, int c, int d)
    {
        if (a > 0)
        {
            if (b > 0)
            {
                if (c > 0)
                {
                    if (d > 0)
                    {
                        return "all-positive";
                    }
                    else if (d < 0)
                    {
                        return "d-negative";
                    }
                }
                else if (c < 0)
                {
                    if (d > 0)
                    {
                        return "c-negative";
                    }
                }
            }
            else if (b < 0)
            {
                if (c > 0)
                {
                    return "b-negative";
                }
                else if (c < 0)
                {
                    if (d < 0)
                    {
                        return "bcd-negative";
                    }
                }
            }
        }
        else if (a < 0)
        {
            if (b > 0)
            {
                return "a-negative";
            }
            else if (b < 0)
            {
                if (c > 0)
                {
                    return "ab-negative";
                }
            }
        }

        return "unclassified";
    }

    /// <summary>Exposes the credential so the field is not simply reported as unused.</summary>
    public string GetPassword() => Password;

    // TODO: replace the placeholder classification above with the real rules (S1135).
}
