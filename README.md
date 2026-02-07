# Dotfiles

Personal workstation configuration for macOS.

This repo exists for one reason:

👉 rebuild my terminal + shell environment in minutes on a new machine.

No snowflake laptops. No manual tweaking.

---

# Philosophy

Keep it:

- reproducible
- minimal
- fast
- versioned
- portable

If a setup step cannot be recreated from this repo, it doesn’t belong.

---

# What's Managed

### Shell
- zsh
- aliases
- history behavior
- completion
- autosuggestions
- syntax highlighting

### Prompt
- starship (Catppuccin themed)

### Terminal
- Ghostty config

### CLI Tooling
Installed via Brewfile (fzf, eza, bat, zoxide, tmux, etc.)

---

# New Machine Setup (5–10 minutes)

## 1. Install Homebrew

Follow the official instructions:

https://brew.sh

---

## 2. Clone Dotfiles

```bash
git clone <YOUR_REPO_URL> ~/dotfiles
```

---

## 3. Run Bootstrap

```bash
cd ~/dotfiles
./bootstrap.sh
exec zsh
```

This will:

✅ create symlinks  
✅ back up conflicting files  
✅ configure `~/.config`  

Backups are stored in:

```
~/.dotfiles_backup/
```

---

## 4. Install Packages

```bash
brew bundle --file=~/dotfiles/Brewfile
```

This restores the full CLI toolchain.

---

# Updating the Brewfile

After installing new core tools:

```bash
brew bundle dump --file=~/dotfiles/Brewfile --force
```

Commit the change.

---

# Repo Structure

```
dotfiles/
├── home/        # Files that belong in ~
├── config/      # ~/.config apps
├── Brewfile
├── bootstrap.sh
```

Example:

```
home/.zshrc        -> ~/.zshrc
config/ghostty     -> ~/.config/ghostty
```

---

# Secrets

Never commit:

- `.ssh` private keys
- API tokens
- `.env` files
- credentials

Use local overrides if needed.

---

# Customization

Machine-specific tweaks should NOT be committed.

Use:

```
*.local
```

files when necessary.

---

# Philosophy on Tools

Prefer:

- fast
- native
- minimal dependencies

Avoid heavy frameworks unless they provide clear operational value.

---

# Maintenance Rule

Whenever the environment changes in a meaningful way:

👉 update the repo immediately.

Future-you is the primary consumer of this project.

---

# Disaster Recovery

If a machine dies:

1. Install Homebrew  
2. Clone repo  
3. Run bootstrap  
4. `brew bundle`  

Done.

---

# Future Improvements

- Optional macOS defaults script
- SSH config templating
- Git config
- tmux theming
- per-machine overrides

---

Built to eliminate setup friction.

