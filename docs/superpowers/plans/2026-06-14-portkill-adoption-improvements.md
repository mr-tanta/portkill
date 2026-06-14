# PortKill Adoption Improvements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Build the adoption-focused improvements requested by the maintainer: project-aware diagnostics, safer first-use behavior, shell completions, search-friendly docs, and refreshed preview material.

**Architecture:** Keep PortKill as a single Bash CLI and add small focused helpers inside `bin/portkill` that match the current function-based layout. Preserve automation compatibility by requiring confirmation only for interactive TTY default kills; explicit `kill`, `--yes`, `--force`, `--dry-run`, and non-TTY usage remain script-friendly.

**Tech Stack:** Bash 3.2+, existing shell test suite, Remotion preview project, GitHub Actions workflows, Markdown docs.

---

### Task 1: Add TDD Coverage For New CLI Surface

**Files:**
- Modify: `tests/test_portkill.sh`

- [x] **Step 1: Add failing tests**

Add tests for:
- `--yes` is accepted after `kill`
- default TTY kills prompt before killing
- `doctor` reports project/framework hints
- `--doctor` aliases `doctor`
- `completion bash|zsh|fish` emits shell completion code
- README help mentions `doctor`, `completion`, and `--yes`

- [x] **Step 2: Run tests and verify RED**

Run: `./tests/test_portkill.sh`

Expected: new tests fail because commands/options do not exist yet.

### Task 2: Add Safe Confirmation Defaults

**Files:**
- Modify: `bin/portkill`

- [x] **Step 1: Implement confirmation helpers**

Add global `YES_MODE=false`, parse `--yes|-y|--no-confirm`, and add `should_confirm_default_kill`.

- [x] **Step 2: Wire default kill behavior**

Make implicit `portkill 3000` confirm only when stdout/stdin are TTYs and `--yes`, `--dry-run`, and config `auto_confirm=true` are not active. Keep explicit `portkill kill 3000` non-interactive unless `--interactive` is passed.

- [x] **Step 3: Verify GREEN**

Run: `./tests/test_portkill.sh`.

### Task 3: Add Project-Aware Doctor

**Files:**
- Modify: `bin/portkill`
- Modify: `tests/test_portkill.sh`

- [x] **Step 1: Implement doctor helpers**

Add `detect_project_hint`, `detect_framework_hint`, `show_doctor`, and `show_port_doctor`. Use process cwd when available via `pwdx` on Linux or `lsof -a -p PID -d cwd -Fn` fallback, then inspect nearby files such as `package.json`, `vite.config.*`, `next.config.*`, `docker-compose.yml`, `Gemfile`, `Cargo.toml`, and `go.mod`.

- [x] **Step 2: Wire parser**

Add `doctor` command and `--doctor` alias. `portkill doctor` checks dependencies and detector availability; `portkill doctor 3000` diagnoses owners of a port and suggests `--dry-run`, `--docker`, or `--yes`.

- [x] **Step 3: Verify GREEN**

Run: `./tests/test_portkill.sh`.

### Task 4: Add Shell Completions

**Files:**
- Modify: `bin/portkill`
- Modify: `packaging/aur/PKGBUILD`
- Modify: `packaging/rpm/portkill.spec`
- Modify: `scripts/build-packages.sh`
- Modify: `.github/workflows/package-build.yml`

- [x] **Step 1: Implement `completion` command**

Add `show_completion bash|zsh|fish` with static command and option completions.

- [x] **Step 2: Install completions in packages**

Package generated completion files into Homebrew/AUR/Deb/RPM paths where relevant.

- [x] **Step 3: Verify GREEN**

Run: `bash -n bin/portkill scripts/build-packages.sh packaging/aur/PKGBUILD` and `./tests/test_portkill.sh`.

### Task 5: Improve Docs And Preview

**Files:**
- Modify: `README.md`
- Modify: `wiki/Installation.md`
- Modify: `preview/src/Composition.tsx`
- Modify: `packages/deb-pkg/usr/share/doc/portkill/README.md`
- Modify: `.github/workflows/release.yml`

- [x] **Step 1: Update README positioning**

Add AUR badge, zero-runtime positioning, copy-paste rescue sections for `EADDRINUSE`, Vite/Next.js, and Docker conflicts, plus competitor comparison snippets.

- [x] **Step 2: Refresh preview**

Update the Remotion animation to show `doctor`, default confirmation, and shell completion alongside Docker/JSON.

- [x] **Step 3: Render GIF**

Run: `cd preview && npm run render:gif`.

- [x] **Step 4: Sync package docs**

Run: `./create-packages.sh`.

### Task 6: Final Verification And PR

**Files:**
- All changed files

- [x] **Step 1: Run full checks**

Run:
- `make test`
- `bash -n bin/portkill install.sh uninstall.sh create-packages.sh scripts/build-packages.sh packaging/aur/PKGBUILD`
- `ruby -e 'require "yaml"; Dir[".github/workflows/*.yml", ".github/dependabot.yml"].each { |path| YAML.load_file(path); puts "ok #{path}" }'`
- `cd preview && npm run lint && npm audit --audit-level=low`
- `git diff --check`

- [x] **Step 2: Commit, push, and open PR**

Commit to a feature branch, push, open a PR against `main`, wait for required checks, then merge through protected branch rules.
