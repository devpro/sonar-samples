# Purpose

This repository is the simplest way to get started with Sonar: pick a language, run three commands, look at the result.

## What a sample is

- **Small, and close to what the standard tool of the language generates.**
  The code is committed.
  Angular is the exception: its code changes with each release of the CLI, so it is generated on the spot and ignored by git.
- **Ready for real code.**
  It has some tests, and shows how coverage and test results reach Sonar.
  There is no coverage target.
- **Allowed to have findings.**
  They are expected, and give the dashboard something to show.

A sample shows configuration that works, taken from real projects and from [github-workflow-parts](https://github.com/devpro/github-workflow-parts).

## Where it runs

- **On the machine**, with SonarQube in Docker and no account to create: this is what the instructions describe.
- **On SonarQube Cloud**, nothing to set up either: the [devpro-github](https://sonarcloud.io/organizations/devpro-github/projects) organization has analyses to look at.
- **With IstarCI**, a private project, for those who have it.
  It is optional, and a local run should report the same as it does, with the "Sonar way comprehensive" profile.
  When the results differ, IstarCI is the reference, unless there is a very good reason.
