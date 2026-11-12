# 🚀 Manjaro Dev Setup

<p align="center">
  <strong>A Complete Developer Workstation Setup & Verification Toolkit for Manjaro Linux</strong>
</p>

<p align="center">
  Automate your development environment. Configure essential tools. Verify everything. Start building.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Manjaro%20Linux-blue?logo=manjaro&logoColor=white" alt="Platform">
  <img src="https://img.shields.io/badge/Shell-Bash-green?logo=gnubash&logoColor=white" alt="Shell">
  <img src="https://img.shields.io/badge/Architecture-x86__64-orange" alt="Architecture">
  <img src="https://img.shields.io/badge/Status-Active-brightgreen" alt="Status">
  <img src="https://img.shields.io/badge/Package%20Manager-Pacman-blue" alt="Pacman">
</p>

<p align="center">
  <a href="#-overview">Overview</a> •
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-verification">Verification</a> •
  <a href="#-security">Security</a> •
  <a href="#-roadmap">Roadmap</a>
</p>

---

## 📌 Overview

**Manjaro Dev Setup** is an automated developer workstation provisioning and verification toolkit built specifically for Manjaro Linux.

Setting up a development environment manually can be repetitive, time-consuming, and inconsistent. This project simplifies that process by providing Bash-based automation scripts that install essential development tools, configure selected services, prepare programming environments, and verify the resulting system configuration.

Whether you are a Web Developer, Python Developer, AI/ML Engineer, C/C++ Programmer, DevOps Engineer, or Cybersecurity Enthusiast, this toolkit provides a unified starting point for your development workstation.

### 🎯 Project Objectives

- Automate installation of commonly used development tools.
- Prepare programming environments for multiple technologies.
- Configure selected system services.
- Create a standardized development workspace.
- Set up an isolated Python environment for AI/ML development.
- Verify installed packages, commands, libraries, and services.
- Maintain safe, repeatable, and user-controlled installation workflows.

## ✨ Features

### 1. Essential Development Utilities

A collection of command-line utilities for everyday development and system administration.

| Tool | Purpose |
|---|---|
| Git & Git LFS | Version control and large file management |
| GitHub CLI | GitHub operations from the terminal |
| cURL & Wget | HTTP requests and file downloads |
| jq & yq | JSON and YAML processing |
| htop & btop | System resource monitoring |
| Fastfetch | System information |
| Ripgrep & fd | Fast searching and file discovery |
| fzf & bat | Fuzzy finding and improved file viewing |
| tmux | Terminal session management |
| ShellCheck & shfmt | Shell script analysis and formatting |
| Pre-commit | Automated code quality checks |

### 2. Code Editors

- Visual Studio Code
- Neovim
- Vim

### 3. C/C++ Development

Prepare a complete C and C++ development toolchain.

- GCC and G++
- Clang and LLVM
- LLDB and GDB
- CMake
- Ninja
- Make
- pkg-config
- ccache

### 4. Python & AI/ML Development

Prepare a dedicated Python development environment for data science, machine learning, and experimentation.

**Core tools:**
- Python
- pip
- virtualenv
- Pyrefly

**AI/ML and Data Science libraries:**

- NumPy
- SciPy
- Pandas
- Matplotlib
- Scikit-learn
- JupyterLab

Python packages are installed inside an isolated virtual environment:

`~/Development/Python/venv`

This keeps project dependencies separate from system-managed Python packages.

### 5. JavaScript & Web Development

- Node.js
- npm
- pnpm
- Nginx
- PHP
- PHP-FPM
- Composer

### 6. Database Development

Prepare the tools and packages required for database development.

| Database | Purpose |
|---|---|
| PostgreSQL | Relational database |
| MariaDB | Relational database |
| SQLite | Lightweight embedded database |
| Redis | In-memory data store |

**Note:** Database packages are installed, but database instances are not automatically initialized.

### 7. DevOps & Infrastructure

Tools for containerization, infrastructure automation, and cloud-native development.

- Docker
- Docker Compose
- Kubernetes CLI (kubectl)
- Helm
- Terraform
- Ansible
- Packer
- Vagrant (optional AUR installation)

### 8. Networking & Security Tools

Essential utilities for networking, diagnostics, and security testing.

- HTTPie
- Nmap
- Wireshark
- tcpdump
- BIND utilities
- traceroute
- net-tools

### 9. Intel Graphics & GPU Utilities

Installs selected graphics and hardware acceleration utilities without replacing existing graphics drivers.

- Mesa
- Intel Media Driver
- Vulkan
- Intel Vulkan tools
- OpenCL utilities
- libva-utils
- clinfo

### 10. Virtualization

Prepare a virtualization environment using:

- QEMU
- virt-manager
- libvirt

### 11. VS Code Extensions

The installer attempts to install extensions for:

| Category | Extensions |
|---|---|
| Python | Python, Pyrefly |
| C/C++ | C/C++ |
| Build Systems | CMake Tools |
| JavaScript | ESLint, Prettier |
| Containers | Docker |
| Cloud Native | Kubernetes |
| Infrastructure | Terraform, Ansible |
| Productivity | GitLens, Error Lens |
| Configuration | TOML |

Extension installation depends on VS Code availability and extension marketplace connectivity.

### 12. Automated Development Workspace

The installer creates a standardized directory structure under `~/Development/`.

```text
~/Development/
│
├── Web/
├── Python/
├── AI-ML/
├── C-Cpp/
├── DevOps/
├── Docker/
├── Kubernetes/
├── Projects/
├── Experiments/
└── Tools/
```

Existing directories are preserved.

---

## 🛠️ Requirements

Before running the toolkit, ensure your system meets the following requirements.

| Requirement | Description |
|---|---|
| Operating System | Manjaro Linux |
| Architecture | x86_64 |
| Shell | Bash |
| Package Manager | Pacman |
| Internet | Working internet connection |
| Permissions | Normal user with sudo privileges |
| Terminal | Interactive terminal |
| Storage | Sufficient available disk space |

---

## 📥 Installation

### Step 1 — Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Replace `YOUR_GITHUB_REPOSITORY_URL` with your actual repository URL.

### Step 2 — Enter the Project Directory

```bash
cd dev-setup
```

### Step 3 — Make Scripts Executable

```bash
chmod +x setup-dev.sh verify-setup.sh
```

### Step 4 — Run the Installer

```bash
./setup-dev.sh
```

### What Happens During Installation?

The installation script performs the following operations:

1. Checks the Linux distribution and execution environment.
2. Verifies network connectivity.
3. Requests sudo authentication.
4. Checks package availability in configured repositories.
5. Updates the Manjaro system.
6. Installs available development packages.
7. Offers optional Vagrant installation from the AUR.
8. Enables and starts Docker and libvirt when installed.
9. Creates or preserves the Python virtual environment.
10. Installs Python and AI/ML libraries.
11. Attempts to install VS Code extensions.
12. Creates the development workspace.
13. Configures Git defaults without replacing existing credentials.
14. Performs post-installation checks.

> ⚠️ **Important:** Review the Pacman transaction carefully before confirming package installation. Do not approve unfamiliar or unexpected package changes.

---

## 🔍 Verification

After installation, run the verification script:

```bash
./verify-setup.sh
```

The verification toolkit checks the availability and configuration of the development environment.

### Verification Categories

| Category | Verification |
|---|---|
| Pacman | Installed packages |
| CLI Tools | Executable commands |
| Python | Interpreter and libraries |
| Pyrefly | Python tooling |
| VS Code | Installed extensions |
| Docker | Service, daemon access, and container execution |
| Libvirt | Virtualization services |
| Development Workspace | Expected directories |
| Git | Configuration |
| Graphics | Graphics and GPU utilities |

### Save Verification Results

To save the complete verification report:

```bash
./verify-setup.sh 2>&1 | tee final-verification.log
```

### Verification Summary

The script reports:

- Total checks
- Passed checks
- Missing checks
- Warnings

A nonzero exit status indicates that one or more checks failed.

---

## 🐍 Python Environment

The toolkit maintains a dedicated Python virtual environment.

### Activate

```bash
source ~/Development/Python/venv/bin/activate
```

### Check Python Version

```bash
python --version
```

### List Installed Packages

```bash
python -m pip list
```

### Install Additional Packages

```bash
python -m pip install PACKAGE_NAME
```

### Deactivate

```bash
deactivate
```

**Why use a virtual environment?**

- Avoids modifying system-managed Python packages.
- Keeps dependencies isolated.
- Reduces package conflicts.
- Provides a cleaner AI/ML development environment.

---

## 🐳 Docker Configuration

The installer enables and starts the Docker service when Docker is installed.

### Check Docker Version

```bash
docker --version
```

### Check Docker Information

```bash
docker info
```

### Check Docker Service

```bash
sudo systemctl status docker
```

### Security Consideration

The installer deliberately does not add your user to the Docker group.

Membership in the Docker group effectively grants highly privileged access to the host system.

Understand the security implications before changing Docker permissions.

---

## 🖥️ Virtualization Configuration

The toolkit installs QEMU, virt-manager, and libvirt.

### Check libvirt Service

```bash
sudo systemctl status libvirtd
```

### List Virtual Machines

```bash
virsh list --all
```

Virtual machine creation and configuration are left to the user.

---

## 🔧 Git & GitHub Configuration

The installer prepares Git and GitHub CLI without automatically replacing existing authentication settings.

### Check Git

```bash
git --version
```

### Check GitHub CLI

```bash
gh --version
```

### Check GitHub Authentication

```bash
gh auth status
```

Existing Git credentials and authentication configurations are preserved.

---

## 🔐 Security & Safety Principles

System configuration and developer workstation automation require careful handling.

Manjaro Dev Setup follows these principles:

| Principle | Implementation |
|---|---|
| No root execution | Installer runs as a normal user |
| Controlled privileges | Requests sudo only when required |
| Package transparency | Allows review of Pacman transactions |
| Repository-first installation | Uses configured Manjaro repositories |
| Existing environment protection | Preserves existing Python virtual environments |
| Driver safety | Does not replace graphics drivers |
| Database safety | Does not initialize database instances |
| Git safety | Does not automatically replace credentials |
| Docker safety | Does not automatically modify Docker group membership |
| AUR transparency | Requests confirmation before optional AUR builds |

### Important Security Recommendations

- Review scripts before executing them.
- Review package transactions before accepting them.
- Inspect AUR build files before installation.
- Use sudo only when necessary.
- Never commit API keys, passwords, SSH private keys, or access tokens.
- Back up important files before major system upgrades.
- Avoid executing unfamiliar installation scripts without inspecting their contents.

---

## 🧰 Troubleshooting

### Permission Denied

Make the scripts executable:

```bash
chmod +x setup-dev.sh verify-setup.sh
```

### Package Not Found

Refresh package databases and inspect package availability:

```bash
sudo pacman -Syu
pacman -Si PACKAGE_NAME
```

Some packages may not be available in your configured repositories.

### Docker Permission Denied

Check whether the Docker service is running:

```bash
sudo systemctl status docker
```

Remember that the installer deliberately avoids automatic Docker group membership changes.

### Python Module Missing

Activate the virtual environment:

```bash
source ~/Development/Python/venv/bin/activate
```

Install the missing package:

```bash
python -m pip install PACKAGE_NAME
```

### Libvirt Not Running

Check the service:

```bash
sudo systemctl status libvirtd
```

### VS Code Extension Missing

Install the extension manually:

```bash
code --install-extension EXTENSION_ID
```

Replace `EXTENSION_ID` with the required extension identifier.

---

## 📂 Project Structure

```text
dev-setup/
│
├── README.md
├── setup-dev.sh
├── verify-setup.sh
├── .gitignore
└── LICENSE
```

### Main Components

| File | Responsibility |
|---|---|
| `setup-dev.sh` | Installs and configures the development environment |
| `verify-setup.sh` | Checks installation and configuration |
| `.gitignore` | Excludes unnecessary and sensitive files |
| `LICENSE` | Defines project usage and distribution permissions |

---

## 🗺️ Roadmap

The following improvements are potential future development directions.

- [ ] Modular installation architecture
- [ ] Interactive package selection
- [ ] AMD graphics profile
- [ ] NVIDIA graphics profile
- [ ] AI coding CLI installation options
- [ ] Automated ShellCheck testing
- [ ] GitHub Actions integration
- [ ] Improved installation logging
- [ ] Better error recovery
- [ ] Support for additional Arch-based distributions
- [ ] Desktop development environment profiles
- [ ] Automated backup and restore functionality

---

## 🤝 Contributing

Contributions, bug reports, feature requests, and suggestions are welcome.

If you want to improve the project, follow these steps:

### 1. Fork the Repository

Create your own fork of this repository.

### 2. Clone Your Fork

```bash
git clone YOUR_FORK_URL
cd dev-setup
```

### 3. Create a Feature Branch

```bash
git checkout -b feature/new-development-tools
```

### 4. Make Your Changes

Implement your feature or fix while preserving existing functionality.

### 5. Test Your Changes

Run the installer and verification script on a Manjaro Linux system.

### 6. Run ShellCheck

```bash
shellcheck setup-dev.sh verify-setup.sh
```

### 7. Submit a Pull Request

Push your changes and open a pull request describing your implementation.

---

## 📜 License

No license has been added yet.

Until a license is selected and committed, others do not automatically receive explicit open-source reuse permissions.

Consider adding an appropriate open-source license before inviting external contributions.

---

## 🙌 Acknowledgements

Built for developers who want a cleaner, more consistent, and reproducible development workstation on Manjaro Linux.

The goal is simple:

**Spend less time configuring your machine and more time building software.**

If this project helps you, consider giving the repository a ⭐ and contributing improvements.

<p align="center">
  <strong>Made with ❤️ for the Developer Community</strong>
</p>

<p align="center">
  <sub>Manjaro Dev Setup — Configure. Develop. Verify.</sub>
</p>
