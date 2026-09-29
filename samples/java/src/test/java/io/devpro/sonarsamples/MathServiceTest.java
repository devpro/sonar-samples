package io.devpro.sonarsamples;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import static org.junit.jupiter.api.Assertions.assertEquals;

class MathServiceTest {

    private final MathService service = new MathService();

    @Test
    void add_returnsCorrectSum() {
        assertEquals(5, service.add(2, 3));
    }

    @Test
    void add_handlesNegativeNumbers() {
        assertEquals(0, service.add(-1, 1));
    }

    @Test
    void subtract_returnsCorrectDifference() {
        assertEquals(6, service.subtract(10, 4));
    }

    @ParameterizedTest
    @CsvSource({
        // Expected values are single-quoted: they contain a comma, which is the
        // CSV delimiter and would otherwise be read as an extra argument.
        "Bertrand, 'Hello, Bertrand!'",
        "world, 'Hello, world!'"
    })
    void greet_returnsExpectedMessage(String name, String expected) {
        assertEquals(expected, service.greet(name));
    }

    @Test
    void greet_fallsBackToWorld_whenNameIsNull() {
        assertEquals("Hello, world!", service.greet(null));
    }

    @Test
    void greet_fallsBackToWorld_whenNameIsBlank() {
        assertEquals("Hello, world!", service.greet("  "));
    }
}
