Manjaro Dev Setup

A complete developer workstation setup and verification toolkit for Manjaro Linux.

Automate the installation and configuration of a development environment for Web Development, Python, AI/ML, C/C++, DevOps, databases, networking, graphics, and virtualization.

![Platform](https://img.shields.io/badge/Platform-Manjaro%20Linux-blue) ![Shell](https://img.shields.io/badge/Shell-Bash-green) ![Architecture](https://img.shields.io/badge/Architecture-x86__64-orange) ![Status](https://img.shields.io/badge/Status-Active-brightgreen)

Overview

Manjaro Dev Setup is a collection of Bash scripts designed to prepare a complete developer workstation on Manjaro Linux.

Instead of manually installing development tools one by one, you can use the installation script to install a broad set of development packages, configure selected services, create a development workspace, and prepare a Python virtual environment.

A separate verification script checks whether the expected packages, commands, libraries, extensions, and services are available.

The project is designed to be reusable, interactive, and relatively safe to run repeatedly.

Features
1. Essential development utilities
Git and Git LFS
GitHub CLI
cURL and Wget
jq and yq
htop and btop
Fastfetch
Ripgrep and fd
fzf and bat
tmux
ShellCheck and shfmt
Pre-commit
2. Code editors
Visual Studio Code
Neovim
Vim
3. C and C++ development
GCC and G++
Clang and LLVM
LLDB and GDB
CMake
Ninja
Make
pkg-config
ccache
4. Python and AI/ML development
Python
pip
virtualenv
NumPy
SciPy
Pandas
Matplotlib
Scikit-learn
JupyterLab
Pyrefly

Python AI/ML libraries are installed inside a dedicated virtual environment:

~/Development/Python/venv

5. JavaScript and Web development
Node.js
npm
pnpm
Nginx
PHP
PHP-FPM
Composer
6. Database development
PostgreSQL
MariaDB
SQLite
Redis

The installer installs database packages but does not initialize database instances.

7. DevOps and infrastructure
Docker
Docker Compose
Kubernetes CLI (kubectl)
Helm
Terraform
Ansible
Packer
Vagrant (optional AUR installation)
8. Networking tools
HTTPie
Nmap
Wireshark
tcpdump
BIND utilities
traceroute
net-tools
9. Intel graphics and GPU utilities
Mesa
Intel Media Driver
Vulkan Intel
Vulkan tools
OpenCL utilities
libva-utils
clinfo

The installer does not replace existing graphics drivers.

10. Virtualization
QEMU
virt-manager
libvirt
11. VS Code extensions

The installer attempts to install extensions for:

Python
Pyrefly
C/C++
CMake
JavaScript and ESLint
Prettier
Docker
Kubernetes
Terraform
Ansible
GitLens
Error Lens
TOML
12. Development workspace

The installer creates the following directories:

text
~/Development/
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

Requirements

Before running the installer, make sure you have:

Manjaro Linux
A working internet connection
A normal user account with sudo privileges
Bash
Pacman
Sufficient disk space
An interactive terminal

Primary target architecture: x86_64.

Installation
Step 1. Clone the repository
bash
git clone YOUR_GITHUB_REPOSITORY_URL


Replace the placeholder with your actual GitHub repository URL.

Step 2. Enter the project directory
bash
cd dev-setup

Step 3. Make scripts executable
bash
chmod +x setup-dev.sh verify-setup.sh

Step 4. Run the installer
bash
./setup-dev.sh


The installer will:

Check the Linux distribution and execution environment.
Verify network connectivity.
Request sudo authentication.
Check repository package availability.
Update the Manjaro system.
Install available development packages.
Offer optional Vagrant installation from the AUR.
Enable and start Docker and libvirt when installed.
Create or preserve the Python virtual environment.
Install Python and AI/ML libraries.
Attempt to install VS Code extensions.
Create development workspace directories.
Configure Git defaults without replacing existing credentials.
Perform installation checks.

Important: Review the package transaction presented by Pacman before confirming it.

Verify the installation

After the installation finishes, run:

bash
./verify-setup.sh


The verification script checks:

Pacman packages
Executable commands
Python interpreter and libraries
Pyrefly
VS Code extensions
Docker and libvirt services
Docker daemon access and container execution
Development directories
Git configuration
Graphics utilities

To save the verification output:

bash
./verify-setup.sh 2>&1 | tee final-verification.log


The script prints a final summary containing:

Passed checks
Missing checks
Warnings
Total checks

A nonzero exit status indicates that one or more checks failed.

Python environment

Activate the dedicated Python virtual environment:

bash
source ~/Development/Python/venv/bin/activate


Check the Python version:

bash
python --version


Check installed libraries:

bash
python -m pip list


Deactivate the environment:

bash
deactivate

Docker

Check Docker:

bash
docker info


Check the service:

bash
systemctl status docker


The installer enables and starts Docker but deliberately does not add your user to the Docker group.

Security note: Membership in the Docker group grants highly privileged access to the host system. Understand the security implications before changing Docker permissions.

Virtualization

Check libvirt:

bash
systemctl status libvirtd


List virtual machines:

bash
virsh list --all

Git and GitHub

Check Git:

bash
git --version


Check GitHub CLI:

bash
gh auth status


The installer does not automatically replace existing Git credentials or authentication settings.

Safety and design principles

This project follows several installation principles:

Uses configured Manjaro repositories for normal package installation.
Does not run the installer as root.
Requests interactive confirmation before proceeding.
Preserves an existing Python virtual environment.
Does not automatically replace graphics drivers.
Does not initialize database instances.
Does not automatically modify Git credentials.
Does not automatically add users to the Docker group.
Requests confirmation before building the optional AUR package.
Important security considerations
Review scripts before executing them.
Review Pacman package transactions.
Review AUR build files before installation.
Use sudo only when necessary.
Never commit API keys, passwords, private SSH keys, or access tokens.
Back up important data before a major system upgrade.
Troubleshooting
Permission denied

Run:

bash
chmod +x setup-dev.sh verify-setup.sh

Pacman package not found

Update package databases and inspect package availability:

bash
sudo pacman -Syu
pacman -Si PACKAGE_NAME


Some packages may not be available in your configured repositories.

Docker permission denied

Check the service:

bash
sudo systemctl status docker


Remember that this installer deliberately does not modify Docker group membership.

Python module missing

Activate the virtual environment:

bash
source ~/Development/Python/venv/bin/activate


Then install the missing module:

bash
python -m pip install PACKAGE_NAME

Libvirt not running

Check:

bash
sudo systemctl status libvirtd

VS Code extension missing

Install an extension manually:

bash
code --install-extension EXTENSION_ID

Project structure
text
dev-setup/
├── README.md
├── setup-dev.sh
├── verify-setup.sh
├── .gitignore
└── LICENSE

Contributing

Contributions, bug reports, and suggestions are welcome!

To contribute:

Fork the repository.
Clone your fork.
Create a new feature branch.
Make your changes.
Test the scripts on Manjaro Linux.
Run ShellCheck where available.
Submit a pull request.

Example:

bash
git checkout -b feature/new-development-tools


Run static analysis:

bash
shellcheck setup-dev.sh verify-setup.sh

Roadmap

Potential future improvements:

Modular installation options
Interactive package selection
AMD and NVIDIA graphics profiles
AI coding CLI installation options
Automated ShellCheck GitHub Actions
Improved logging and error recovery
Support for additional Arch-based distributions
Desktop development environment profiles
Automated backup and restore options
License

No license has been added yet. A license should be selected and committed before others are granted explicit open-source reuse permissions.

Acknowledgements

Built for developers who want a consistent, reproducible, and convenient Manjaro Linux development environment.

If this project helps you, consider starring the repository and contributing improvements.

Happy coding!