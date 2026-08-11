package io.devpro.sonarsamples;

/**
 * Simple arithmetic and string utilities.
 * The deliberate issues live in {@link Showcase}.
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
        return "Hello, " + name + "!";
    }

    /** Divides a by b. */
    public double divide(double a, double b) {
        return a / b;
    }
}
