#!/usr/bin/env bash
#
# Dependency-free smoke tests for the Phase 1 CLI.
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
CLI="$ROOT_DIR/dev-setup.sh"
PASS=0
FAIL=0

pass() {
    printf '[PASS] %s\n' "$1"
    ((PASS+=1))
}

fail() {
    printf '[FAIL] %s\n' "$1" >&2
    ((FAIL+=1))
}

assert_contains() {
    local name="$1" output="$2" expected="$3"
    if [[ "$output" == *"$expected"* ]]; then
        pass "$name"
    else
        fail "$name (expected output to contain: $expected)"
    fi
}

assert_exit_code() {
    local name="$1" expected="$2"
    shift 2
    local actual=0
    "$@" >/dev/null 2>&1 || actual=$?
    if (( actual == expected )); then
        pass "$name"
    else
        fail "$name (expected exit $expected, got $actual)"
    fi
}

help_output="$(bash "$CLI" help)"
assert_contains "help lists system info" "$help_output" "system info"
assert_contains "help lists health check" "$help_output" "health check"
assert_contains "help documents install safety" "$help_output" "system upgrade"

version_output="$(bash "$CLI" version)"
assert_contains "version command returns version" "$version_output" "dev-setup 0.2.0-dev"

system_output="$(bash "$CLI" system info)"
assert_contains "system info reports distribution" "$system_output" "Distribution:"
assert_contains "system info reports architecture" "$system_output" "Architecture:"
assert_contains "system info reports memory" "$system_output" "Memory:"

assert_exit_code "unknown command returns usage error" 2 bash "$CLI" not-a-command
assert_exit_code "invalid system subcommand returns usage error" 2 bash "$CLI" system unknown
assert_exit_code "install rejects unsupported flags" 2 bash "$CLI" install --dry-run
assert_exit_code "health rejects missing subcommand" 2 bash "$CLI" health

printf '\nResults: %d passed, %d failed\n' "$PASS" "$FAIL"
(( FAIL == 0 ))
