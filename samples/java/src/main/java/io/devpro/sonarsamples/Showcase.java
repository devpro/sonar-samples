package io.devpro.sonarsamples;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;

/**
 * Deliberate issues, kept in one class so the SonarQube dashboard has something to show on a first run.
 *
 * <p>Every rule referenced here was verified to actually fire against SonarQube Community.
 * Rules that depend on the analyser <em>proving</em> a condition (such as division by zero) are avoided on purpose: they stay silent on simple sample code and make it look as though analysis did nothing.
 */
public class Showcase {

    /** S2068 (Vulnerability): hard-coded credentials. */
    private static final String PASSWORD = "admin-super-secret-2026";

    /** S4790: weak hashing algorithm (Security Hotspot). */
    public String hashPassword(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            return HexFormat.of().formatHex(digest.digest(value.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException e) {
            // Swallowing an exception is a genuine smell, but note that neither S2486 nor S108 fires here: both rules suppress when the block contains a comment.
            // Left as-is precisely to show that reading the rule description matters more than assuming.
        }
        return "";
    }

    /** S1192: the same string literal is duplicated three or more times. */
    public String describeRole(String role) {
        if ("administrator".equals(role)) {
            return "administrator";
        }
        if ("auditor".equals(role)) {
            return "administrator";
        }
        return "administrator";
    }

    /** S3776: cognitive complexity above the threshold; S1066: mergeable ifs. */
    public String classify(int a, int b, int c, int d) {
        if (a > 0) {
            if (b > 0) {
                if (c > 0) {
                    if (d > 0) {
                        return "all-positive";
                    } else if (d < 0) {
                        return "d-negative";
                    }
                } else if (c < 0) {
                    if (d > 0) {
                        return "c-negative";
                    }
                }
            } else if (b < 0) {
                if (c > 0) {
                    return "b-negative";
                } else if (c < 0) {
                    if (d < 0) {
                        return "bcd-negative";
                    }
                }
            }
        } else if (a < 0) {
            if (b > 0) {
                return "a-negative";
            } else if (b < 0) {
                if (c > 0) {
                    return "ab-negative";
                }
            }
        }
        return "unclassified";
    }

    /** Exposes the credential so the field is not simply reported as unused. */
    public String getPassword() {
        return PASSWORD;
    }

    // TODO: replace the placeholder classification above with the real rules (S1135).
}
