#!/usr/bin/env bash

set -uo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

OK=0
FAIL=0
WARN=0

PYTHON_ENV="$HOME/Development/Python/venv"
PYTHON_BIN="$PYTHON_ENV/bin/python"

if [[ ! -x "$PYTHON_BIN" ]]; then
    PYTHON_BIN="$(command -v python3 || command -v python || true)"
fi

pass() {
    printf "${GREEN}[OK]${NC} %s\n" "$*"
    ((OK+=1))
}

missing() {
    printf "${RED}[MISSING]${NC} %s\n" "$*"
    ((FAIL+=1))
}

warning() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$*"
    ((WARN+=1))
}

section() {
    echo
    printf '%s\n' "${BLUE}============================================${NC}"
    printf '%s\n' "${BLUE} $* ${NC}"
    printf '%s\n' "${BLUE}============================================${NC}"
}

check_packages() {
    section "PACMAN PACKAGE VERIFICATION"

    local packages=(
        base-devel git git-lfs github-cli curl wget unzip zip p7zip
        rsync openssh jq yq htop btop fastfetch ripgrep fd fzf bat
        tree tmux direnv shellcheck shfmt pre-commit pciutils

        code neovim vim

        gcc clang llvm lldb gdb cmake ninja make pkgconf ccache

        python python-pip python-virtualenv
        python-numpy python-scipy python-pandas
        python-matplotlib python-scikit-learn jupyterlab

        nodejs npm pnpm

        nginx php php-fpm composer

        postgresql mariadb sqlite redis

        docker docker-compose kubectl helm terraform ansible packer

        httpie nmap wireshark-qt tcpdump bind traceroute net-tools

        mesa intel-media-driver vulkan-intel vulkan-tools
        vulkan-icd-loader libva-utils opencl-icd-loader clinfo

        qemu-desktop virt-manager libvirt
    )

    local pkg

    for pkg in "${packages[@]}"; do
        if pacman -Q "$pkg" >/dev/null 2>&1; then
            pass "$pkg"
        else
            missing "$pkg"
        fi
    done

    # Vagrant is an AUR package, not a normal repository dependency.
    if pacman -Q vagrant >/dev/null 2>&1 || command -v vagrant >/dev/null 2>&1; then
        pass "vagrant (AUR or existing installation)"
    else
        missing "vagrant (AUR)"
    fi

    # GCC supplies the G++ compiler on Manjaro.
    if pacman -Q gcc >/dev/null 2>&1; then
        pass "g++ package provider: gcc"
    else
        missing "G++ package provider: gcc"
    fi
}

check_commands() {
    section "EXECUTABLE VERIFICATION"

    local commands=(
        git git-lfs gh curl wget unzip zip 7z rsync ssh
        jq yq htop btop fastfetch rg fd fzf bat tree tmux
        direnv shellcheck shfmt pre-commit

        code nvim vim

        gcc g++ clang clang++ clangd llvm-config lldb gdb
        cmake ninja make pkg-config ccache

        python
        jupyter

        node npm pnpm

        nginx php php-fpm composer

        psql mariadb sqlite3 redis-server redis-cli

        docker docker-compose kubectl helm terraform ansible packer vagrant

        http nmap wireshark tcpdump dig nslookup traceroute ifconfig

        vulkaninfo glxinfo clinfo vainfo lspci

        qemu-system-x86_64 virt-manager virsh
    )

    local cmd
    local path

    for cmd in "${commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            path="$(command -v "$cmd")"
            pass "$cmd: $path"
        else
            missing "$cmd"
        fi
    done
}

check_python() {
    section "PYTHON AND AI LIBRARIES"

    if [[ -z "${PYTHON_BIN:-}" || ! -x "$PYTHON_BIN" ]]; then
        missing "Python interpreter"
        return
    fi

    pass "Python interpreter: $PYTHON_BIN"

    "$PYTHON_BIN" --version

    if [[ -x "$PYTHON_ENV/bin/python" ]]; then
        pass "Development Python virtual environment"
    else
        missing "Development Python virtual environment"
    fi

    local modules=(
        numpy scipy pandas matplotlib sklearn
    )

    local module

    for module in "${modules[@]}"; do
        if "$PYTHON_BIN" -c "import $module" >/dev/null 2>&1; then
            pass "Python module: $module"
        else
            missing "Python module: $module"
        fi
    done

    if "$PYTHON_BIN" -m pip --version >/dev/null 2>&1; then
        pass "Python pip"
    else
        missing "Python pip"
    fi

    if [[ -x "$PYTHON_ENV/bin/pyrefly" ]]; then
        pass "Pyrefly executable: $PYTHON_ENV/bin/pyrefly"
        "$PYTHON_ENV/bin/pyrefly" --version
    else
        missing "Pyrefly executable in development venv"
    fi
}

check_vscode() {
    section "VISUAL STUDIO CODE EXTENSIONS"

    if ! command -v code >/dev/null 2>&1; then
        missing "VS Code CLI"
        return
    fi

    local extensions=(
        ms-python.python
        meta.pyrefly
        ms-python.debugpy
        llvm-vs-code-extensions.vscode-clangd
        ms-vscode.cmake-tools
        ms-vscode.makefile-tools
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        ms-azuretools.vscode-docker
        ms-kubernetes-tools.vscode-kubernetes-tools
        hashicorp.terraform
        redhat.ansible
        eamodio.gitlens
        usernamehw.errorlens
        tamasfe.even-better-toml
    )

    local installed
    local extension

    installed="$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')"

    for extension in "${extensions[@]}"; do
        if grep -Fxq "$extension" <<< "$installed"; then
            pass "VS Code: $extension"
        else
            missing "VS Code: $extension"
        fi
    done
}

check_services() {
    section "SYSTEM SERVICES"

    local service

    for service in docker.service libvirtd.service; do
        if systemctl is-active --quiet "$service"; then
            pass "$service is running"
        else
            warning "$service is not running"
        fi

        if systemctl is-enabled --quiet "$service"; then
            pass "$service is enabled at boot"
        else
            warning "$service is not enabled at boot"
        fi
    done
}

check_docker() {
    section "DOCKER VERIFICATION"

    if ! command -v docker >/dev/null 2>&1; then
        missing "Docker CLI"
        return
    fi

    if docker info >/dev/null 2>&1; then
        pass "Docker daemon accessible"
    else
        missing "Docker daemon access"
        return
    fi

    if docker network ls >/dev/null 2>&1; then
        pass "Docker networking"
    else
        missing "Docker networking"
    fi

    if docker run --rm hello-world >/dev/null 2>&1; then
        pass "Docker container execution"
    else
        warning "Docker hello-world test failed (check network or image availability)"
    fi
}

check_workspace() {
    section "DEVELOPMENT WORKSPACE"

    local directories=(
        Web Python AI-ML C-Cpp DevOps Docker
        Kubernetes Projects Experiments
    )

    local dir

    for dir in "${directories[@]}"; do
        if [[ -d "$HOME/Development/$dir" ]]; then
            pass "$HOME/Development/$dir"

        else
            missing "$HOME/Development/$dir"
        fi
    done

    if [[ -d "$HOME/.local/bin" ]]; then
        pass "$HOME/.local/bin"
    else
        missing "$HOME/.local/bin"
    fi
}

check_git() {
    section "GIT CONFIGURATION"

    if ! command -v git >/dev/null 2>&1; then
        missing "Git configuration cannot be checked"
        return
    fi

    if [[ -n "$(git config --global user.name 2>/dev/null || true)" ]]; then
        pass "Git username configured"
    else
        warning "Git username not configured"
    fi

    if [[ -n "$(git config --global user.email 2>/dev/null || true)" ]]; then
        pass "Git email configured"
    else
        warning "Git email not configured"
    fi

    if [[ "$(git config --global init.defaultBranch 2>/dev/null || true)" == "main" ]]; then
        pass "Git default branch: main"
    else
        warning "Git default branch is not main"
    fi
}

check_graphics() {
    section "INTEL GRAPHICS"

    local cmd

    for cmd in lspci vulkaninfo clinfo vainfo; do
        if command -v "$cmd" >/dev/null 2>&1; then
            pass "$cmd available"
        else
            warning "$cmd unavailable"
        fi
    done

    if command -v lspci >/dev/null 2>&1; then
        lspci | grep -Ei 'VGA|Display|3D' || true
    fi
}

echo "MANJARO DEVELOPER WORKSTATION VERIFICATION"
echo "User: ${USER:-$(id -un)}"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "Python used for checks: ${PYTHON_BIN:-not found}"

check_packages
check_commands
check_python
check_vscode
check_services
check_docker
check_workspace
check_git
check_graphics

section "FINAL SUMMARY"

printf "${GREEN}PASSED: %s${NC}\n" "$OK"
printf "${RED}MISSING: %s${NC}\n" "$FAIL"
printf "${YELLOW}WARNINGS: %s${NC}\n" "$WARN"

echo

if (( FAIL == 0 )); then
    printf '%s\n' "${GREEN}All mandatory checks passed.${NC}"
else
    printf '%s\n' "${YELLOW}Some checks need attention. Review the output above.${NC}"
fi

if (( WARN > 0 )); then
    printf '%s\n' "${YELLOW}Warnings do not necessarily indicate missing software.${NC}"
fi

echo
echo "Total checks: $((OK + FAIL + WARN))"

(( FAIL == 0 ))
