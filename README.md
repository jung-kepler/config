# config

This repository manages my dotfiles using [mise](https://mise.jdx.dev).

## Prerequisites
- Install mise: `curl https://mise.run | sh` (or see [mise installation guide](https://mise.jdx.dev/getting-started.html))

## Layout
- `dotfiles/` contains packages (e.g., `alacritty`, `bash`, `git`, `tmux`, `mise`, `gh`, `zsh`). Each package mirrors the target paths under `$HOME`.
- `.backup/` stores timestamped backups of any original files.
- `mise.toml` defines tasks for managing dotfiles.

## Quick Start
1. Clone and enter the repo:
   ```bash
   git clone <repo-url>
   cd config
   ```

2. Install dotfiles (backs up existing files and creates symlinks):
   ```bash
   mise run install
   ```

## Available mise Tasks

### `mise run install`
Full installation - backs up existing files and links all dotfiles to `$HOME`.

### `mise run link`
Create symlinks for all dotfiles packages. Re-run after adding new configs.

### `mise run unlink`
Remove all symlinks created by this configuration.

### `mise run status`
Show the current status of all dotfile links (linked, missing, or conflicting).

### `mise run backup`
Backup existing dotfiles before making changes.

## How It Works

### Architecture Overview

This system uses **mise tasks** to automate dotfile management through symlinks. Unlike traditional package managers, mise is a polyglot tool manager that also supports custom task automation, making it perfect for dotfile management.

### Directory Structure

```
config/
├── mise.toml              # Task definitions and configuration
├── dotfiles/              # Source of truth for all configs
│   ├── alacritty/        # Package: Alacritty terminal configs
│   │   └── .config/
│   │       └── alacritty/
│   │           └── alacritty.toml
│   ├── bash/             # Package: Bash shell configs
│   │   ├── .bashrc
│   │   └── .profile
│   ├── git/              # Package: Git configs
│   │   ├── .gitconfig
│   │   └── .config/
│   │       └── git/
│   │           └── config
│   ├── zsh/              # Package: Zsh shell configs
│   │   └── .zshrc
│   ├── tmux/             # Package: tmux configs
│   ├── mise/             # Package: mise configs
│   └── gh/               # Package: GitHub CLI configs
└── .backup/              # Timestamped backups
    └── YYYYMMDD-HHMMSS/
```

### How Packages Work

Each directory under `dotfiles/` is a **package**. A package contains files organized to mirror your `$HOME` directory structure:

- Files in `dotfiles/git/.gitconfig` get symlinked to `~/.gitconfig`
- Files in `dotfiles/alacritty/.config/alacritty/alacritty.toml` get symlinked to `~/.config/alacritty/alacritty.toml`

This mirroring system means:
1. You edit files directly in the repo
2. Changes are immediately reflected in your home directory (via symlinks)
3. Everything is version controlled

### The Symlinking Process

When you run `mise run link`, the system:

1. **Discovers packages**: Iterates through each package directory (`alacritty`, `bash`, `git`, etc.)
2. **Finds files**: Uses `find` to locate all files within each package
3. **Creates directories**: Ensures parent directories exist in `$HOME`
4. **Creates symlinks**: Links each file from the repo to `$HOME`

Example:
```bash
# File in repo:
dotfiles/git/.gitconfig

# Gets symlinked to:
~/.gitconfig -> /home/jung/Documents/Repositories/config/dotfiles/git/.gitconfig
```

### Task Dependency Chain

The `mise run install` task demonstrates mise's task dependency system:

```toml
[tasks.install]
description = "Full install: backup existing files and link all dotfiles"
depends = ["backup", "link"]
```

When you run `mise run install`:
1. First runs `backup` task (creates timestamped backup of existing files)
2. Then runs `link` task (creates all symlinks)

### Environment Variables

The tasks use mise's built-in environment variable:
- `$MISE_PROJECT_ROOT`: Automatically set to the repo root directory
- This ensures tasks work regardless of your current working directory

### Idempotency

All tasks are **idempotent** - safe to run multiple times:

- **link**: Checks if symlink already exists and points to the correct target before creating
- **unlink**: Only removes symlinks that point to files in this repo
- **backup**: Creates new timestamped directory each time (never overwrites)
- **status**: Read-only, shows current state

### Common Workflows

#### Fresh Machine Setup
```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
mise trust                    # Trust the mise.toml config
mise run install              # Backup existing + link all
```

#### Daily Development
```bash
# Edit dotfiles directly in the repo
vim ~/dotfiles/dotfiles/git/.gitconfig

# Changes are immediately active (symlinks!)
# Commit when ready
git add dotfiles/git/.gitconfig
git commit -m "Update git config"
```

#### Adding New Package
```bash
# 1. Create package directory
mkdir -p dotfiles/myapp/.config/myapp

# 2. Add your config files
cp ~/.config/myapp/config.yml dotfiles/myapp/.config/myapp/

# 3. Link the new package
mise run link

# 4. Verify it worked
mise run status
```

#### Checking Link Status
```bash
mise run status
# Shows:
# ✓ .gitconfig (linked)
# ✗ .vimrc (exists but not linked)
# ○ .zshrc (not linked)
```

#### Recovering from Mistakes
```bash
# Unlink everything
mise run unlink

# Restore from latest backup
cp -r .backup/20260115-143000/* ~/

# Or re-link with fresh backup
mise run install
```

### Advantages Over Stow

1. **No external dependencies**: mise is already used for tool management
2. **Task automation**: Can add pre/post install scripts easily
3. **Better visibility**: `mise run status` shows exact state
4. **Easier debugging**: Scripts are in plain bash in `mise.toml`
5. **Cross-platform**: mise works on Linux, macOS, and Windows

### Troubleshooting

**Problem**: `mise: command not found`
```bash
# Install mise
curl https://mise.run | sh
# Follow post-install instructions to add to PATH
```

**Problem**: "Config files not trusted"
```bash
mise trust
```

**Problem**: Symlink conflicts
```bash
# Check what's conflicting
mise run status

# Backup and force re-link
mise run backup
rm ~/.conflicting-file
mise run link
```

**Problem**: Want to see what would happen
```bash
# Dry run (check status without changes)
mise run status

# Or manually inspect the tasks
cat mise.toml
```

## Adding New Configs
1. Place files in the appropriate package directory, mirroring `$HOME` structure:
   - For a home file: `dotfiles/git/.gitconfig` → `~/.gitconfig`
   - For a config dir: `dotfiles/tmux/.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`

2. Re-link the dotfiles:
   ```bash
   mise run link
   ```

## Migration from Stow
If migrating from the previous stow-based setup:
1. Unlink existing stow packages:
   ```bash
   cd dotfiles && stow -D alacritty bash git tmux mise gh
   ```
2. Run the mise install:
   ```bash
   mise run install
   ```