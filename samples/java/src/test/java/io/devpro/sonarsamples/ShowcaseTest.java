package io.devpro.sonarsamples;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class ShowcaseTest {

    private final Showcase showcase = new Showcase();

    @Test
    void describeRole_returnsLabel() {
        assertEquals("administrator", showcase.describeRole("administrator"));
    }

    @Test
    void classify_allPositive() {
        assertEquals("all-positive", showcase.classify(1, 1, 1, 1));
    }

    @Test
    void classify_unclassified() {
        assertEquals("unclassified", showcase.classify(0, 0, 0, 0));
    }

    @Test
    void hashPassword_returnsDigest() {
        assertEquals(32, showcase.hashPassword("x").length());
    }

    @Test
    void getPassword_isExposed() {
        assertNotNull(showcase.getPassword());
    }
}
