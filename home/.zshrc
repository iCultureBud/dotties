# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Disable percentage sign for unterminated lines
unsetopt PROMPT_SP

# Start starship prompt
eval "$(starship init zsh)"

# Variables
export EDITOR=nvim
export BAT_THEME='Nord'
export ANDROID_HOME=/opt/android-sdk

# Greeting
tput setaf 5; echo "Talk is cheap. Show me the code."; \
	tput setaf 4; echo "      - Linus Torvalds -\n"

# Open directories with lf and cd in it
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# Keybindings
bindkey	-e
bindkey -s '^f' 'lf\n'
bindkey -s '^o' 'lfcd\n'
bindkey	"^[[3~"	delete-char
#bindkey -M viins ö vi-cmd-mode

# ZSH completion
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit lfcd
compinit

# Plugins
plugins=(git web-search zsh-autosuggestions zsh-syntax-highlighting)


###########
# Aliases #
###########

# Package Management
alias install="yay -S"
alias search="yay -Ss"
alias update="yay -Syu"
alias remove="yay -Rns"
alias look="pacman -Qs"
alias info="pacman -Qi"

# System
alias sys="sudo systemctl"
alias jo="sudo journalctl"

# Git Stuff
alias lg="lazygit"
alias gf="git fetch"
alias gc="git commit"
alias ga="git add"
alias g="git status"
alias gp="git pull"
alias gu="git push"
alias gr="cd ~/Repos;lfcd"

# Docker Stuff
#alias docku="docker-compose up -d"
#alias dockd="docker-compose down"
#alias dockv="docker volume rm $(docker volume ls -q)"
#alias dockr="dockd;docku"

# Moving and file operation
alias ..="cd .."
alias ...="cd ../.."
alias rd="rm -rf"
alias e="nvim"
alias se="sudo nvim"
alias l="lsd"
alias ls="lsd -l"
alias la="lsd -a"
alias lsa="lsd -la"
alias lt="l --tree"
alias dot="lf ~/.config"
alias zrc="e ~/.zshrc; source ~/.zshrc"
alias lg="lazygit"

# Man coloring
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'lsd --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'lsd --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

# Zoxide rocks
eval "$(zoxide init zsh)"

# Plugins
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
