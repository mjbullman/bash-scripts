<div align="center">

# BashScripts

[![License][license-badge]][license-url]
[![Last Commit][last-commit-badge]][last-commit-url]
[![Repo Size][repo-size-badge]][repo-size-url]
[![Platform][platform-badge]][platform-url]

### A collection of shell scripts for automating macOS and Linux development environment setup.

</div>

---

<details>
<summary>Table of Contents</summary>

- [About The Project](#about-the-project)
- [Features](#features)
- [Scripts](#scripts)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

</details>

---

## About The Project

BashScripts automates the setup and maintenance of development environments across macOS and Linux. Rather than running through lengthy manual setup each time you configure a new machine, these scripts handle the repetitive work: package installs, SSH key generation, tmux session layouts, and shell alias configuration — all from a single `git clone`.

**Built With**

`Bash` · `Zsh` · `Homebrew` · `tmux`

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

## Features

- **One-command installs** — Homebrew packages on macOS, apt packages on Linux
- **Shared + platform-specific config** — `.conf` files let you manage a common package list alongside OS-specific ones
- **GitHub SSH setup** — generates an ed25519 key, adds it to `~/.ssh/`, and tests the connection
- **Dev session launcher** — opens a tmux session with Neovim, Claude, and Lazygit panes ready to go
- **Monitoring session** — opens a tmux session with btop, iftop, and iotop
- **Coloured output utilities** — reusable `print.sh` helpers for consistent terminal feedback

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

## Scripts

| Directory | Script | Description |
|-----------|--------|-------------|
| `installers/` | `install.sh` | Unified installer: detects platform, installs Homebrew/apt packages from `.conf` files |
| `github/` | `ssh_auth_setup.sh` | Generates an ed25519 SSH key and tests GitHub connection |
| `alias/` | `add_linux_alias.sh` | Adds common bash aliases to `~/.bash_aliases` |
| `scripts/` | `dev_env.sh` | Launches a tmux dev session (nvim, claude, lazygit) |
| `tmux/` | `tmux_setup_monitoring.sh` | Launches a tmux monitoring session (btop, iftop, iotop) |
| `utils/` | `print.sh` | Coloured terminal output helpers |
| `utils/` | `folders.sh` | Folder existence and empty-check helpers |

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

## Project Structure

```
BashScripts/
├── alias/
├── github/
├── installers/
│   ├── install.sh
│   ├── pkg_utils.sh
│   ├── packages.shared.conf
│   ├── packages.macos.conf
│   └── packages.linux.conf
├── scripts/
├── tmux/
└── utils/
```

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

## Getting Started

### Prerequisites

- macOS or Linux
- Git

### Installation

```bash
git clone git@github.com:martinbullman/BashScripts.git
cd BashScripts
```

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

## Usage

### Install Packages (macOS or Linux)

```bash
bash installers/install.sh                     # essentials only
bash installers/install.sh --all
bash installers/install.sh --essentials --dev --ai
bash installers/install.sh --help
```

Detects the platform automatically. On macOS it installs Homebrew if missing,
then installs the selected categories. On Linux it uses apt and bootstraps
the AI CLI installers when `--ai` is passed.

### GitHub — SSH Key Setup

```bash
bash github/ssh_auth_setup.sh
```

Generates an ed25519 key, adds it to `~/.ssh/`, and tests the GitHub connection.

### Dev Environment (tmux)

```bash
bash scripts/dev_env.sh
```

Opens a tmux session with panes for Neovim, Claude, and Lazygit.

### System Monitoring (tmux)

```bash
bash tmux/tmux_setup_monitoring.sh
```

Opens a tmux session with panes for btop, iftop, and iotop.

### Add Linux Aliases

```bash
bash alias/add_linux_alias.sh
```

Appends common bash aliases to `~/.bash_aliases` and reloads the shell.

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

## Configuration

Package lists are managed via `.conf` files in the `installers/` directory:

| File | Description |
|------|-------------|
| `installers/packages.shared.conf` | Packages installed on both macOS and Linux |
| `installers/packages.macos.conf` | macOS-only packages (installed via Homebrew) |
| `installers/packages.linux.conf` | Linux-only packages (installed via apt) |

Add or remove package names from these files before running the installer scripts.

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Make your changes, following the existing script style.
4. Open a pull request with a clear description of the change.

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

## License

Distributed under the MIT License. See [LICENSE][license-url] for details.

<div align="right"><a href="#bashscripts">↑ back to top</a></div>

---

[license-badge]: https://img.shields.io/github/license/martinbullman/BashScripts?style=for-the-badge
[license-url]: LICENSE
[last-commit-badge]: https://img.shields.io/github/last-commit/martinbullman/BashScripts?style=for-the-badge
[last-commit-url]: https://github.com/martinbullman/BashScripts/commits/main
[repo-size-badge]: https://img.shields.io/github/repo-size/martinbullman/BashScripts?style=for-the-badge
[repo-size-url]: https://github.com/martinbullman/BashScripts
[platform-badge]: https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey?style=for-the-badge
[platform-url]: https://github.com/martinbullman/BashScripts
