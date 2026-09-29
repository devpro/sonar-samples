// Package math provides simple arithmetic and string utilities.
package math

import "fmt"

// Add returns the sum of a and b.
func Add(a, b int) int {
	return a + b
}

// Subtract returns a minus b.
func Subtract(a, b int) int {
	return a - b
}

// Greet returns a greeting string.
// Falls back to "world" if name is empty.
func Greet(name string) string {
	if name == "" {
		name = "world"
	}
	return fmt.Sprintf("Hello, %s!", name)
}

// Divide returns a / b.
func Divide(a, b float64) float64 {
	return a / b
}
