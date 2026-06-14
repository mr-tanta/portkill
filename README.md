# PortKill

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/github/v/release/mr-tanta/portkill)](https://github.com/mr-tanta/portkill/releases)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-blue)](https://github.com/mr-tanta/portkill)
[![Homebrew](https://img.shields.io/badge/Homebrew-available-orange)](https://github.com/mr-tanta/homebrew-portkill)
[![AUR](https://img.shields.io/aur/version/portkill?label=AUR)](https://aur.archlinux.org/packages/portkill)

PortKill is a Bash CLI for finding and terminating processes that bind local ports. It is built for developer workstations, servers, and container-heavy local environments where port conflicts need to be resolved quickly and safely.

No npm, Python, Rust, Go, daemon, or background service required. PortKill is a single Unix shell tool with package manager support.

<p align="center">
  <img src="assets/portkill-preview.gif" alt="Animated PortKill preview showing list, dry-run, Docker, and JSON workflows" width="860">
</p>

## Features

- Exact process detection for listening TCP ports and bound UDP ports
- Safe termination with SIGTERM first and SIGKILL escalation when needed
- Protected-process whitelist for system-critical processes
- Docker container detection and stop/kill support with `--docker`
- JSON output for automation
- Project-aware `doctor` command for dependency checks, framework hints, and safe next steps
- Preset port groups for Node.js, web, database/cache, and full dev-stack checks
- Read-only `cache doctor` diagnostics for common development cache directories
- Bash, Zsh, and Fish completion generation
- Process tree view, real-time monitoring, history, and CSV/JSON exports
- Basic connection benchmarking for local and remote hosts
- macOS and Linux support with standard Unix tools

## Installation

### Homebrew

```bash
brew install mr-tanta/portkill/portkill
```

Homebrew 6.0+ requires third-party tap trust before short-name installs. If you have already tapped the repository and want to install or upgrade with `portkill`, trust only the PortKill formula first:

```bash
brew tap mr-tanta/portkill
brew trust --formula mr-tanta/portkill/portkill
brew install portkill
```

### AUR

```bash
yay -S portkill
# or
paru -S portkill
```

### Install Script

```bash
# Latest release
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash

# Specific release
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash -s v3.2.0

# Custom prefix, installs to /opt/portkill/bin/portkill
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash -s -- --prefix=/opt/portkill
```

### Manual Release Asset

```bash
curl -L https://github.com/mr-tanta/portkill/releases/latest/download/portkill -o portkill
chmod +x portkill
sudo mv portkill /usr/local/bin/
```

Debian and RPM packages are produced by the package workflow for releases. Use the assets on the GitHub release page when they are present.

## Requirements

Required:

- Bash 3.2+
- `ps`
- `kill`
- At least one port detector: `lsof`, `ss`, `netstat`, or `fuser`

Optional:

- `bc` for benchmark calculations
- `nc` or `telnet` for benchmarking
- Docker CLI for `--docker`

## Usage

```bash
# Kill processes on port 3000
portkill 3000

# Kill multiple ports or a range
portkill 3000 8080 9000
portkill 3000-3005

# Preview without killing
portkill --dry-run 3000
portkill kill --dry-run 3000

# Force kill with SIGKILL
portkill --force 3000

# Ask before each kill
portkill --interactive 8080

# Skip confirmation for scripts and CI
portkill kill --yes 3000
```

When run in a terminal, default kills such as `portkill 3000` ask before terminating. Use `--yes` or `--no-confirm` for trusted automation.

### Inspect Ports

```bash
# List processes on a port
portkill list 3000

# Detailed process info
portkill list --detailed 3000

# List all listening ports
portkill list

# Show process hierarchy
portkill tree --depth 5 3000
```

### Presets

Presets expand to common development port groups. With no explicit command, a preset defaults to inspection instead of killing.

```bash
# Show available presets
portkill --list-presets

# Inspect common Node.js/Vite/Next.js ports
portkill --preset node

# Inspect common web ports
portkill --preset web list

# Preview cleanup for database/cache ports
portkill --preset db kill --dry-run

# Inspect a broader local development stack
portkill --preset full
```

Available presets:

- `node`: Node.js, Vite, Next.js, React, and local API dev ports
- `web`: common web, app server, and reverse-proxy ports
- `db`: MySQL, PostgreSQL, Redis, Elasticsearch, Memcached, and MongoDB ports
- `full`: common web, Node.js, database, cache, and search ports

### Docker

```bash
# Include containers in listing
portkill --docker list 8080

# Stop containers and kill local processes bound to the port
portkill --docker 8080

# Preview Docker operations
portkill --docker --dry-run 8080
```

### JSON

```bash
portkill --json list 3000
portkill --docker --json list 8080
```

Process records use `"type": "process"`. Docker records use `"type": "container"` and include `container_id`, `name`, and `ports`.

### Monitoring, History, and Benchmarking

```bash
portkill monitor 3000 8080
portkill scan --security
portkill history
portkill history --analytics
portkill history --export json
portkill benchmark 3000 localhost 20
portkill benchmark 443 github.com
portkill menu
```

### Diagnose Port Conflicts

```bash
# Check PortKill setup and detector availability
portkill doctor

# Explain what owns a busy port and suggest safe next steps
portkill doctor 3000

# Same as doctor
portkill --doctor
```

`doctor` is the recommended first command when a framework reports a port conflict. It reports the owning PID, user, command, detected working directory when available, likely project type such as Vite, Next.js, Docker, Ruby, Rust, Go, or Python, and the safest follow-up command.

For busy ports, `doctor` also prints restart guidance:

- likely start command, inferred from the live command line or project files
- project directory to return to after cleanup
- exact next PortKill commands for dry-run and trusted automation

PortKill does not auto-run restart commands. Restart guidance is intentionally manual until restart automation can be added with strong confirmation and security controls.

### Cache Diagnostics

```bash
portkill cache doctor
```

`cache doctor` is read-only. It reports common project caches such as `node_modules`, `.next`, `.vite`, `.turbo`, `target`, `__pycache__`, and `.gradle`, plus common user-level dev caches such as npm, pip, Cargo, Hugging Face, and PyTorch caches when present. It does not delete files.

### Shell Completions

```bash
portkill completion bash
portkill completion zsh
portkill completion fish
```

Debian/RPM and AUR packages install completions automatically. Homebrew users can generate completions with the commands above until the next formula update installs them directly.

## Fix Common Errors

### `EADDRINUSE: address already in use :::3000`

```bash
portkill doctor 3000
portkill --dry-run 3000
portkill --yes 3000
```

### Vite, Next.js, Rails, or API Server Says Port Is Already In Use

```bash
portkill doctor 5173
portkill doctor 3000
portkill list --detailed 3000
```

### Docker Container Holds The Port

```bash
portkill --docker list 8080
portkill --docker --dry-run 8080
portkill --docker kill --yes 8080
```

## PortKill vs Alternatives

| Tool | Best For | Tradeoff |
| --- | --- | --- |
| `portkill` | Unix-native port diagnosis and cleanup with `doctor`, Docker awareness, presets, package-manager installs, and no runtime dependency | macOS/Linux focused |
| `port-kill` | Broad Rust-based workstation management with GUI/status bar, Windows support, orchestration, cache cleanup, and service lifecycle features | Larger trust and maintenance surface |
| `kill-port` | Quick Node/npm-based port cleanup | Requires Node/npm and gives less project context |
| `fkill` | General process killing by name, PID, or port-like input | Broader process killer, less focused on port ownership and Docker workflows |

PortKill focuses on exact port ownership, safe termination, Docker awareness, package-manager installs, and zero runtime dependency overhead.

Windows support should be a separate PowerShell-native track if it is added later. The Bash CLI stays focused on macOS and Linux instead of carrying Windows-specific branching.

## Configuration

PortKill reads system defaults from `/etc/portkill/portkill.conf` when present, then user settings from `~/.portkill/config.conf`. User settings override system settings.

Supported config keys:

```bash
safe_mode=true
auto_confirm=false
verbose_mode=false
monitoring_interval=2
max_history_entries=1000
color_output=true
show_process_tree=true
```

Protected processes are listed in `~/.portkill/whitelist.conf`, one process name per line.

Logs and history are stored under `~/.portkill/`.

## Uninstall

```bash
# Install-script uninstall
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/uninstall.sh | bash

# Remove user config as well
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/uninstall.sh | bash -s -- --remove-config

# Homebrew
brew uninstall portkill
brew untap mr-tanta/portkill

# AUR
sudo pacman -R portkill
```

## Development

```bash
make test
./tests/test_portkill.sh
bash -n bin/portkill install.sh uninstall.sh
```

ShellCheck is used in CI when available.

## Package Channels

- Main repository: https://github.com/mr-tanta/portkill
- Homebrew tap: https://github.com/mr-tanta/homebrew-portkill
- AUR package: https://aur.archlinux.org/packages/portkill

## License

MIT License. See [LICENSE](LICENSE).
