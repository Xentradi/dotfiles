########################################
# PATH (Apple Silicon safe)
########################################
export PATH="$HOME/Library/Python/3.9/bin:$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

########################################
# Runtime version managers
########################################
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)"
fi

########################################
# History (sane + powerful)
########################################
HISTFILE=~/.zsh_history
HISTSIZE=200000
SAVEHIST=200000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

########################################
# Quality-of-life
########################################
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS

########################################
# Completion
########################################
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

########################################
# Zinit Loader
########################################
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

########################################
# Annexes
########################################
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

########################################
# Plugins (keep it surgical)
########################################

# Autosuggestions tuning (set BEFORE loading plugin)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting (keep last among plugins)
zinit light zsh-users/zsh-syntax-highlighting

########################################
# Starship Prompt
########################################
eval "$(starship init zsh)"

########################################
# Smarter cd
########################################
eval "$(zoxide init zsh)"

########################################
# SSH host autocomplete (from known_hosts)
########################################
_h=(${(f)"$(awk '{print $1}' ~/.ssh/known_hosts 2>/dev/null | tr ',' '\n' | sed 's/\[//;s/\].*//;/^|/d' | sort -u)"})
zstyle ':completion:*:ssh:*' hosts $_h
zstyle ':completion:*:scp:*' hosts $_h
zstyle ':completion:*:sftp:*' hosts $_h

########################################
# Aliases
########################################
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

########################################
# fzf (keybindings + completion)
########################################
# Better defaults + previews (requires: fd, bat, eza; falls back if missing)
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# File preview for ctrl+t
if command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :200 {} 2>/dev/null || (sed -n \"1,200p\" {} 2>/dev/null)'"
else
  export FZF_CTRL_T_OPTS="--preview 'sed -n \"1,200p\" {} 2>/dev/null'"
fi

# Dir preview for alt+c
if command -v eza >/dev/null 2>&1; then
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons {} 2>/dev/null || ls -la {}'"
else
  export FZF_ALT_C_OPTS="--preview 'ls -la {} 2>/dev/null'"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# Make remote shells boring + compatible (fixes nano/vim/htop on servers)
# Keeps local Ghostty TERM untouched.
function ssh() {
  TERM=xterm-256color command ssh "$@"
}
