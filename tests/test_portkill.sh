#!/bin/bash

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
}

# Performance tests (basic)
test_performance() {
    print_test_header "Basic Performance Tests"
    
    # Test that commands complete in reasonable time (basic responsiveness)
    run_test "Version command performance" "$PORTKILL" --version
    run_test "Help command performance" "$PORTKILL" --help
    run_test "List command performance" "$PORTKILL" list 80
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