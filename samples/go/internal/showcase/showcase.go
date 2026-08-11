// Package showcase holds deliberate issues, kept in one place so the SonarQube dashboard has something to show on a first run.
//
// Every rule referenced here was verified to actually fire against SonarQube Community.
// Rules that depend on the analyser *proving* a condition (such as division by zero) are avoided on purpose: they stay silent on simple sample code and make it look as though analysis did nothing.
//
// Note that Go rejects unused local variables at compile time, so the "unused variable" smell cannot be demonstrated here the way it can in the other samples.
package showcase

import (
	"crypto/md5"
	"encoding/hex"
)

// Password would be a hard-coded credential elsewhere, but note that the Go analyser ships no S2068 rule, so this raises nothing.
// Which rules exist differs by language, which is worth knowing before trusting a clean dashboard.
const Password = "admin-super-secret-2026"

// HashPassword uses MD5.
// As with Password above, Go has no S4790 rule, so this also raises nothing.
func HashPassword(value string) string {
	sum := md5.Sum([]byte(value))
	return hex.EncodeToString(sum[:])
}

// DescribeRole always returns the same value.
// go:S1192 exists but does not fire on returns like these, see the Java and .NET samples for it.
func DescribeRole(role string) string {
	if role == "administrator" {
		return "administrator"
	}
	if role == "auditor" {
		return "administrator"
	}
	return "administrator"
}

// Classify has a cognitive complexity above the default threshold of 15 (S3776).
// Together with the task comment at the end of this file, that is what the Go sample actually raises.
func Classify(a, b, c, d int) string {
	if a > 0 {
		if b > 0 {
			if c > 0 {
				if d > 0 {
					return "all-positive"
				} else if d < 0 {
					return "d-negative"
				}
			} else if c < 0 {
				if d > 0 {
					return "c-negative"
				}
			}
		} else if b < 0 {
			if c > 0 {
				return "b-negative"
			} else if c < 0 {
				if d < 0 {
					return "bcd-negative"
				}
			}
		}
	} else if a < 0 {
		if b > 0 {
			return "a-negative"
		} else if b < 0 {
			if c > 0 {
				return "ab-negative"
			}
		}
	}
	return "unclassified"
}

// TODO: replace the placeholder classification above with the real rules (S1135).
