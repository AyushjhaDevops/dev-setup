#!/usr/bin/env bash
#
# Manjaro Developer Environment Manager
# Phase 1: CLI foundation. Existing installer/verifier remain the execution layer.

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

readonly VERSION="0.2.0-dev"

usage() {
    cat <<'EOF'
Manjaro Developer Environment Manager

Usage:
  dev-setup.sh help
  dev-setup.sh version
  dev-setup.sh system info
  dev-setup.sh install
  dev-setup.sh health check

Commands:
  help           Show this help message.
  version        Show the CLI version.
  system info    Display basic operating-system and hardware information.
  install        Run the existing interactive setup-dev.sh installer.
  health check   Run the existing verify-setup.sh verification script.

Safety:
  The install command delegates to the legacy interactive installer.
  It may install packages and perform a system upgrade. Review its prompts
  and the Pacman transaction carefully before approving any changes.
  This CLI does not yet support dry-run or profile-based installation.
EOF
}

usage_error() {
    log_error "$1"
    printf '\n' >&2
    usage >&2
    exit 2
}

show_system_info() {
    local pretty_name="Unknown Linux distribution"
    local kernel architecture cpu_model memory_total

    if [[ -r /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        pretty_name="${PRETTY_NAME:-${NAME:-$pretty_name}}"
    fi

    kernel="$(uname -r 2>/dev/null || printf 'unknown')"
    architecture="$(uname -m 2>/dev/null || printf 'unknown')"
    cpu_model="Unknown"
    memory_total="Unknown"

    if [[ -r /proc/cpuinfo ]]; then
        cpu_model="$(awk -F: '/model name/ {sub(/^[ \t]+/, "", $2); print $2; exit}' /proc/cpuinfo)"
        cpu_model="${cpu_model:-Unknown}"
    fi

    if [[ -r /proc/meminfo ]]; then
        memory_total="$(awk '/MemTotal:/ {printf "%.1f GiB", $2 / 1024 / 1024}' /proc/meminfo)"
        memory_total="${memory_total:-Unknown}"
    fi

    printf 'System information\n'
    printf '%-16s %s\n' 'Distribution:' "$pretty_name"
    printf '%-16s %s\n' 'Kernel:' "$kernel"
    printf '%-16s %s\n' 'Architecture:' "$architecture"
    printf '%-16s %s\n' 'CPU:' "$cpu_model"
    printf '%-16s %s\n' 'Memory:' "$memory_total"
    printf '%-16s %s\n' 'Package manager:' "$(command -v pacman || printf 'not found')"
    printf '%-16s %s\n' 'Init system:' "$(command -v systemctl || printf 'not found')"
}

run_legacy_script() {
    local script_path="$1"
    local description="$2"

    if [[ ! -f "$script_path" ]]; then
        log_error "$description script not found: $script_path"
        return 1
    fi

    log_info "Starting $description."
    exec bash "$script_path"
}

main() {
    if (( $# == 0 )); then
        usage
        return 0
    fi

    case "$1" in
        help|-h|--help)
            (( $# == 1 )) || usage_error "The help command does not accept arguments."
            usage
            ;;
        version|-v|--version)
            (( $# == 1 )) || usage_error "The version command does not accept arguments."
            printf 'dev-setup %s\n' "$VERSION"
            ;;
        system)
            (( $# == 2 )) || usage_error "Usage: dev-setup.sh system info"
            [[ "$2" == "info" ]] || usage_error "Unknown system command: $2"
            show_system_info
            ;;
        install)
            (( $# == 1 )) || usage_error "Usage: dev-setup.sh install"
            run_legacy_script "$SCRIPT_DIR/setup-dev.sh" "legacy installer"
            ;;
        health)
            (( $# == 2 )) || usage_error "Usage: dev-setup.sh health check"
            [[ "$2" == "check" ]] || usage_error "Unknown health command: $2"
            run_legacy_script "$SCRIPT_DIR/verify-setup.sh" "environment verification"
            ;;
        *)
            usage_error "Unknown command: $1"
            ;;
    esac
}

main "$@"
