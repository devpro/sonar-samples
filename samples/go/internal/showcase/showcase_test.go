package showcase_test

import (
	"testing"

	"github.com/devpro/sonar-samples-go/internal/showcase"
)

func TestDescribeRole(t *testing.T) {
	if got := showcase.DescribeRole("administrator"); got != "administrator" {
		t.Errorf("DescribeRole = %q; want %q", got, "administrator")
	}
}

func TestClassify(t *testing.T) {
	if got := showcase.Classify(1, 1, 1, 1); got != "all-positive" {
		t.Errorf("Classify(1,1,1,1) = %q; want %q", got, "all-positive")
	}
	if got := showcase.Classify(0, 0, 0, 0); got != "unclassified" {
		t.Errorf("Classify(0,0,0,0) = %q; want %q", got, "unclassified")
	}
}

func TestHashPassword(t *testing.T) {
	if got := showcase.HashPassword("x"); len(got) != 32 {
		t.Errorf("HashPassword length = %d; want 32", len(got))
	}
}
