# Sarasa Term TC Nerd Agent Guide

## Release Workflow

- The Release workflow is `.github/workflows/release.yml`.
- Release builds are triggered by pushing tags that match `v*`; non-version tags such as `release` do not trigger the workflow.
- Prefer the project ops script for releases:
  - `scripts/ops/release-and-monitor --tag vYYYY.MM.DD.N`
  - The script should push `main`, push the tag, wait for the Release workflow, and report release asset sizes.
- After every release, verify all `SarasaTermTCNerd*.tar.gz` and `SarasaTermTCNerd*.7z` assets are at least `10 MiB`.
- Release artifacts include compressed archives plus common hinted raw TTF files: `SarasaTermTCNerd-Regular.ttf` and `SarasaTermTCNerd-Bold.ttf`.
- Font `nameID 5` version strings should include the release tag and use the normalized format: `Version <release>; Sarasa <source>; ttfautohint <version>; Nerd Fonts <version>`.
- Release CI should use a pinned GHCR image tag instead of an unpinned moving tag. When intentionally updating the CI image, update the pinned image tag in `.github/workflows/release.yml` in the same change.

## CI Image And Source Font Cache

- The release CI image is built from `.github/docker/release-ci.Dockerfile` and published by `.github/workflows/build-ci-image.yml`.
- Keep build dependencies in the CI image when they are stable system tools, not in repeated Release workflow setup steps.
- Cache upstream Sarasa source fonts by selected release asset metadata, not by date or branch.
- Cache both the downloaded `.7z` archive and extracted `SarasaTermTC-*.ttf` files when the upstream asset has not changed.

## Project Ops Scripts

- Put repeatable release/build mechanics under `scripts/ops/`.
- Prefer a single project script over many separate `git` and `gh` calls when the task is mechanical and has a known order.
- Keep scripts usable from both local shells and GitHub Actions; pass behavior through explicit flags before relying on CI-only environment variables.
- Verify scripts with `bash -n` and a focused dry run before relying on them in CI.

## Retrospective And Self-Maintenance

- After each task, include a concise retrospective: what worked, what failed or was non-intuitive, and what should be improved before the next run.
- If a task required multiple searches for external information, repeated a known manual sequence, or produced multiple avoidable errors, improve the repo before closing the task.
- Improvements may be a rule in this file, a project script, a runbook, or a reusable user skill. Choose scripts for mechanical steps and rules for judgment-based decisions.
- Maintain this file from time to time: when project operations change, update `AGENTS.md` and any affected scripts in the same task so agent behavior stays current.
