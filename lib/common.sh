#!/usr/bin/env bash
#
# Shared helpers for the dev-setup command-line interface.

if [[ -n "${DEV_SETUP_COMMON_LOADED:-}" ]]; then
    return 0
fi
DEV_SETUP_COMMON_LOADED=1

if [[ -t 1 ]]; then
    DEV_SETUP_GREEN=$'\033[0;32m'
    DEV_SETUP_RED=$'\033[0;31m'
    DEV_SETUP_YELLOW=$'\033[1;33m'
    DEV_SETUP_RESET=$'\033[0m'
else
    DEV_SETUP_GREEN=''
    DEV_SETUP_RED=''
    DEV_SETUP_YELLOW=''
    DEV_SETUP_RESET=''
fi

log_info() {
    printf '%s[INFO]%s %s\n' "$DEV_SETUP_GREEN" "$DEV_SETUP_RESET" "$*"
}

log_warn() {
    printf '%s[WARNING]%s %s\n' "$DEV_SETUP_YELLOW" "$DEV_SETUP_RESET" "$*" >&2
}

log_error() {
    printf '%s[ERROR]%s %s\n' "$DEV_SETUP_RED" "$DEV_SETUP_RESET" "$*" >&2
}
