# Initialize Starship
starship init fish | source

# Variables
set -gx EDITOR nvim
set -gx MANPAGER 'nvim +Man!'
set -gx MANWIDTH 999
set -gx BAT_THEME 'gruvbox-dark'
# set -U fish_user_paths /opt/homebrew/opt/ruby/bin $fish_user_paths
# set -Ux CHROME_EXECUTABLE /Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser
# set -gx LDFLAGS '-L/opt/homebrew/opt/ruby/lib'
# set -gx CPPFLAGS '-I/opt/homebrew/opt/ruby/include'
# set -gx PKG_CONFIG_PATH '/opt/homebrew/opt/ruby/lib/pkgconfig'
# set -gx GDAL_LIBRARY_PATH '/opt/homebrew/opt/gdal/lib/libgdal.dylib'
# set -gx GEOS_LIBRARY_PATH '/opt/homebrew/opt/geos/lib/libgeos_c.dylib'


# Setting PATH for Python 3.12
set -x PATH "/Library/Frameworks/Python.framework/Versions/3.12/bin" "$PATH"

fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# LFCD
# bind \co 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
bind \cf 'set old_tty (stty -g); stty sane; yazi; stty $old_tty; commandline -f repaint'

# Greeting
set -U fish_greeting
tput setaf 5; echo "Talk is cheap. Show me the code."; \
	tput setaf 4; echo "      - Linus Torvalds -"


###########
# Aliases #
###########

# Package Management
abbr -a install yay -S
abbr -a search yay -Ss
abbr -a update yay -Sy
abbr -a upgrade yay -Syu
abbr -a remove yay -Rns
abbr -a look 'brew list | grep'
abbr -a info brew info

# System
alias sys="sudo systemctl"
alias jo="sudo journalctl"

# Moving and file operation
alias ..="cd .."
alias ...="cd ../.."
alias rd="rm -rf"
alias gr="cd ~/Repos;lfcd"
alias pc="nvim ~/.config/newm/config.py"
alias hc="nvim ~/.config/hypr/hyprland.conf"
alias nc="nvim ~/.config/nvim/init.vim"
alias e="nvim"
alias se="sudo nvim"
alias l="lsd"
alias ls="lsd -l"
alias la="lsd -a"
alias lsa="lsd -la"
alias lt="l --tree"
alias dot="lf ~/.config"
alias zrc="e ~/.zshrc; source ~/.zshrc"
alias frc="e ~/.config/fish/config.fish; source ~/.config/fish/config.fish"
alias lg="lazygit"
alias co="grepy"
alias kd="k9s"
abbr stat stat -x

alias meh='echo "🤷"'
alias wtf='echo "👀"'
alias fpm='echo "🤦"'


#################
# Abbreviations #
#################

# Git
abbr -a gau git add -u
abbr -a grm  git rm 
abbr -a gsn git switch -c
abbr -a grmca git rm --cached
abbr -a grao git remote add origin
abbr -a grf git rm -rf
abbr -a grfca git rm -rf --cached
abbr -a glne git pull --no-edit
abbr -a gpristine 'git reset --hard; and git clean -dfx'
abbr -a gg gogit
abbr -a gunpushed 'git log --branches --not --remotes --simplify-by-decoration --decorate --oneline'
abbr -a master   git switch master
abbr -a staging  git switch staging
abbr -a --set-cursor develop git switch DEV-%
abbr -a --set-cursor newdev  git switch -c DEV-%

# Python
abbr -a pi pip install 
abbr -a pir pip install -r 
abbr -a pirr pip install -r requirements.txt

# Django
abbr -a pm python manage.py
abbr -a pmm python manage.py migrate 
abbr -a pmr python manage.py runserver
abbr -a prw python worker.py
abbr -a pmmk python manage.py makemigrations
abbr -a pmmke python manage.py makemessages
abbr -a pmcme python manage.py compilemessages
abbr -a pmdd python manage.py devdata
abbr -a pmsp python manage.py shell_plus
abbr -a pms python manage.py shell
abbr -a --set-cursor pmrd python -m debugpy --listen % --wait-for-client manage.py runserver

# Docker
abbr -a d docker
abbr -a deit docker exec -it 
abbr -a di docker inspect
abbr -a dk docker kill
abbr -a dc docker-compose
abbr -a dcud docker-compose up -d
abbr -a dip "ip addr | grep docker"

# JSON
alias pj='python -c "import sys, ast, json; print json.dumps(ast.literal_eval(sys.stdin.read().strip()))" | j'
alias cj='c | jq'

# Kubernetes
alias kname='kubectl config set-context (kubectl config current-context) --namespace '
abbr -a kaf   kubectl apply -f
abbr -a k     kubectl
abbr -a kdp   kubectl delete pod
abbr -a kgp   kubectl get pods
abbr -a ktp   kubectl top pod
abbr -a ktn   kubectl top node
abbr -a kex   kubectl exec -it
abbr -a kl    kubectl logs -f
abbr -a r redis-cli
abbr -a --set-cursor kep kubectl exec % -it -- python manage.py
abbr -a --set-cursor ksp kubectl exec % -it -- python manage.py shell_plus

# SSH Shorthands
alias sdb="ssh botserver"


# Less coloring
set -x LESS_TERMCAP_mb \e'[1;32m'
set -x LESS_TERMCAP_md \e'[1;32m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_se \e'[0m'
set -x LESS_TERMCAP_so \e'[01;33m'
set -x LESS_TERMCAP_ue \e'[0m'
set -x LESS_TERMCAP_us \e'[1;4;31m'

# FZF Keymaps
fzf_configure_bindings --directory=\ct --history=\cr --process=\cp --git_log= --git_status=

# Init Zoxide
zoxide init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end
