# Changelog

All notable changes to PortKill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.2.0] - 2026-06-14

### Added
- Preset port groups with `--preset node`, `--preset web`, `--preset db`, `--preset full`, and `--list-presets`.
- Read-only `portkill cache doctor` diagnostics for common project and user-level development cache directories.
- Richer `portkill doctor <port>` output with likely start command detection, exact next commands, and manual restart guidance.
- README comparison against `port-kill`, `kill-port`, and `fkill`, plus a note to keep any future Windows support PowerShell-native rather than bloating the Bash CLI.

### Changed
- Preset invocations default to inspection when no command is supplied, so `portkill --preset node` lists matching ports instead of killing them.

## [3.1.1] - 2026-06-14

### Fixed
- Exact port matching now avoids false positives such as port `80` matching `8080`.
- JSON history export now emits valid JSON.
- Docker JSON output now includes container records.
- Flags after subcommands now work, for example `portkill list --detailed 3000`.
- Benchmark telnet fallback no longer runs user-controlled host values through `bash -c`.
- Package uninstall hooks no longer terminate user-managed `portkill` commands.
- Package-managed `/etc/portkill/portkill.conf` now uses supported runtime keys.
- Install and uninstall scripts now match documented version, prefix, and config-removal arguments.

### Changed
- Runtime dependency checks now require `ps`, `kill`, and at least one detector: `lsof`, `ss`, `netstat`, or `fuser`.
- README and installation docs now reflect the current local-only CLI and package channel behavior.

## [3.0.0] - 2024-09-26

### SIMPLIFICATION RELEASE - "Back to Unix Roots"

**STRATEGIC DECISION**: PortKill returns to its core mission of reliable port management without bloat.

### Philosophy Shift
- **Unix Philosophy Embraced**: "Do one thing and do it well"
- **Zero Dependencies**: Pure Bash with standard Unix utilities only
- **Reliability Over Features**: Simpler code = fewer bugs
- **Foundation for Growth**: Clean base for future three-tier strategy

### Removed (Intentionally)
- **Web Dashboard**: Removed Python dependency and 400+ lines of complexity
- **WebSocket Support**: Eliminated real-time infrastructure overhead
- **Remote SSH Operations**: Simplified to focus on local port management
- **Complex JSON API**: Streamlined to essential structured output

### Enhanced Core Features
- **Lightweight**: Reduced from 3,371 to 2,106 lines (38% smaller)
- **Zero Dependencies**: No Python, Node.js, or external runtimes required
- **Faster Startup**: Instant execution, no runtime initialization overhead
- **Docker Integration**: Maintained container management capabilities
- **Simple JSON Output**: Clean, readable structured data when needed
- **Process Safety**: Preserved system process protection
- **Interactive Menu**: Kept user-friendly terminal interface
- **Performance Benchmarking**: Retained port connectivity testing
- **Security Scanning**: Maintained vulnerability detection
- **Process Trees**: Preserved hierarchical process visualization

### Technical Improvements
- **Size Reduction**: 72KB total (200x smaller than Rust alternatives)
- **Memory Usage**: <1MB runtime footprint
- **Startup Time**: <10ms cold start
- **Compatibility**: Works on any system with Bash + standard Unix tools
- **Maintainability**: Simpler codebase, easier to debug and extend
- **Reliability**: Fewer dependencies = fewer failure points

### New Documentation
- **Comprehensive Wiki**: Installation, philosophy, comparisons
- **Design Philosophy**: Explains strategic simplification rationale
- **Tool Comparison**: Detailed analysis vs alternatives
- **Architecture Guide**: Clean, function-based design

### Strategic Positioning
- **PortKill Core** (this version): Zero-dependency reliability for developers
- **PortKill Enterprise** (future): Advanced features in Go/Rust for teams
- **PortKill Cloud** (future): SaaS offering for organizations

### Breaking Changes
- `portkill serve` command removed (web dashboard eliminated)
- `--remote` flag removed (SSH operations eliminated)
- Complex JSON structure simplified to essential fields
- WebSocket endpoint `/ws` no longer exists

### Migration Guide
- **Basic usage unchanged**: `portkill 3000` still works exactly the same
- **Docker integration**: `portkill --docker list 3000` unchanged
- **JSON output**: `portkill --json list 3000` simplified but functional
- **Interactive mode**: `portkill menu` enhanced and streamlined
- **For web dashboard needs**: Use external monitoring tools or wait for PortKill Enterprise
- **For remote operations**: Use SSH + PortKill or wait for PortKill Enterprise

### Why This Matters
- **Developers get**: Rock-solid reliability without dependency headaches
- **System administrators get**: Predictable tool that works everywhere
- **DevOps engineers get**: Scriptable utility that integrates seamlessly
- **Everyone gets**: Fast, lightweight, dependable port management

**"Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away."** - Antoine de Saint-Exupéry

---

## [2.3.2] - 2024-12-21

### ENTERPRISE TRANSFORMATION RELEASE

### Added
- **Revolutionary Remote SSH Support**: Industry-first cross-server port management
  - `--remote user@server` flag for SSH-based remote operations
  - Complete process listing and termination across remote hosts
  - SSH key authentication with proper timeout handling
  - Interactive confirmations for remote operations
  - Dry-run support for remote actions
  - JSON output support for remote server data
  - Comprehensive error handling and connectivity diagnostics
  - Works with native Unix commands when PortKill isn't on remote server
  - History tracking for all remote operations
  - No competitor has this capability!

- **Complete Docker Integration**: Native container management
  - Automatic detection of Docker containers bound to specific ports
  - Container termination using native Docker commands (`docker stop`/`docker kill`)
  - `--docker` flag to enable Docker mode for all operations
  - Interactive confirmations for container operations
  - Dry-run support for container actions
  - Unified listing of both processes and containers
  - History tracking for container operations
  - Graceful handling when Docker is unavailable

- **JSON API Output**: Enterprise-grade machine-readable output
  - `--json` flag for structured data output with proper escaping
  - Complete process data: PID, user, command, cmdline, protected status
  - Docker container support: container_id, name, ports, type
  - Remote operation support: host field and remote process data
  - Perfect for CI/CD pipelines and enterprise automation
  - API integration ready for monitoring systems

### Enhanced
- **Process Listing**: Enhanced to display Docker containers alongside regular processes
- **Kill Operations**: Now handles both processes and containers in unified workflow
- **Interactive Mode**: Extended to support container management decisions
- **Progress Reporting**: Improved messaging to differentiate processes vs containers
- **Error Handling**: Better Docker availability detection and graceful degradation

### Technical Improvements
- Modular Docker detection functions (`check_docker_available`, `get_docker_container_info`)
- Container termination logic with proper error handling
- Consistent logging and history tracking for Docker operations
- Enhanced CLI help text to document Docker integration

### Competitive Advantages Achieved
- **INDUSTRY FIRST**: Only port management tool with remote SSH support
- **ENTERPRISE READY**: Docker + Remote + JSON = Complete DevOps solution
- **INFRASTRUCTURE SCALE**: Manage ports across entire server fleets
- **DEVELOPER FRIENDLY**: Unified interface for hybrid environments
- **AUTOMATION READY**: JSON output perfect for CI/CD integration
- **LIGHTWEIGHT LEADER**: 60KB vs competitors' 12MB+ bloat
- **TRUE MIT LICENSE**: vs competitors' restrictive licensing
- **NO DEPENDENCIES**: Pure Bash vs competitors' Rust compilation requirements

## [2.3.0] - 2024-12-20

### Added
- **Performance Benchmarking**: New benchmark command for port connectivity testing
  - Connection speed measurement with millisecond precision
  - Success rate tracking and failure diagnostics
  - Statistical analysis (min/max/avg, percentiles)
  - Remote endpoint testing capabilities
  - Concurrent connection testing
  - Performance ratings and recommendations

### Enhanced
- **Port Usage Analytics**: Comprehensive statistics and trend analysis
- **Export Capabilities**: CSV and JSON export for port usage data
- **Interactive Menu**: Improved terminal UI with better navigation
- **Process Tree Visualization**: Enhanced depth control and display formatting

### Fixed
- Improved error handling for network operations
- Better compatibility with different Unix environments
- Enhanced process detection reliability

## [2.2.0] - 2024-12-19

### Added
- **Process Tree Analysis**: Visualize parent-child process relationships
- **Real-time Monitoring**: Live port status updates with configurable intervals
- **Port Usage History**: Track and analyze port activity over time
- **Interactive Terminal UI**: Beautiful menu system with color-coded output
- **Security Scanning**: Identify potentially vulnerable services
- **Bulk Operations**: Handle multiple ports and port ranges efficiently

### Enhanced
- **Smart Process Detection**: Multi-layered detection with intelligent fallbacks
- **Protected Process Safeguards**: Prevent accidental termination of system processes
- **Verbose Logging**: Comprehensive operation logging with multiple verbosity levels
- **Progress Indicators**: Real-time progress bars for long operations

### Fixed
- Improved cross-platform compatibility
- Better error messages and user feedback
- Enhanced process detection accuracy

## [2.1.0] - 2024-12-18

### Added
- **Port Range Support**: Handle ranges like `3000-3005`
- **Interactive Confirmations**: Optional step-by-step process confirmation
- **Dry-run Mode**: Preview operations without executing them
- **Service Detection**: Automatic identification of common services

### Enhanced
- **Command-line Interface**: Improved argument parsing and validation
- **Output Formatting**: Color-coded, organized display of information
- **Error Handling**: Better error messages and graceful failure handling

### Fixed
- Process detection reliability improvements
- Signal handling for different process types
- Cross-platform compatibility issues

## [2.0.0] - 2024-12-17

### Added
- **Multi-port Support**: Kill processes on multiple ports simultaneously
- **Force Kill Option**: SIGKILL support with `--force` flag
- **Detailed Process Information**: Show users, command lines, and PIDs
- **Safe Mode**: Protect critical system processes from accidental termination

### Changed
- **Complete Rewrite**: Modern Bash implementation with robust error handling
- **Improved Architecture**: Modular design with better maintainability
- **Enhanced CLI**: More intuitive command structure and options

### Enhanced
- **Process Detection**: Multiple detection methods with fallbacks
- **User Experience**: Better output formatting and progress indication
- **Reliability**: Comprehensive testing and edge case handling

### Breaking Changes
- Command syntax changes for better consistency
- Configuration file format updates
- Some legacy options deprecated

## [1.0.0] - 2024-12-16

### Added
- **Initial Release**: Basic port killing functionality
- **Core Features**: 
  - Kill processes on specific ports
  - Simple command-line interface
  - Basic process detection using `lsof`
  - SIGTERM signal support

### Technical Foundation
- Bash-based implementation
- Unix/Linux compatibility
- Basic error handling
- Simple installation process

---

## Version Numbering

PortKill follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version when making incompatible API changes
- **MINOR** version when adding functionality in a backwards compatible manner  
- **PATCH** version when making backwards compatible bug fixes

## Development Philosophy

Each release focuses on:

1. **Developer Experience**: Making port management intuitive and powerful
2. **Enterprise Readiness**: Adding features needed for production environments
3. **Cross-Platform Compatibility**: Ensuring reliable operation across systems
4. **Performance**: Optimizing for speed and resource efficiency
5. **Safety**: Preventing accidental damage to critical systems

## Upcoming Features

- **REST API**: HTTP interface for programmatic access
- **Configuration Profiles**: Save and reuse common operation sets
- **Advanced Filtering**: More sophisticated process selection criteria
- **Integration Plugins**: Native support for popular development tools
- **Cluster Management**: Multi-server port management capabilities
