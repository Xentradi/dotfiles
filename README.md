# Dotfiles

Personal macOS workstation configuration. This repository is the source of truth for the terminal, shell, prompt, Ghostty, and the Homebrew-managed development environment.

It is designed to rebuild the workstation safely on a new Mac without copying secrets or manually recreating configuration.

## What it manages

- zsh behavior, history, completions, aliases, fzf, NVM, and pyenv
- Starship prompt and Ghostty terminal configuration
- Homebrew formulae, casks, and VS Code extensions in `Brewfile`
- an optional, reviewed set of macOS UI defaults

The bootstrap script creates these live symlinks:

| Live path | Repository source |
| --- | --- |
| `~/.zshrc` | `home/.zshrc` |
| `~/.zsh_aliases` | `home/.zsh_aliases` |
| `~/.fzf.zsh` | `home/.fzf.zsh` |
| `~/.config/starship.toml` | `config/starship.toml` |
| `~/.config/ghostty/` | `config/ghostty/` |

Edit the repository files, not the symlinked paths in `$HOME`.

## Set up a new Mac

### 1. Install the prerequisites

Install Apple’s Command Line Tools, then Homebrew:

```bash
xcode-select --install
# Follow https://brew.sh, then activate Homebrew for this shell:
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. Clone the repository

HTTPS works before SSH keys are configured:

```bash
git clone https://github.com/Xentradi/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Restore applications and tools

Install the declared Homebrew formulae, casks, and VS Code extensions:

```bash
brew bundle --file=~/dotfiles/Brewfile
```

### 4. Link the configuration

```bash
~/dotfiles/bootstrap.sh
exec zsh
```

`bootstrap.sh` moves any conflicting files into `~/.dotfiles_backup/<timestamp>/` before creating symlinks. It is safe to rerun, but will create another backup of the existing symlinks each time.

### 5. Optional: apply macOS defaults

First read [`macos-defaults.sh`](macos-defaults.sh). If its choices match the new Mac, run:

```bash
~/dotfiles/macos-defaults.sh
```

It changes Finder, Dock, screenshots, key repeat, save/print panels, scrollbars, and lock-screen behavior. It does not manage trackpad tap-to-click or three-finger drag. Screenshots are stored as PNGs in `~/Pictures/Screenshots`.

### 6. Verify

```bash
command -v starship zoxide fzf nvm pyenv
readlink ~/.zshrc
readlink ~/.config/ghostty
brew bundle check --file=~/dotfiles/Brewfile
```

The first two `readlink` commands should point into `~/dotfiles`.

## Everyday use and maintenance

After changing a managed file, open a new terminal or reload the relevant program:

- zsh: `exec zsh`
- Ghostty: reload its configuration or open a new window
- Starship: open a new prompt

Before making a configuration change, update the local checkout:

```bash
cd ~/dotfiles
git pull --ff-only
```

Review and publish intentional changes:

```bash
git diff --check
git status
git add <files>
git commit -m "Describe the workstation change"
git push
```

When deliberately adding a Homebrew package, update the manifest rather than dumping the entire installed machine state:

```bash
brew bundle add <formula-or-cask> --file=~/dotfiles/Brewfile
```

Use `--cask` or `--vscode` when appropriate. Confirm the resulting diff before committing.

## Reset and recovery

For a broken local configuration, inspect the repository and restore a tracked file deliberately:

```bash
cd ~/dotfiles
git status
git restore home/.zshrc  # example: discard local edits to this one managed file
exec zsh
```

For a clean rebuild on another Mac, repeat the **Set up a new Mac** steps. The backup directory created by `bootstrap.sh` is the recovery path for files that existed before this repository took control of them.

## Secrets and machine-specific state

Never commit API keys, credentials, private SSH keys, browser profiles, databases, or `.env` files. Keep secrets in the appropriate local credential manager or environment injection mechanism; do not put them in `home/.zshrc`.

NVM’s downloaded Node versions live in `~/.nvm`; pyenv’s installed Python versions live under `~/.pyenv`. They are intentionally machine-local and are restored by installing versions as needed, not by committing those directories.

## Repository layout

```text
dotfiles/
├── home/                 # symlinked into $HOME
├── config/               # symlinked into ~/.config
├── Brewfile              # Homebrew and VS Code manifest
├── bootstrap.sh          # backups + symlink creation
└── macos-defaults.sh     # optional macOS preferences
```
