package io.devpro.sonarsamples;

/**
 * Simple arithmetic and string utilities.
 * Contains intentional issues for SonarQube to detect.
 */
public class MathService {

    /** Returns the sum of a and b. */
    public int add(int a, int b) {
        return a + b;
    }

    /** Returns a minus b. */
    public int subtract(int a, int b) {
        return a - b;
    }

    /**
     * Returns a greeting string.
     * Falls back to "world" when name is null or blank.
     */
    public String greet(String name) {
        if (name == null || name.isBlank()) {
            name = "world";
        }
        // Intentional code smell: string concatenation instead of formatted string
        return "Hello, " + name + "!";
    }

    /**
     * Divides a by b.
     * Intentional issue: no guard against division by zero — Sonar S3518 will flag this.
     */
    public double divide(double a, double b) {
        return a / b;
    }
}
