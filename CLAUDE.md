# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A collection of shell scripts for automating development environment setup on macOS and Linux. Scripts handle package installation, GitHub SSH authentication, tmux session configuration, and shell alias management.

## Running Scripts

Scripts are executed directly — there is no build system, Makefile, or test framework:

```bash
# Unified package installer (auto-detects macOS vs Linux)
# No flags = ESSENTIALS only (plus ESSENTIALS_LINUX on Linux)
bash installers/install.sh
bash installers/install.sh --all
bash installers/install.sh --essentials --dev --ai
bash installers/install.sh --help

# GitHub SSH key setup
bash github/ssh_auth_setup.sh

# Dev environment tmux session
bash scripts/dev_env.sh

# Monitoring tmux session
bash tmux/tmux_setup_monitoring.sh

# Add Linux bash aliases
bash alias/add_linux_alias.sh
```

## Linting

`shellcheck` is installed as part of the dev toolset. Run it against any script before committing:

```bash
shellcheck <script.sh>
```

## Architecture

### Utility Libraries (sourced, not executed directly)

- `utils/print.sh` — Colored terminal output functions (`print_success`, `print_error`, `print_warning`, `print_info`, `print_section`, `print_banner`, `print_install_message`, `print_update_message`). This is the base dependency for most scripts.
- `utils/folders.sh` — `folder_exists()` and `folder_empty()` helpers.

### Platform Abstraction

- `installers/pkg_utils.sh` — Detects the host OS (Darwin/Linux) and exposes a unified interface used by `install.sh`: `bootstrap_pkg_manager`, `update_system`, `install_package_category`, `pre_install_ai`. Internally dispatches to brew on macOS and apt on Linux.
- `installers/install.sh` — Single entrypoint. Parses flags, sources `packages.shared.conf` plus the matching platform conf, and dispatches selected categories.

### Package Configuration

Packages are defined in `.conf` files as bash arrays and sourced by the installer scripts. Each category is small and single-purpose; platform-specific files use `*_MACOS` / `*_LINUX` arrays that *extend* the shared ones (the installers concatenate).

- `installers/packages.shared.conf` — categories: `ESSENTIALS`, `SHELL_ENHANCE`, `TERMINAL_TUIS`, `NETWORKING`, `LANGUAGES`, `LANG_TOOLING`, `DEV_CORE`, `CLOUD_CLI`, `DEVOPS`, `DATABASES`, `AI_CLI`, `FONTS`
- `installers/packages.macos.conf` — `LANG_TOOLING_MACOS` (extends `LANG_TOOLING`)
- `installers/packages.linux.conf` — `ESSENTIALS_LINUX` (extends `ESSENTIALS`)

The installer maps one CLI flag per category (`--essentials`, `--shell`, `--tuis`, `--networking`, `--languages`, `--lang-tooling`, `--dev`, `--cloud`, `--devops`, `--db`, `--ai`, `--fonts`), plus `--all`. **Default with no flags is `--essentials` only** — a deliberate change from the previous "install everything" behavior.

### Dependency Flow

```
utils/print.sh
    └── installers/pkg_utils.sh         (platform-detected brew/apt wrappers)
            └── installers/install.sh   (also sources *.conf files)
    └── github/ssh_auth_setup.sh
    └── alias/add_linux_alias.sh
```

`scripts/dev_env.sh` and `tmux/tmux_setup_monitoring.sh` are standalone — they depend only on external tools (tmux, nvim, lazygit, btop, etc.).

### tmux Sessions

- `dev_env.sh` creates session `MJBBashScripts` with windows for nvim, claude CLI, and lazygit.
- `tmux_setup_monitoring.sh` creates session `dev` with a development window (3-pane split) and a monitoring window (btop, iftop, iotop).
