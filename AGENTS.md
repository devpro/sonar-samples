# CLAUDE.md

Guidance for working in this repository.

## Writing style

These rules apply to Markdown, code comments, commit messages, and any prose in scripts.

**One sentence per line.**
A line break only ever happens at the end of a sentence.
Never wrap a sentence across two lines.
There is no maximum line length: screens are wide, and the 80 character convention is not used here.
Wrapping is handled by the editor, not by hard newlines.

**Never use the em dash (`—`) or the en dash (`–`).**
Use a colon when introducing an explanation, a comma when joining clauses, or a full stop and a new sentence.
This applies to prose, code comments, table cells, and error message strings.

**Never use the second person.**
No "you", no "your", not even in placeholders such as `<your-token>`, which should read `<token>`.
The documentation describes the repository, it does not address a reader.
Write "the working tree", not "your working tree".
Write "a contribution is planned", not "are you willing to contribute".

**Other conventions.**
Use `ini` as the fence language for `.properties` blocks, never `properties`.
Prefer `>` over `→` when describing UI navigation, for example **Project Settings > Quality Gate**.

## Repository conventions

Shell scripts are named in `snake_case`, which is the standard for bash.
`sonar_bootstrap.sh`, not `sonar-bootstrap.sh`.

Scripts must be committed with the executable bit set.
A script committed as `100644` fails on a fresh clone even though it works locally:

```bash
git update-index --chmod=+x path/to/script.sh
```

The root `README.md` stays as short as possible.
Shared content lives in `docs/` and is linked, never copied.
Contributor-facing material lives in `CONTRIBUTING.md` at the repository root.
Each sample README is self-sufficient for that sample and links out for anything generic.

Target platform is Linux with Docker, including WSL2, and `bash`.

## Learnings specific to this repository

**Never claim a rule fires without observing it fire.**
This is the single most important rule here, and the repository exists to demonstrate it.
Verify against a running SonarQube and read the actual issue list:

```bash
export SONAR_TOKEN=$(task bootstrap)
curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/issues/search?componentKeys=<key>&ps=500&resolved=false"
curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/hotspots/search?projectKey=<key>&ps=500"
```

Security Hotspots are **not** returned by `/api/issues/search`.
They have their own endpoint, and forgetting this makes a rule look retired when it is not.

Wait for the compute engine queue to drain before reading results, otherwise the API returns a mix of the previous and current analysis:

```bash
curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/ce/activity_status"
```

**Things that were assumed and turned out to be false:**

- `S2068` (hard-coded credentials) is a **Vulnerability**, not a Security Hotspot.
- `java:S2486` and `java:S108` do **not** fire on an empty catch block that contains a comment.
  Both rules suppress on comments.
- `go:S1192` exists but does not fire on repeated return values.
  It fired on HTTP header literals in a completely different file.
- Go ships neither `S2068` nor `S4790`, so identical code raises nothing there.
- An explanatory comment containing the word `TODO` raises `S1135` by itself.
  This silently inflated issue counts until it was noticed.
  Keep the rule key on the same line as the real trigger and out of standalone prose.

**A scanner exits `0` even when it fails to import a coverage report.**
That is why `scripts/assert_analysis.sh` exists and why it checks measures and rule keys through the API rather than trusting the exit code.

**The `sonarsource/sonar-scanner-cli` image runs as root.**
Without `--user "$(id -u):$(id -g)"` it leaves a root-owned `.scannerwork/` in the mounted directory, which then breaks the next build with `permission denied` and needs `sudo` to clear.

## Verifying changes

```bash
task ci   # build, scan and assert everything
```

Individual samples: `task build:<sample>` then `task scan:<sample>`, then `task assert`.

Note that `task build:java` needs Maven on the PATH.
When Maven is unavailable, the Java sample can be built and scanned through a container:

```bash
docker run --rm --network host --user "$(id -u):$(id -g)" \
  -v "$(pwd)/samples/java":/app -w /app \
  -v "$HOME/.m2":/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 \
  -v "/tmp/sonarhome":/sonarhome \
  maven:3.9-eclipse-temurin-21 \
  mvn -B -Duser.home=/var/maven verify sonar:sonar \
    -Dsonar.token="$SONAR_TOKEN" -Dsonar.userHome=/sonarhome
```

After changing anything that affects analysis, re-measure and update `docs/rules.md` and the floors in `task assert` together.
Those two must never drift apart.
