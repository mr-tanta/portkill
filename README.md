# PortKill - Advanced Port Management & Network Analysis Tool

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/github/v/release/mr-tanta/portkill)](https://github.com/mr-tanta/portkill/releases)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-blue)](https://github.com/mr-tanta/portkill)
[![Homebrew](https://img.shields.io/badge/Homebrew-available-orange)](https://github.com/mr-tanta/homebrew-portkill)
[![Shell](https://img.shields.io/badge/shell-bash-green)](https://www.gnu.org/software/bash/)

**PortKill** is a lightweight, reliable, and zero-dependency port management utility designed for developers, system administrators, and DevOps professionals. Following the Unix philosophy of "do one thing and do it well," PortKill focuses on efficiently killing processes on ports without bloat or complex dependencies.

## Key Features

- **Zero Dependencies**: Pure Bash script - no Python, Node.js, or other runtime requirements
- **Lightweight**: Only 72KB - 200x smaller than alternatives
- **Docker Integration**: Native container detection and management with unified interface
- **Simple JSON Output**: Clean, readable output for automation and scripts
- **Performance Benchmarking**: Test connection speed and latency to remote ports
- **Smart Process Detection**: Multi-method process identification with fallbacks
- **Interactive Terminal Menu**: Clean, intuitive interface for port management
- **Process Tree Visualization**: Hierarchical display of process relationships
- **Safe Process Management**: Built-in protection for system-critical processes
- **Bulk Operations**: Efficiently manage multiple ports and port ranges
- **Real-time Monitoring**: Live port activity surveillance
- **Port Usage Analytics**: Track and analyze port usage history
- **Security Scanning**: Identify potentially vulnerable services
- **Cross-platform Support**: Works on any system with Bash and standard Unix tools
- **Easy Installation**: Single script - no package managers required

## Quick Start

### Install via Homebrew (Recommended)
```bash
brew tap mr-tanta/portkill
brew install portkill
```

### Basic Usage
```bash
# Kill processes on port 3000
portkill 3000

# Kill processes on multiple ports
portkill 3000 8080 9000

# Kill processes on port range
portkill 3000-3005
```

### Advanced Features
```bash
# List processes on a port
portkill list 3000

# Include Docker containers
portkill --docker list 8080

# JSON output for automation
portkill --json list 3000

# Test port performance
portkill benchmark 3000
portkill benchmark 80 google.com

# Interactive menu mode
portkill menu
```

## Overview

PortKill eliminates the frustration of port conflicts during development and system administration. Instead of remembering complex command sequences like `lsof -ti:3000 | xargs kill -9`, simply run `portkill 3000`. 

**Zero Dependencies. Maximum Reliability.**

In a world of bloated tools requiring Node.js, Python, or complex installations, PortKill stands apart as a pure Bash solution that works everywhere Unix tools exist. At just 72KB, it's 200x smaller than Rust alternatives while being more reliable than any tool with external dependencies.

Whether you're a developer dealing with stuck development servers, a sysadmin managing production systems, or a DevOps engineer working in containerized environments, PortKill provides the reliability and simplicity you need without the bloat you don't.

## Features

### Core Port Management
- **Smart Process Detection**: Multi-layered detection using `lsof`, `ss`, `netstat`, `fuser`, and `ps` with intelligent fallbacks
- **Process Tree Analysis**: Visualize parent-child process relationships with customizable depth
- **Bulk Port Operations**: Handle multiple ports, port ranges (e.g., `3000-3005`), and complex scenarios
- **Safe Termination**: SIGTERM by default, SIGKILL option available with `--force`
- **Protected Processes**: Automatic safeguards for system-critical processes (launchd, kernel_task, sshd, etc.)

### Advanced Analytics & Monitoring
- **Port Usage History**: Track and analyze port activity over time with timestamps
- **Real-time Monitoring**: Live port status updates with configurable refresh intervals
- **Usage Statistics**: Comprehensive analytics including most used ports, peak times, and trends
- **Export Capabilities**: Export data in CSV, JSON, and raw formats for further analysis

### Performance Benchmarking (NEW v2.3.0)
- **Connection Speed Testing**: Measure response times with millisecond precision
- **Reliability Analysis**: Success rate tracking and failure diagnostics
- **Concurrent Testing**: Simulate real-world load with configurable concurrent connections
- **Statistical Analysis**: Min/max/avg response times, percentile calculations (50th, 95th, 99th)
- **Remote Testing**: Test external services and APIs (e.g., `google.com:80`)
- **Performance Assessment**: Automated performance ratings and recommendations

### User Experience
- **Interactive Terminal UI**: Beautiful, intuitive menu system with color-coded output
- **Detailed Process Information**: Command lines, users, PIDs, and resource usage
- **Progress Indicators**: Real-time progress bars for long operations
- **Verbose Logging**: Comprehensive operation logging with multiple verbosity levels
- **Dry-run Mode**: Preview operations without executing them
- **Interactive Confirmations**: Optional step-by-step confirmations for safety

### Docker Integration (NEW v2.3.2)
- **Container Detection**: Automatically discover Docker containers bound to specific ports
- **Container Management**: Stop or force-kill containers using native Docker commands
- **Unified Interface**: Seamlessly manage both processes and containers with single commands
- **Interactive Confirmations**: Optional step-by-step confirmations for container operations
- **Docker Status Awareness**: Graceful handling when Docker is unavailable
- **History Tracking**: Log container operations alongside process activities

### Web Dashboard (NEW v2.3.2) 🌐
- **WebSocket Real-Time Updates**: Instant updates every 2 seconds with automatic fallback to polling
- **Live Connection Status**: Visual indicators showing WebSocket vs Polling mode
- **Interactive Management**: Check, kill, and benchmark ports through web UI
- **System Statistics**: Live display of active ports, processes, Docker containers, and system load
- **Professional UI**: Dark theme with gradient design, built with HTMX and Tailwind CSS
- **Mobile Responsive**: Works seamlessly on desktop, tablet, and mobile devices
- **Auto-Reconnection**: Seamless reconnection if WebSocket connection drops
- **RESTful API**: JSON endpoints for integration with other tools and scripts

### Remote SSH Support (NEW v2.3.2) 🚀
- **Cross-Server Management**: Execute port operations on remote servers via SSH
- **Enterprise DevOps Ready**: Manage processes across entire infrastructure from single command
- **SSH Key Authentication**: Secure, automated authentication with proper timeout handling
- **Remote Process Discovery**: Full process detection using remote lsof/netstat/fuser commands
- **Interactive Remote Operations**: Confirm actions on remote servers with detailed context
- **JSON Remote Output**: Machine-readable data from remote server operations
- **Error Recovery**: Comprehensive error handling and connectivity diagnostics
- **No Remote Installation**: Works with native Unix commands if PortKill isn't on target server

### JSON API Output (NEW v2.3.2)
- **Machine-Readable Format**: Structured JSON output for automation and integration
- **API Integration Ready**: Perfect for CI/CD pipelines and enterprise tooling
- **Complete Process Data**: Full process details including PID, user, command, cmdline
- **Docker Container Support**: JSON output includes container ID, name, and port mappings
- **Remote Operation Support**: JSON output works seamlessly with remote SSH operations
- **Proper Data Escaping**: Safe handling of special characters and control sequences

### Security & Scanning
- **Port Security Scan**: Identify potentially vulnerable or suspicious services
- **Service Detection**: Automatic service identification (HTTP, HTTPS, SSH, MySQL, etc.)
- **Open Port Discovery**: Comprehensive scanning of all listening ports
- **Process Ownership**: Display which user owns each process for security auditing

## Installation

### Homebrew (Recommended)
The easiest way to install PortKill on macOS:
```bash
# Add the PortKill tap
brew tap mr-tanta/portkill

# Install PortKill
brew install portkill

# Upgrade to latest version
brew upgrade portkill

# Uninstall if needed
brew uninstall portkill
```

### Quick Install Script
One-line installation for both macOS and Linux:
```bash
# Install latest version
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash

# Install specific version
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash -s v3.1.0

# Install to custom location
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash -s - --prefix=/opt/portkill
```

### From Source (Advanced)
For developers and advanced users:
```bash
# Clone the repository
git clone https://github.com/mr-tanta/portkill.git
cd portkill

# Make executable
chmod +x bin/portkill

# Test locally
./bin/portkill --version

# Install system-wide
sudo cp bin/portkill /usr/local/bin/

# Or use make (if available)
make install
```

### Download Release Binary
Direct download from GitHub releases:
```bash
# macOS/Linux
wget https://github.com/mr-tanta/portkill/releases/latest/download/portkill
chmod +x portkill
sudo mv portkill /usr/local/bin/

# Or using curl
curl -L https://github.com/mr-tanta/portkill/releases/latest/download/portkill -o portkill
chmod +x portkill
sudo mv portkill /usr/local/bin/
```

### Package Managers (Community)

#### Arch Linux (AUR)
```bash
# Install from AUR
yay -S portkill
# or
paru -S portkill
```

#### Ubuntu/Debian (.deb package)
```bash
# Download and install .deb package
wget https://github.com/mr-tanta/portkill/releases/latest/download/portkill_3.1.0-1_all.deb
sudo dpkg -i portkill_3.1.0-1_all.deb

# Install dependencies if needed
sudo apt-get install -f
```

#### RPM-based Distributions (RHEL/Fedora/SUSE)
```bash
# Download and install RPM package
wget https://github.com/mr-tanta/portkill/releases/latest/download/portkill-3.1.0-1.noarch.rpm
sudo rpm -i portkill-3.1.0-1.noarch.rpm

# Or using dnf/yum
sudo dnf install portkill-3.1.0-1.noarch.rpm
```

### System Requirements
- **Operating System**: macOS 10.12+ or Linux (kernel 3.10+)
- **Shell**: Bash 3.2+ or compatible shell (zsh, fish)
- **Dependencies**: Standard Unix utilities (`lsof`, `ps`, `kill`)
- **Optional**: `netstat`, `ss`, `fuser` (additional process detection methods), `bc` (for advanced calculations), `nc` or `telnet` (for benchmarking)

## Usage Guide

### Basic Commands

#### Kill Processes (Default Action)
```bash
# Kill process on single port
portkill 3000

# Kill processes on multiple ports
portkill 3000 8080 9000

# Kill processes on port range
portkill 3000-3005

# Force kill (SIGKILL instead of SIGTERM)
portkill --force 3000

# Interactive confirmation for each process
portkill --interactive 8080

# Preview what would be killed (dry-run)
portkill --dry-run 3000

# Include Docker containers in operations
portkill --docker 3000

# Force kill both processes and containers
portkill --docker --force 8080
```

#### Docker Integration
```bash
# List processes and containers on port
portkill --docker list 3000

# Kill both processes and containers
portkill --docker 8080

# Interactive mode with containers
portkill --docker --interactive 5432

# Dry-run with Docker containers
portkill --docker --dry-run 3000

# Monitor ports including containers
portkill --docker monitor 3000 8080
```

#### Remote SSH Support (NEW v2.3.2) 🚀
```bash
# List processes on remote server
portkill --remote user@server list 3000

# Kill processes on production server
portkill --remote deploy@prod.example.com kill 8080

# Force kill with confirmation on remote server
portkill --remote --interactive --force admin@db-server 5432

# Dry-run to preview remote operations
portkill --remote --dry-run ops@staging kill 9000

# JSON output from remote server for automation
portkill --remote --json monitoring@app-server list 3000

# Combined Docker + Remote + JSON operations
portkill --remote --docker --json deploy@k8s-worker list 8080

# Multiple remote servers (use in scripts)
for server in web-01 web-02 web-03; do
  portkill --remote deploy@$server kill 8080
done
```

#### JSON API Output (NEW v2.3.2)
```bash
# JSON output for process listing
portkill --json list 3000

# JSON output with Docker containers
portkill --docker --json list 8080

# JSON output from remote server
portkill --remote --json user@server list 3000

# Pipe JSON output to jq for processing
portkill --json list 3000 | jq '.processes[].pid'

# Use in CI/CD pipelines
PROCESSES=$(portkill --json list 8080)
echo $PROCESSES | jq -r '.processes | length' # Count processes

# Integration with monitoring systems
curl -X POST -H "Content-Type: application/json" \
  -d "$(portkill --remote --json monitor@prod list 3000)" \
  https://monitoring.example.com/api/processes
```

#### List and Inspect Processes
```bash
# List processes on specific port
portkill list 3000

# Detailed process information
portkill list --detailed 3000

# List all listening ports
portkill list

# Scan all ports with security analysis
portkill scan --security
```

#### Process Tree Visualization
```bash
# Show process tree for port
portkill tree 3000

# Custom tree depth
portkill tree --depth 5 8080

# Visualize complex process relationships
portkill tree --depth 10 3000
```

### Performance Benchmarking (NEW v2.3.0)

#### Local Testing
```bash
# Basic port performance test
portkill benchmark 3000

# Custom test parameters
portkill benchmark 3000 localhost 20  # 20 tests

# Test multiple local services
portkill benchmark 8080  # Redis
portkill benchmark 5432  # PostgreSQL
portkill benchmark 27017 # MongoDB
```

#### Remote Testing
```bash
# Test external services
portkill benchmark 80 google.com
portkill benchmark 443 github.com
portkill benchmark 22 your-server.com

# API endpoint testing
portkill benchmark 80 api.example.com
portkill benchmark 443 secure-api.com
```

#### Advanced Benchmarking
```bash
# High-frequency testing
portkill benchmark 3000 localhost 100  # 100 tests

# Load testing simulation
portkill benchmark 8080 localhost 50   # Simulate load

# Network diagnostics
portkill benchmark 443 slow-server.com # Identify bottlenecks
```

### Monitoring and Analytics

#### Real-time Monitoring
```bash
# Monitor single port
portkill monitor 3000

# Monitor multiple ports
portkill monitor 3000 8080 5432

# Monitor with custom refresh rate
portkill monitor --interval 1 3000  # 1-second updates
```

#### History and Analytics
```bash
# View port usage history
portkill history

# Show analytics and statistics
portkill history --analytics

# Export data for analysis
portkill history --csv > port-usage.csv
portkill history --json > port-data.json

# Limit history entries
portkill history 100  # Last 100 entries
```

### Interactive Mode

```bash
# Launch beautiful terminal UI
portkill menu

# Features available in interactive mode:
# - Visual port browser
# - Point-and-click process management
# - Real-time port monitoring
# - Performance benchmarking interface
# - History and analytics viewer
```

## Real-World Use Cases

### Development Scenarios

#### Stuck Development Servers
```bash
# React development server won't restart
portkill 3000
npm start

# Multiple Node.js processes conflict
portkill 3000 8080 8081

# Docker containers holding ports
portkill --docker 5432 6379 27017  # PostgreSQL, Redis, MongoDB containers

# Mixed environment cleanup (processes + containers)
portkill --docker 3000 8080 9000
```

#### Docker-Specific Development
```bash
# Clean up stuck containers on development ports
portkill --docker 3000    # Next.js in container
portkill --docker 8080    # Spring Boot container
portkill --docker 5432    # PostgreSQL container

# Interactive container management
portkill --docker --interactive 8080

# Preview container operations before execution
portkill --docker --dry-run 3000 8080 9000

# Force kill stubborn containers
portkill --docker --force 5432
```

### Enterprise Remote SSH Operations (NEW v2.3.2) 🚀

#### Multi-Server Infrastructure Management
```bash
# Kill stuck processes across web tier
for server in web-01 web-02 web-03; do
  portkill --remote deploy@$server kill 8080
done

# Audit processes across database cluster
for db in db-primary db-replica-01 db-replica-02; do
  echo "=== $db ==="
  portkill --remote --json dba@$db list 5432 | jq -r '.processes[] | "\(.pid): \(.user) - \(.command)"'
done

# Emergency process termination on production
portkill --remote --interactive --force ops@prod-app-server kill 9000

# Graceful service restart across load balancer pool
for server in app-{01..05}; do
  portkill --remote deploy@$server --dry-run kill 8080  # Preview first
  portkill --remote deploy@$server kill 8080           # Then execute
  ssh deploy@$server "systemctl start myapp"           # Restart service
done
```

#### DevOps Automation & CI/CD Integration
```bash
# Deployment script with process cleanup
#!/bin/bash
HOST="deploy@$1"
PORT="$2"

# Check what's running before deployment
echo "Current processes on $HOST:$PORT:"
portkill --remote --json $HOST list $PORT | jq '.processes | length'

# Clean up old processes
if [[ $(portkill --remote --json $HOST list $PORT | jq '.processes | length') -gt 0 ]]; then
  portkill --remote $HOST kill $PORT
fi

# Deploy new version
ssh $HOST "docker-compose up -d"

# Verify deployment
sleep 5
portkill --remote --json $HOST list $PORT | jq -r '.processes[] | "New PID: \(.pid)"'
```

#### Kubernetes & Container Orchestration
```bash
# Check processes on Kubernetes worker nodes
for node in k8s-worker-{01..10}; do
  echo "=== $node ==="
  portkill --remote --docker --json admin@$node list 8080 | jq -r '.processes[] | select(.type=="container") | "\(.name): \(.container_id[0:12])"'
done

# Emergency container cleanup on specific node
portkill --remote --docker --force admin@k8s-worker-03 kill 9000

# Audit container processes across cluster
kubectl get nodes -o name | cut -d/ -f2 | while read node; do
  portkill --remote --docker --json admin@$node list 8080 > "/tmp/audit-$node.json"
done
```

#### Database Administration & Monitoring
```bash
# Monitor database connections across replicas
for db in postgres-{master,slave1,slave2}; do
  CONNECTIONS=$(portkill --remote --json postgres@$db list 5432 | jq '.processes | length')
  echo "$db: $CONNECTIONS active connections"
done

# Emergency connection cleanup on overloaded server
portkill --remote --interactive postgres@db-server "kill processes consuming >90% CPU"

# Scheduled connection audit (use in cron)
portkill --remote --json monitoring@postgres-master list 5432 | \
  jq '{host: .host, port: .port, connection_count: (.processes | length), timestamp: .timestamp}' | \
  curl -X POST -H "Content-Type: application/json" -d @- http://monitoring.internal/api/db-metrics
```

#### Security & Incident Response
```bash
# Rapid incident response - kill suspicious processes across infrastructure
for server in $(cat compromised-servers.txt); do
  echo "Cleaning up $server..."
  portkill --remote --force root@$server kill 4444 31337 1337  # Common backdoor ports
done

# Security audit - find processes running on non-standard ports
for server in prod-web-{01..20}; do
  portkill --remote --json security@$server list 1337 | \
    jq -r 'select(.processes | length > 0) | "ALERT: \(.host) has processes on port \(.port)"'
done

# Forensic analysis - capture process information before termination
portkill --remote --json forensics@suspect-server list 8080 > evidence-$(date +%Y%m%d).json
portkill --remote forensics@suspect-server kill 8080
```

#### Port Conflict Resolution
```bash
# Find what's using your port
portkill list 8080

# See the full process tree
portkill tree 8080

# Kill safely with confirmation
portkill --interactive 8080
```

#### Performance Testing
```bash
# Test your local API performance
portkill benchmark 8000 localhost

# Compare different environments
portkill benchmark 80 staging.yourapp.com
portkill benchmark 80 production.yourapp.com

# Load test your microservice
portkill benchmark 9000 localhost 100
```

### DevOps and System Administration

#### Production Monitoring
```bash
# Monitor critical services
portkill monitor 80 443 22 3306

# Real-time port health check
portkill benchmark 80 your-production-server.com

# Generate service reports
portkill history --analytics > service-report.txt
```

#### Infrastructure Diagnostics
```bash
# Identify resource-heavy processes
portkill list --detailed

# Security audit of open ports
portkill scan --security

# Network connectivity testing
portkill benchmark 443 api.external-service.com
```

#### Batch Operations
```bash
# Clean up development environments
portkill 3000-3010 8000-8010

# Monitor microservices stack
portkill monitor 8001 8002 8003 8004 8005

# Benchmark entire service mesh
for port in 8001 8002 8003; do
    portkill benchmark $port localhost 20
done
```

### Network Analysis

#### Connection Quality Testing
```bash
# Test CDN performance
portkill benchmark 80 cdn.yoursite.com

# Compare different DNS servers
portkill benchmark 53 8.8.8.8      # Google DNS
portkill benchmark 53 1.1.1.1      # Cloudflare DNS

# API endpoint reliability
portkill benchmark 443 api.github.com
```

#### Troubleshooting Network Issues
```bash
# Identify slow connections
portkill benchmark 80 slow-server.com

# Test firewall rules
portkill benchmark 22 internal-server.local

# Validate load balancer health
portkill benchmark 80 load-balancer.company.com
```

### Security and Compliance

#### Port Security Auditing
```bash
# Scan for unexpected open ports
portkill scan --security

# Identify processes by user
portkill list --detailed | grep "user:root"

# Monitor for unauthorized services
portkill monitor 1337 31337 4444  # Common backdoor ports
```

#### Compliance Reporting
```bash
# Generate port usage reports
portkill history --csv > compliance-report.csv

# Track service availability
portkill benchmark 443 compliance-endpoint.com

# Document running services
portkill list > services-inventory.txt
```

## Command Reference

### Core Commands

| Command | Description | Examples |
|---------|-------------|----------|
| **Default** | Kill processes on port(s) | `portkill 3000`<br>`portkill 3000 8080 9000`<br>`portkill 3000-3005` |
| **`list`** | Show processes on port(s) | `portkill list 3000`<br>`portkill list --detailed 8080`<br>`portkill list` (all ports) |
| **`tree`** | Process tree visualization | `portkill tree 3000`<br>`portkill tree --depth 5 8080` |
| **`monitor`** | Real-time port monitoring | `portkill monitor 3000 8080`<br>`portkill monitor --interval 2 3000` |
| **`benchmark`** | Performance testing | `portkill benchmark 3000`<br>`portkill benchmark 80 google.com`<br>`portkill benchmark 3000 localhost 50` |
| **`scan`** | Port discovery and analysis | `portkill scan`<br>`portkill scan --security` |
| **`history`** | Usage analytics | `portkill history`<br>`portkill history --analytics`<br>`portkill history --csv` |
| **`menu`** | Interactive terminal UI | `portkill menu` |

### Command Options

| Flag | Short | Description | Example |
|------|-------|-------------|----------|
| `--force` | `-f` | Use SIGKILL (force termination) | `portkill --force 3000` |
| `--dry-run` | `-n` | Preview actions without execution | `portkill --dry-run 3000` |
| `--interactive` | `-i` | Interactive confirmation | `portkill --interactive 8080` |
| `--verbose` | `-v` | Detailed logging output | `portkill --verbose list 3000` |
| `--quiet` | `-q` | Minimal output | `portkill --quiet 3000` |
| `--safe` | `-s` | Extra safety checks | `portkill --safe 3000` |
| `--detailed` | `-d` | Detailed process information | `portkill list --detailed 3000` |
| `--depth N` | | Tree visualization depth | `portkill tree --depth 10 3000` |
| `--security` | | Security-focused scanning | `portkill scan --security` |
| `--analytics` | | Show usage analytics | `portkill history --analytics` |
| `--csv` | | Export in CSV format | `portkill history --csv` |
| `--json` | | Export in JSON format | `portkill history --json` |

### Benchmark Command Options

```bash
# Syntax: portkill benchmark <port> [host] [test_count] [concurrent] [timeout]
portkill benchmark 3000                    # Basic test (10 tests, 5 concurrent)
portkill benchmark 3000 localhost         # Specify host
portkill benchmark 3000 localhost 20      # 20 tests
portkill benchmark 3000 localhost 50 10   # 50 tests, 10 concurrent
portkill benchmark 3000 localhost 20 5 10 # Custom timeout (10s)
```

## Performance Benchmarks

### System Performance

**Test Environment**: MacBook Pro M1, macOS 14.0, 16GB RAM

| Operation | Average Time | Notes |
|-----------|--------------|-------|
| Process Detection | ~80ms | Single port, `lsof` method |
| Process Termination | ~120ms | SIGTERM, single process |
| Port Range Scan | ~2.3s | All listening ports (1-65535) |
| Process Tree Build | ~150ms | Depth 5, complex hierarchy |
| Benchmark Test | ~200ms | 10 tests, localhost |
| History Query | ~45ms | 1000 entries |
| Interactive Menu Load | ~90ms | Full UI initialization |

### Benchmark Results Examples

**Local Development Server** (Node.js on port 3000):
```
✅ Excellent performance: All tests passed with avg response < 100ms
Average: 85ms | Min: 45ms | Max: 120ms
Throughput: 11.2 connections/sec | Success: 100%
```

**Remote API Endpoint** (HTTPS service):
```
✅ Good performance: All tests passed with avg response < 1s
Average: 298ms | Min: 159ms | Max: 513ms
Throughput: 3.4 connections/sec | Success: 100%
```

**Network Issue Detection**:
```
⚠️ Poor performance: Many connection failures (<80% success)
Average: 2.1s | Min: 890ms | Max: 5.0s (timeout)
Throughput: 0.7 connections/sec | Success: 65%
```

## Configuration

PortKill stores configuration and data in `~/.portkill/`:

```
~/.portkill/
├── config.conf        # User preferences and settings
├── whitelist.conf     # Protected processes list
├── portkill.log       # Operation and error logs
├── history.log        # Port usage history
└── cache/             # Temporary cache files
```

### Protected Processes

System-critical processes are automatically protected from termination:

**Default Protected Processes**:
- `launchd` (macOS system launcher)
- `kernel_task` (kernel processes)
- `systemstats` (system statistics)
- `sshd` (SSH daemon)
- `WindowServer` (macOS window manager)
- `loginwindow` (macOS login interface)
- `Finder`, `Dock`, `SystemUIServer` (macOS UI)

**Custom Protection**: Edit `~/.portkill/whitelist.conf`:
```bash
# Add your critical processes (one per line)
mongo
postgres
redis-server
nginx
your-critical-app
```

### Configuration Options

Edit `~/.portkill/config.conf` to customize behavior:

```bash
# Safety and behavior
safe_mode=true                    # Enable process protection
auto_confirm=false               # Require confirmation for kills
verbose_mode=false               # Detailed output by default

# Monitoring and performance
monitoring_interval=2            # Seconds between monitor updates
max_history_entries=1000        # Maximum history entries to keep

# UI preferences
enable_notifications=true        # Show system notifications
color_output=true                # Enable colored terminal output
show_process_tree=true           # Show process relationships
show_headers=true                # Display section headers

# Benchmarking defaults
benchmark_tests=10              # Default number of benchmark tests
benchmark_concurrent=5          # Default concurrent connections
benchmark_timeout=5             # Default timeout in seconds
```

## Troubleshooting

### Common Issues

#### "Command not found: portkill"
```bash
# Check if portkill is installed
which portkill

# Homebrew installation
brew install mr-tanta/portkill/portkill

# Manual installation
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/install.sh | bash

# Check PATH
echo $PATH | grep -o '/usr/local/bin'
```

#### "Permission denied" errors
```bash
# Run with sudo for system ports (< 1024)
sudo portkill 80

# Check file permissions
ls -la $(which portkill)

# Fix permissions if needed
sudo chmod +x /usr/local/bin/portkill
```

#### "No processes found on port"
```bash
# Verify port is actually in use
lsof -i :3000
netstat -an | grep :3000

# Check if port is IPv6
lsof -i6 :3000

# Force IPv4 scanning
portkill --verbose list 3000
```

#### Benchmark tests failing
```bash
# Check network connectivity
ping google.com

# Test with different tools
nc -zv google.com 80
telnet google.com 80

# Install missing dependencies
# macOS
brew install netcat

# Linux
sudo apt-get install netcat  # Ubuntu/Debian
sudo yum install nc          # CentOS/RHEL
```

### Debugging

#### Enable Verbose Logging
```bash
# Temporary verbose mode
portkill --verbose list 3000

# Check logs
tail -f ~/.portkill/portkill.log

# Enable debug mode permanently
echo "verbose_mode=true" >> ~/.portkill/config.conf
```

#### Reset Configuration
```bash
# Backup current config
cp -r ~/.portkill ~/.portkill.backup

# Reset to defaults
rm -rf ~/.portkill
portkill --version  # Recreates default config
```

### Platform-Specific Issues

#### macOS
```bash
# Install missing dependencies
brew install coreutils  # For timeout command
brew install bc         # For calculations

# Fix Gatekeeper issues
xattr -d com.apple.quarantine /usr/local/bin/portkill
```

#### Linux
```bash
# Install required dependencies
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install lsof bc

# Optional: install additional detection tools
sudo apt-get install net-tools  # netstat
sudo apt-get install iproute2   # ss (usually pre-installed)
sudo apt-get install psmisc     # fuser

# CentOS/RHEL
sudo yum install lsof bc
sudo yum install net-tools      # optional: netstat

# Arch Linux
sudo pacman -S lsof bc
sudo pacman -S net-tools        # optional: netstat
```

## FAQ

### General Questions

**Q: Is PortKill safe to use in production?**  
A: Yes, PortKill has built-in safety features including process protection, dry-run mode, and interactive confirmations. Always test in staging first.

**Q: Can PortKill handle IPv6 ports?**  
A: Yes, PortKill automatically detects both IPv4 and IPv6 connections on the same port number.

**Q: Does PortKill work with Docker containers?**  
A: Yes, PortKill can kill processes inside containers that are bound to host ports. Use `portkill list` to see container processes.

### Performance Questions

**Q: Why is port scanning slow on my system?**  
A: Large port ranges (1-65535) can take time. Use specific ports or ranges when possible: `portkill list 3000` vs `portkill list`.

**Q: Can I benchmark internal services?**  
A: Yes, use `portkill benchmark 3000 localhost` for internal services or `portkill benchmark 8080 192.168.1.100` for LAN services.

### Security Questions

**Q: What processes are protected by default?**  
A: System-critical processes like `launchd`, `sshd`, `kernel_task`, and others. See the Protected Processes section above.

**Q: Can I disable process protection?**  
A: Yes, but not recommended. Edit `~/.portkill/config.conf` and set `safe_mode=false`. Use with extreme caution.

**Q: Does PortKill log all operations?**  
A: Yes, all operations are logged to `~/.portkill/portkill.log` and `~/.portkill/history.log` for auditing purposes.

## Uninstallation

### Automatic Uninstall
```bash
# One-line removal
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/uninstall.sh | bash

# Remove configuration files too
curl -sSL https://raw.githubusercontent.com/mr-tanta/portkill/main/uninstall.sh | bash -s -- --remove-config
```

### Manual Removal
```bash
# Remove binary
sudo rm /usr/local/bin/portkill

# Remove configuration (optional)
rm -rf ~/.portkill

# Or find and remove from PATH
which portkill | xargs sudo rm
```

### Homebrew Uninstall
```bash
# Remove PortKill
brew uninstall portkill

# Remove tap (optional)
brew untap mr-tanta/portkill
```

## Contributing

We welcome contributions from the community!

### Quick Start for Contributors

```bash
# Fork and clone
git clone https://github.com/your-username/portkill.git
cd portkill

# Create feature branch
git checkout -b feature/awesome-new-feature

# Make your changes
vim bin/portkill

# Test your changes
./bin/portkill --version
./bin/portkill benchmark 80 google.com

# Commit and push
git add .
git commit -m "✨ Add awesome new feature"
git push origin feature/awesome-new-feature

# Create pull request
gh pr create --title "✨ Add awesome new feature" --body "Description of changes"
```

### Areas for Contribution

- **New Features**: Additional commands, integrations, platforms
- **Performance**: Speed optimizations, memory improvements
- **Platform Support**: Windows support, new Linux distros
- **UI/UX**: Enhanced interactive mode, better visualizations
- **Documentation**: Tutorials, guides, translations
- **Testing**: Unit tests, integration tests, CI/CD improvements

### Development Guidelines

- Follow existing code style and conventions
- Add tests for new features
- Update documentation for any changes
- Ensure cross-platform compatibility (macOS/Linux)
- Test thoroughly before submitting

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## Acknowledgments

### Contributors

Thanks to all the amazing contributors who have helped make PortKill better:

- **Abraham Esandayinze Tanta** - Creator and maintainer
- **Community Contributors** - Feature requests, bug reports, and improvements

### Built With

- **Bash** - Core scripting language
- **lsof** - Primary process and port detection
- **ss/netstat/fuser** - Optional additional detection methods
- **nc/netcat** - Network connectivity testing
- **bc** - Mathematical calculations
- **GitHub Actions** - CI/CD pipeline
- **Homebrew** - Package management

### Inspiration

PortKill was created to solve the daily frustration of port conflicts during development. Inspired by the Unix philosophy of doing one thing well, it combines powerful functionality with ease of use.

## 📝 License

**MIT License** - see [LICENSE](LICENSE) file for details.

```
Copyright (c) 2025 Abraham Esandayinze Tanta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

## 👤 Author & Maintainer

**Abraham Esandayinze Tanta**
- GitHub: [@mr-tanta](https://github.com/mr-tanta)
- Email: [Contact via GitHub](https://github.com/mr-tanta)

##  Support & Community

### Bug Reports & Feature Requests

- **Issues**: [GitHub Issue Tracker](https://github.com/mr-tanta/portkill/issues)
- **Features**: [Feature Request Template](https://github.com/mr-tanta/portkill/issues/new?template=feature_request.md)
- **Bugs**: [Bug Report Template](https://github.com/mr-tanta/portkill/issues/new?template=bug_report.md)

### 💬 Discussions & Help

- **Discussions**: [GitHub Discussions](https://github.com/mr-tanta/portkill/discussions)
- **Q&A**: Check the FAQ section above
- **Stack Overflow**: Tag questions with `portkill`

### 🔗 Links & Resources

- **Repository**: https://github.com/mr-tanta/portkill
- **Releases**: https://github.com/mr-tanta/portkill/releases
- **Homebrew Tap**: https://github.com/mr-tanta/homebrew-portkill
- **Documentation**: This README and inline help (`portkill --help`)

---

<div align="center">

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=mr-tanta/portkill&type=Date)](https://www.star-history.com/#mr-tanta/portkill&Date)

---

### **Made with ❤️ by developers, for developers**

**PortKill** - *Because port conflicts shouldn't slow you down*

[⬆️ Back to Top](#-portkill---advanced-port-management--network-analysis-tool)

</div>
