# What each sample raises

Every sample carries a `showcase` file of deliberate issues, so the first analysis lands on a populated dashboard instead of an empty one.

Everything below was measured against **SonarQube Community** with the default "Sonar way" quality profile, by running `task ci`.
`task assert` re-checks these numbers and rule keys on every CI run.
See [Keeping this page honest](#keeping-this-page-honest).

## Summary

Sample | Lines | Coverage | Issues | Hotspots
-------|-------|----------|--------|---------
nodejs | 82    | 31.1%    | 7      | 1
python | 56    | 60.7%    | 6      | 2
go     | 104   | 29.1%    | 4      | 0
java   | 146   | 38.0%    | 7      | 1
dotnet | 112   | 33.6%    | 15     | 1

Coverage is deliberately partial: the tests exercise some branches of the showcase code and not others, so the dashboard shows a realistic mix rather than 0% or 100%.

## nodejs

Rule               | Type          | What triggers it
-------------------|---------------|----------------------------------------------------------------------------
`javascript:S1481` | Code Smell    | `unusedTotal` declared and never read
`javascript:S2068` | Vulnerability | hard-coded password constant
`javascript:S3516` | Code Smell    | `describeRole` always returns the same value
`javascript:S3776` | Code Smell    | `classify` cognitive complexity 32, threshold 15
`javascript:S1135` | Code Smell    | the `TODO` comment
`javascript:S7772` | Code Smell    | x2, `require('crypto')` and `require('http')` should use the `node:` prefix
`javascript:S4790` | Hotspot       | MD5 hashing

> [!NOTE]
> `S7772` is not deliberate, it fires on `src/app.js` too, which is ordinary sample code.
> It is left in because it is a fair demonstration that analysis finds unplanned things.

## python

Rule           | Type          | What triggers it
---------------|---------------|---------------------------------------------------
`python:S5717` | Code Smell    | `append_to(element, target=[])` mutable default
`python:S2068` | Vulnerability | hard-coded password constant
`python:S3516` | Code Smell    | `describe_role` always returns the same value
`python:S3776` | Code Smell    | `classify` cognitive complexity 32, threshold 15
`python:S1066` | Code Smell    | a nested `if` that could be merged
`python:S1135` | Code Smell    | the `TODO` comment
`python:S4502` | Hotspot       | Flask CSRF protection not enabled, in `src/app.py`
`python:S4790` | Hotspot       | MD5 hashing

## go

Rule       | Type       | What triggers it
-----------|------------|---------------------------------------------------------------------------------
`go:S3776` | Code Smell | `Classify` cognitive complexity 32, threshold 15
`go:S1135` | Code Smell | the `TODO` comment
`go:S1192` | Code Smell | x2, duplicated `"Content-Type"` and `"application/json"` in `cmd/server/main.go`

Go is the instructive case, and the reason this page exists:

- **Go has no `S2068` and no `S4790`.**
  The `Password` constant and the MD5 hashing in `showcase.go` are byte-for-byte equivalent to code that raises a Vulnerability and a Security Hotspot in Java, Python, and C#.
  In Go they raise **nothing**.
- **`go:S1192` exists but does not fire on `DescribeRole`.**
  It fires on the HTTP header strings in `main.go` instead.
  A rule existing for a language does not mean it fires on the expected construct.

A clean dashboard does not always mean clean code.
It can mean the rule does not exist for that language.

## java

Rule         | Type          | What triggers it
-------------|---------------|-------------------------------------------------
`java:S1192` | Code Smell    | `"administrator"` duplicated 3 times
`java:S2068` | Vulnerability | hard-coded `PASSWORD` field
`java:S3776` | Code Smell    | `classify` cognitive complexity 32, threshold 15
`java:S1066` | Code Smell    | x3, nested `if`s that could be merged
`java:S1135` | Code Smell    | the `TODO` comment
`java:S4790` | Hotspot       | MD5 via `MessageDigest.getInstance("MD5")`

> [!NOTE]
> The empty `catch` block in `Showcase.java` raises **neither** `S2486` nor `S108`: both rules suppress when the block contains a comment.
> It is kept as-is to make the point that reading the rule description beats assuming.

## dotnet

Rule                      | Type          | What triggers it
--------------------------|---------------|-------------------------------------------------
`csharpsquid:S1192`       | Code Smell    | `"administrator"` duplicated 4 times
`csharpsquid:S2068`       | Vulnerability | hard-coded `Password` constant
`csharpsquid:S3776`       | Code Smell    | `Classify` cognitive complexity 32, threshold 15
`csharpsquid:S1066`       | Code Smell    | x3, nested `if`s that could be merged
`csharpsquid:S2325`       | Code Smell    | x4, methods that do not use instance state
`csharpsquid:S1135`       | Code Smell    | the `TODO` comment
`csharpsquid:S4790`       | Hotspot       | MD5 hashing
`csharpsquid:S1118`       | Code Smell    | `Program` needs a protected constructor
`csharpsquid:S6966`       | Code Smell    | `Run` should be `RunAsync`
`external_roslyn:CA1850`  | Code Smell    | prefer static `MD5.HashData`
`external_roslyn:ASP0027` | Code Smell    | ASP.NET Core `Program` class guidance

The .NET sample raises the most because the MSBuild scanner analyses **compiled code**, so Roslyn's own analysers (`external_roslyn:*`) are imported alongside Sonar's.
That is a genuine advantage of the language-specific scanner over the generic CLI, and it is visible here as a higher issue count on comparable code.

## Rules deliberately not used

Rules that need the analyser to *prove* a condition (division by zero, null dereference, unreachable code) stay silent on simple sample code.
Earlier versions of these samples advertised `S3518` (division by zero) and similar, and they never fired.
A sample that claims an issue it does not produce is worse than no sample.

## Keeping this page honest

`task assert` verifies, for every sample, that:

1. Lines of code were analysed at all (catches a broken `sonar.sources`)
2. A coverage measure exists and is above a floor (catches a broken report path, since the scanner exits 0 either way)
3. The issue count is above a floor
4. **Every rule key listed above still fires**

Check 4 is what stops this page drifting.
If SonarQube retires a rule, CI fails with the exact key, instead of the dashboard just getting quietly emptier.
