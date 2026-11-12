#!/usr/bin/env bash
#
# Manjaro Complete Developer Workstation Installer
# Web + Python/AI + C/C++ + DevOps + Virtualization
#
# Safe and repeatable:
# - Official Manjaro repositories for normal packages
# - Vagrant installed separately from AUR
# - Existing Python venv preserved
# - No automatic Git credential replacement
# - No graphics driver replacement
# - No database initialization
# - No automatic Docker group membership

set -Eeuo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    printf "${GREEN}[INFO]${NC} %s\n" "$*"
}

warn() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$*"
}

error() {
    printf "${RED}[ERROR]${NC} %s\n" "$*" >&2
}

section() {
    echo
    printf '%s\n' "${BLUE}============================================${NC}"
    printf '%s\n' "${BLUE} $* ${NC}"
    printf '%s\n' "${BLUE}============================================${NC}"
}

fail() {
    error "$*"
    exit 1
}

trap 'error "Installation failed near line $LINENO."' ERR

# --------------------------------------------------
# 1. System checks
# --------------------------------------------------

section "SYSTEM CHECKS"

if [[ "$EUID" -eq 0 ]]; then
    fail "Do not run as root. Run as your normal user."
fi

if [[ ! -r /etc/os-release ]]; then
    fail "Cannot identify Linux distribution."
fi

# shellcheck disable=SC1091
source /etc/os-release

if [[ "${ID:-}" != "manjaro" ]]; then
    fail "This installer is intended for Manjaro Linux."
fi

command -v pacman >/dev/null 2>&1 || fail "Pacman not found."
command -v sudo >/dev/null 2>&1 || fail "Sudo not found."

if [[ ! -t 0 ]]; then
    fail "Run this script in an interactive terminal."
fi

log "Distribution: $PRETTY_NAME"
log "Architecture: $(uname -m)"
log "User: $USER"

echo
read -r -p "Continue with workstation installation? [y/N]: " answer

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    log "Installation cancelled."
    exit 0
fi

# --------------------------------------------------
# 2. Network and sudo
# --------------------------------------------------

section "NETWORK AND PERMISSIONS"

if ! curl -Is --connect-timeout 10 https://manjaro.org >/dev/null 2>&1; then
    warn "Could not verify internet connectivity."
fi

sudo -v

log "Sudo authentication successful."

# --------------------------------------------------
# 3. Official repository packages
# --------------------------------------------------

section "PREPARING PACKAGES"

PACKAGES=(
    # Essential tools
    base-devel git git-lfs github-cli curl wget unzip zip p7zip
    rsync openssh jq yq htop btop fastfetch ripgrep fd fzf bat
    tree tmux direnv shellcheck shfmt pre-commit pciutils

    # Editors
    code neovim vim

    # C and C++
    gcc clang llvm lldb gdb cmake ninja make pkgconf ccache

    # Python
    python python-pip python-virtualenv
    python-numpy python-scipy python-pandas
    python-matplotlib python-scikit-learn jupyterlab

    # JavaScript
    nodejs npm pnpm

    # Web development
    nginx php php-fpm composer

    # Databases
    postgresql mariadb sqlite redis

    # DevOps
    docker docker-compose kubectl helm terraform ansible packer

    # Networking
    httpie nmap wireshark-qt tcpdump bind traceroute net-tools

    # Intel graphics
    mesa intel-media-driver vulkan-intel vulkan-tools
    vulkan-icd-loader libva-utils opencl-icd-loader clinfo

    # Virtualization
    qemu-desktop virt-manager libvirt
)

# --------------------------------------------------
# 4. Resolve packages
# --------------------------------------------------

section "CHECKING REPOSITORY AVAILABILITY"

AVAILABLE=()
UNAVAILABLE=()

for package in "${PACKAGES[@]}"; do
    if pacman -Si "$package" >/dev/null 2>&1; then
        AVAILABLE+=("$package")
    elif pacman -Q "$package" >/dev/null 2>&1; then
        log "$package is already installed."
    else
        UNAVAILABLE+=("$package")
    fi
done

log "Available repository packages: ${#AVAILABLE[@]}"

if (( ${#UNAVAILABLE[@]} > 0 )); then
    warn "Unavailable packages:"
    printf '  - %s\n' "${UNAVAILABLE[@]}"
fi

# --------------------------------------------------
# 5. System upgrade and installation
# --------------------------------------------------

section "UPDATING MANJARO"

warn "A full system upgrade will be performed."
warn "Review the pacman transaction before confirming."

if (( ${#AVAILABLE[@]} > 0 )); then
    sudo pacman -Syu --needed "${AVAILABLE[@]}"
else
    sudo pacman -Syu
fi

log "Repository package installation completed."

# --------------------------------------------------
# 6. Install Vagrant through AUR
# --------------------------------------------------

section "VAGRANT INSTALLATION"

if command -v vagrant >/dev/null 2>&1; then
    log "Vagrant already installed: $(vagrant --version)"
else
    warn "Vagrant is not available in your configured Manjaro repositories."
    warn "The following operation builds a community-maintained AUR package."

    read -r -p "Install Vagrant from AUR? [y/N]: " aur_answer

    if [[ "$aur_answer" =~ ^[Yy]$ ]]; then

        sudo pacman -S --needed base-devel git

        AUR_DIR="$HOME/Development/Tools/aur/vagrant"

        mkdir -p "$(dirname "$AUR_DIR")"

        if [[ -d "$AUR_DIR/.git" ]]; then
            git -C "$AUR_DIR" pull --ff-only
        else
            git clone https://aur.archlinux.org/vagrant.git "$AUR_DIR"
        fi

        cd "$AUR_DIR"

        echo
        warn "Review the AUR PKGBUILD before building."
        less PKGBUILD

        read -r -p "Build and install reviewed Vagrant package? [y/N]: " build_answer

        if [[ "$build_answer" =~ ^[Yy]$ ]]; then
            makepkg -si
        else
            warn "Vagrant installation skipped."
        fi

        cd "$HOME"
    else
        warn "Vagrant installation skipped."
    fi
fi

# --------------------------------------------------
# 7. Docker service
# --------------------------------------------------

section "DOCKER CONFIGURATION"

if pacman -Q docker >/dev/null 2>&1; then
    sudo systemctl enable --now docker.service
    log "Docker enabled and started."
else
    warn "Docker not installed. Skipping."
fi

# --------------------------------------------------
# 8. Libvirt service
# --------------------------------------------------

section "VIRTUALIZATION CONFIGURATION"

if pacman -Q libvirt >/dev/null 2>&1; then
    if sudo systemctl enable --now libvirtd.service; then
        log "Libvirt enabled and started."
    else
        warn "Libvirt could not start. Check systemctl status libvirtd."
    fi
else
    warn "Libvirt not installed. Skipping."
fi

# --------------------------------------------------
# 9. Python virtual environment
# --------------------------------------------------

section "PYTHON ENVIRONMENT"

PYTHON_ENV="$HOME/Development/Python/venv"

mkdir -p "$HOME/Development/Python"

if [[ ! -x "$PYTHON_ENV/bin/python" ]]; then
    python -m venv "$PYTHON_ENV"
    log "Created Python virtual environment."
else
    log "Existing Python virtual environment preserved."
fi

PYTHON="$PYTHON_ENV/bin/python"

if [[ ! -x "$PYTHON" ]]; then
    fail "Python virtual environment could not be initialized."
fi

"$PYTHON" --version

log "Installing Python and AI/ML libraries."

"$PYTHON" -m pip install \
    numpy \
    scipy \
    pandas \
    matplotlib \
    scikit-learn \
    pyrefly

log "Python packages installed."

# --------------------------------------------------
# 10. VS Code extensions
# --------------------------------------------------

section "VISUAL STUDIO CODE EXTENSIONS"

if command -v code >/dev/null 2>&1; then

    EXTENSIONS=(
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

    for extension in "${EXTENSIONS[@]}"; do
        log "Installing $extension"

        if code --install-extension "$extension"; then
            log "Installed: $extension"
        else
            warn "Could not install: $extension"
        fi
    done
else
    warn "VS Code CLI not available."
fi

# --------------------------------------------------
# 11. Development workspace
# --------------------------------------------------

section "DEVELOPMENT WORKSPACE"

DIRECTORIES=(
    Web Python AI-ML C-Cpp DevOps Docker
    Kubernetes Projects Experiments Tools
)

for dir in "${DIRECTORIES[@]}"; do
    mkdir -p "$HOME/Development/$dir"
    log "Created/verified ~/Development/$dir"
done

mkdir -p "$HOME/.local/bin"

# --------------------------------------------------
# 12. Git configuration
# --------------------------------------------------

section "GIT CONFIGURATION"

if [[ -z "$(git config --global user.name || true)" ]]; then
    read -r -p "Git display name (leave blank to skip): " git_name

    if [[ -n "$git_name" ]]; then
        git config --global user.name "$git_name"
    fi
fi

if [[ -z "$(git config --global user.email || true)" ]]; then
    read -r -p "Git email (leave blank to skip): " git_email

    if [[ -n "$git_email" ]]; then
        git config --global user.email "$git_email"
    fi
fi

git config --global init.defaultBranch main

log "Git defaults configured."

# --------------------------------------------------
# 13. Installation verification
# --------------------------------------------------

section "INSTALLATION VERIFICATION"

TOOLS=(
    git gcc g++ clang clang++ clangd
    cmake ninja gdb
    python node npm
    docker kubectl helm terraform ansible
    code psql sqlite3 redis-cli
    nginx vulkaninfo vagrant
)

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf "${GREEN}[OK]${NC} %-15s %s\n" \
            "$tool" "$(command -v "$tool")"
    else
        printf "${RED}[MISSING]${NC} %s\n" "$tool"
    fi
done

# --------------------------------------------------
# 14. Python verification
# --------------------------------------------------

section "PYTHON VERIFICATION"

"$PYTHON" -c '
import numpy
import scipy
import pandas
import matplotlib
import sklearn
import pyrefly

print("All Python and AI/ML imports successful.")
'

"$PYTHON" -m pip show pyrefly

# --------------------------------------------------
# 15. Graphics information
# --------------------------------------------------

section "INTEL GRAPHICS"

if command -v lspci >/dev/null 2>&1; then
    lspci | grep -Ei 'VGA|Display|3D' || true
fi

if command -v vulkaninfo >/dev/null 2>&1; then
    log "Vulkan available."
fi

if command -v clinfo >/dev/null 2>&1; then
    log "OpenCL diagnostic available."
fi

# --------------------------------------------------
# 16. Final summary
# --------------------------------------------------

section "INSTALLATION FINISHED"

echo
log "Developer workstation setup completed."

echo
echo "Python environment:"
echo "  source ~/Development/Python/venv/bin/activate"

echo
echo "Vagrant:"
echo "  vagrant --version"

echo
echo "Docker:"
echo "  docker info"

echo
echo "Virtualization:"
echo "  systemctl status libvirtd"
echo "  virsh list --all"

echo
echo "Final verification:"
echo "  ./verify-setup.sh"
echo
echo "Save verification log:"
echo "  ./verify-setup.sh 2>&1 | tee final-verification.log"

echo
warn "Docker group membership grants highly privileged access."
warn "This installer deliberately does not add your account to that group."
warn "Review any unavailable repository packages individually."

log "Manjaro workstation installation finished."
