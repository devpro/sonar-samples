package math_test

import (
	"testing"

	"github.com/devpro/sonar-samples-go/internal/math"
)

func TestAdd(t *testing.T) {
	tests := []struct {
		a, b, want int
	}{
		{2, 3, 5},
		{-1, 1, 0},
		{0, 0, 0},
	}
	for _, tt := range tests {
		got := math.Add(tt.a, tt.b)
		if got != tt.want {
			t.Errorf("Add(%d, %d) = %d; want %d", tt.a, tt.b, got, tt.want)
		}
	}
}

func TestSubtract(t *testing.T) {
	if got := math.Subtract(10, 4); got != 6 {
		t.Errorf("Subtract(10, 4) = %d; want 6", got)
	}
}

func TestGreet(t *testing.T) {
	tests := []struct {
		name, want string
	}{
		{"Bertrand", "Hello, Bertrand!"},
		{"", "Hello, world!"},
	}
	for _, tt := range tests {
		got := math.Greet(tt.name)
		if got != tt.want {
			t.Errorf("Greet(%q) = %q; want %q", tt.name, got, tt.want)
		}
	}
}
