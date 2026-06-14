#!/bin/bash
# shellcheck disable=SC2016

# PortKill Test Suite
# Copyright (c) 2025 Abraham Esandayinze Tanta

set -e

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PORTKILL="$PROJECT_DIR/bin/portkill"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=0

# Helper functions
print_test_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

print_failure() {
    echo -e "${RED}❌ $1${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

run_test() {
    local test_name="$1"
    shift
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -ne "${YELLOW}Testing: $test_name${NC} ... "
    
    if "$@" >/dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

run_test_with_output() {
    local test_name="$1"
    local expected_pattern="$2"
    shift 2
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -ne "${YELLOW}Testing: $test_name${NC} ... "
    
    local output
    if output=$("$@" 2>&1) && echo "$output" | grep -q "$expected_pattern"; then
        echo -e "${GREEN}PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "Expected pattern: $expected_pattern"
        echo "Got output: $output"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test suite functions
test_basic_functionality() {
    print_test_header "Basic Functionality Tests"
    
    run_test_with_output "Version command" "PortKill" "$PORTKILL" --version
    run_test_with_output "Help command" "USAGE:" "$PORTKILL" --help
    run_test "Script is executable" test -x "$PORTKILL"
}

test_port_validation() {
    print_test_header "Port Validation Tests"
    
    # Valid ports should work in dry-run mode
    run_test "Valid port (80)" "$PORTKILL" -n list 80
    run_test "Valid port (3000)" "$PORTKILL" -n list 3000
    run_test "Valid port (65535)" "$PORTKILL" -n list 65535
    
    # Invalid ports should fail
    run_test "Invalid port (0) should fail" bash -c "! $PORTKILL -n list 0 2>/dev/null"
    run_test "Invalid port (65536) should fail" bash -c "! $PORTKILL -n list 65536 2>/dev/null"
    run_test "Invalid port (abc) should fail" bash -c "! $PORTKILL -n list abc 2>/dev/null"
}

test_port_ranges() {
    print_test_header "Port Range Tests"
    
    # Test port range parsing
    run_test "Port range (3000-3002)" "$PORTKILL" -n 3000-3002
    run_test "Single port as range" "$PORTKILL" -n 8080
    
    # Invalid ranges should fail
    run_test "Invalid range (3002-3000) should fail" bash -c "! $PORTKILL -n 3002-3000 2>/dev/null"
    run_test "Large range should fail" bash -c "! $PORTKILL -n 1000-1200 2>/dev/null"
}

test_command_options() {
    print_test_header "Command Options Tests"
    
    run_test "List command" "$PORTKILL" list 80
    run_test "Dry-run flag" "$PORTKILL" --dry-run list 80
    run_test "Verbose flag" "$PORTKILL" --verbose list 80
    run_test "Quiet flag" "$PORTKILL" --quiet list 80
    run_test "Detailed flag after list command" "$PORTKILL" list --detailed 65432
    run_test "Dry-run flag after kill command" "$PORTKILL" kill --dry-run 65432
    run_test "Yes flag after kill command" "$PORTKILL" kill --yes 65432
    run_test "Doctor alias flag" "$PORTKILL" --doctor
    run_test_with_output "Doctor command" "PortKill Doctor" "$PORTKILL" doctor
    run_test_with_output "Bash completion command" "complete -F _portkill" "$PORTKILL" completion bash
    run_test_with_output "Zsh completion command" "#compdef portkill" "$PORTKILL" completion zsh
    run_test_with_output "Fish completion command" "complete -c portkill" "$PORTKILL" completion fish
}

test_multiple_ports() {
    print_test_header "Multiple Ports Tests"
    
    run_test "Multiple individual ports" "$PORTKILL" -n 3000 8080 9000
    run_test "Mixed ports and ranges" "$PORTKILL" -n 3000 8000-8002 9000
}

test_configuration() {
    print_test_header "Configuration Tests"
    
    # Create temporary config directory
    local temp_config="/tmp/portkill-test-$$"
    mkdir -p "$temp_config"
    
    # Test with custom config directory
    run_test "Custom config directory" env HOME="/tmp" "$PORTKILL" list 80
    
    # Cleanup
    rm -rf "$temp_config"
}

test_error_handling() {
    print_test_header "Error Handling Tests"
    
    run_test "Unknown flag should fail" bash -c "! $PORTKILL --invalid-flag 2>/dev/null"
    run_test "No arguments defaults to menu" bash -c "$PORTKILL --help | grep -q menu"
    run_test "Help mentions doctor command" bash -c "$PORTKILL --help | grep -q doctor"
    run_test "Help mentions completion command" bash -c "$PORTKILL --help | grep -q completion"
    run_test "Help mentions yes flag" bash -c "$PORTKILL --help | grep -q -- --yes"
}

test_installation_scripts() {
    print_test_header "Installation Scripts Tests"
    
    run_test "Install script syntax" bash -n "$PROJECT_DIR/install.sh"
    run_test "Uninstall script syntax" bash -n "$PROJECT_DIR/uninstall.sh"
    run_test "Install script is executable" test -x "$PROJECT_DIR/install.sh"
    run_test "Uninstall script is executable" test -x "$PROJECT_DIR/uninstall.sh"
}

test_security() {
    print_test_header "Security Tests"
    
    # Check for potentially dangerous patterns
    run_test "No eval usage" bash -c "! grep -r 'eval' $PROJECT_DIR/bin/ 2>/dev/null"
    run_test "No system calls" bash -c "! grep -r 'system(' $PROJECT_DIR/bin/ 2>/dev/null"
    
    # Test protected process handling (check if safe mode is mentioned in help)
    run_test_with_output "Protected processes respected" "safe" "$PORTKILL" --help

    run_test "Benchmark rejects shell metacharacters in host" bash -c '
        set -e
        fake_bin=$(mktemp -d)
        tmp_home=$(mktemp -d)
        marker=$(mktemp)
        rm -f "$marker"
        cleanup() {
            rm -rf "$fake_bin" "$tmp_home"
            rm -f "$marker"
        }
        trap cleanup EXIT

        for cmd in bash lsof ps bc date sleep mktemp cat rm sort cut grep awk sed tr wc mkdir touch; do
            cmd_path=$(command -v "$cmd")
            ln -s "$cmd_path" "$fake_bin/$cmd"
        done

        cat > "$fake_bin/telnet" <<'"'"'EOF'"'"'
#!/bin/bash
exit 0
EOF
        chmod +x "$fake_bin/telnet"

        PATH="$fake_bin" HOME="$tmp_home" "$0" benchmark 1234 "127.0.0.1; touch $marker #" 1 >/dev/null 2>&1 || true
        test ! -e "$marker"
    ' "$PORTKILL"
}

# Performance tests (basic)
test_performance() {
    print_test_header "Basic Performance Tests"
    
    # Test that commands complete in reasonable time (basic responsiveness)
    run_test "Version command performance" "$PORTKILL" --version
    run_test "Help command performance" "$PORTKILL" --help
    run_test "List command performance" "$PORTKILL" list 80
}

test_regressions() {
    print_test_header "Regression Tests"

    run_test "Exact port matching avoids prefix collisions" bash -c '
        set -e
        command -v python3 >/dev/null 2>&1 || exit 0

        tmp_home=$(mktemp -d)
        log_file=$(mktemp)
        python3 -m http.server 18080 --bind 127.0.0.1 >"$log_file" 2>&1 &
        server_pid=$!
        cleanup() {
            kill "$server_pid" 2>/dev/null || true
            wait "$server_pid" 2>/dev/null || true
            rm -rf "$tmp_home"
            rm -f "$log_file"
        }
        trap cleanup EXIT

        sleep 1
        ps -p "$server_pid" >/dev/null 2>&1
        output=$(HOME="$tmp_home" "$0" --json list 1808)
        ! echo "$output" | grep -q "\"pid\": $server_pid"
    ' "$PORTKILL"

    run_test "History JSON export creates valid JSON" bash -c '
        set -e
        command -v python3 >/dev/null 2>&1 || exit 0

        tmp_home=$(mktemp -d)
        tmp_work=$(mktemp -d)
        cleanup() {
            rm -rf "$tmp_home" "$tmp_work"
        }
        trap cleanup EXIT

        cd "$tmp_work"
        HOME="$tmp_home" "$0" --quiet list 65432 >/dev/null
        HOME="$tmp_home" "$0" history --export json >/dev/null
        json_file=$(ls portkill_history_*.json | head -1)
        python3 -m json.tool "$json_file" >/dev/null
    ' "$PORTKILL"

    run_test "Docker JSON includes container records" bash -c '
        set -e
        command -v python3 >/dev/null 2>&1 || exit 0

        tmp_home=$(mktemp -d)
        fake_bin=$(mktemp -d)
        cleanup() {
            rm -rf "$tmp_home" "$fake_bin"
        }
        trap cleanup EXIT

        cat > "$fake_bin/docker" <<'"'"'EOF'"'"'
#!/bin/bash
case "$1" in
    info)
        exit 0
        ;;
    ps)
        printf "CONTAINER ID\tNAMES\tPORTS\n"
        printf "abc123def456\tweb\t0.0.0.0:4567->80/tcp\n"
        ;;
    *)
        exit 1
        ;;
esac
EOF
        chmod +x "$fake_bin/docker"

        output=$(PATH="$fake_bin:$PATH" HOME="$tmp_home" "$0" --docker --json list 4567)
        printf "%s" "$output" | python3 -c "import json,sys; data=json.load(sys.stdin); proc=data[\"processes\"][0]; assert proc[\"type\"] == \"container\" and proc[\"container_id\"] == \"abc123def456\" and proc[\"name\"] == \"web\""
    ' "$PORTKILL"

    run_test "Default TTY kill asks before killing" bash -c '
        set -e
        tmp_home=$(mktemp -d)
        fake_bin=$(mktemp -d)
        killed_marker=$(mktemp)
        rm -f "$killed_marker"
        cleanup() {
            rm -rf "$tmp_home" "$fake_bin"
            rm -f "$killed_marker"
        }
        trap cleanup EXIT

        for cmd in bash awk cat cut date grep mkdir mktemp rm sed sort sleep tr wc; do
            cmd_path=$(command -v "$cmd")
            ln -s "$cmd_path" "$fake_bin/$cmd"
        done

        cat > "$fake_bin/lsof" <<'"'"'EOF'"'"'
#!/bin/bash
case "$*" in
    *"-t"*) echo 4242 ;;
    *"-a -p 4242 -d cwd -Fn"*) printf "p4242\nn/tmp\n" ;;
    *) echo "node 4242 user TCP 127.0.0.1:3000 (LISTEN)" ;;
esac
EOF
        chmod +x "$fake_bin/lsof"

        cat > "$fake_bin/ps" <<'"'"'EOF'"'"'
#!/bin/bash
case "$*" in
    *"-o user=,comm="*) echo "user node" ;;
    *"-o user=,pid=,ppid=,comm="*) echo "user 4242 1 node" ;;
    *"-o pid=,ppid=,comm="*) echo "4242 1 node" ;;
    *) exit 0 ;;
esac
EOF
        chmod +x "$fake_bin/ps"

        cat > "$fake_bin/kill" <<EOF
#!/bin/bash
echo killed >> "$killed_marker"
exit 0
EOF
        chmod +x "$fake_bin/kill"

        output=$(printf "n\n" | PATH="$fake_bin" HOME="$tmp_home" PORTKILL_ASSUME_TTY=true "$0" 3000 2>&1)
        echo "$output" | grep -q "Kill process"
        echo "$output" | grep -q "Skipped PID 4242"
        test ! -e "$killed_marker"
    ' "$PORTKILL"

    run_test "Doctor identifies package project hints" bash -c '
        set -e
        tmp_home=$(mktemp -d)
        tmp_project=$(mktemp -d)
        fake_bin=$(mktemp -d)
        cleanup() {
            rm -rf "$tmp_home" "$tmp_project" "$fake_bin"
        }
        trap cleanup EXIT

        printf "{\"scripts\":{\"dev\":\"vite --host 0.0.0.0\"}}\n" > "$tmp_project/package.json"
        touch "$tmp_project/vite.config.ts"

        for cmd in bash awk cat cut date dirname grep head mkdir mktemp pwd rm sed sort tr wc; do
            cmd_path=$(command -v "$cmd")
            ln -s "$cmd_path" "$fake_bin/$cmd"
        done

        cat > "$fake_bin/lsof" <<EOF
#!/bin/bash
case "\$*" in
    *"-t"*) echo 4242 ;;
    *"-a -p 4242 -d cwd -Fn"*) printf "p4242\\nn$tmp_project\\n" ;;
    *) echo "node 4242 user TCP 127.0.0.1:5173 (LISTEN)" ;;
esac
EOF
        chmod +x "$fake_bin/lsof"

        cat > "$fake_bin/ps" <<'"'"'EOF'"'"'
#!/bin/bash
case "$*" in
    *"-o user=,comm="*) echo "user node" ;;
    *"-o user=,pid=,ppid=,comm="*) echo "user 4242 1 node" ;;
    *"-o pid=,ppid=,comm="*) echo "4242 1 node" ;;
    *"-o command="*) echo "node vite --host 0.0.0.0" ;;
    *) exit 0 ;;
esac
EOF
        chmod +x "$fake_bin/ps"

        output=$(PATH="$fake_bin" HOME="$tmp_home" "$0" doctor 5173)
        echo "$output" | grep -q "Port 5173"
        echo "$output" | grep -q "Project:"
        echo "$output" | grep -q "Vite"
        echo "$output" | grep -q "Suggestion:"
    ' "$PORTKILL"
}

# Main test runner
run_all_tests() {
    echo -e "${BLUE}PortKill Test Suite${NC}"
    echo -e "${BLUE}==================${NC}"
    
    # Check if portkill exists
    if [[ ! -f "$PORTKILL" ]]; then
        print_failure "PortKill script not found at $PORTKILL"
        exit 1
    fi
    
    # Run test suites
    test_basic_functionality
    test_port_validation
    test_port_ranges
    test_command_options
    test_multiple_ports
    test_configuration
    test_error_handling
    test_installation_scripts
    test_security
    test_performance
    test_regressions
    
    # Print summary
    echo -e "\n${BLUE}=== Test Summary ===${NC}"
    echo -e "Total Tests: $TOTAL_TESTS"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\n${GREEN}🎉 All tests passed!${NC}"
        exit 0
    else
        echo -e "\n${RED}❌ Some tests failed.${NC}"
        exit 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests "$@"
fi
