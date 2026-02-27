autoload -Uz add-zsh-hook

if [ -f "$HOME/.zsh_aliases" ]; then
    source "$HOME/.zsh_aliases"
fi

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory

autoload -U colors && colors

# Setup auto-completion
autoload -Uz compinit
compinit

# Load version control information
autoload -Uz vcs_info
add-zsh-hook precmd vcs_info

# Format the vcs_info_msg_0_ variable
# branch/uncommitted/changed
zstyle ':vcs_info:git:*' formats       ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b[a% u%c])'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:git*:*' unstagedstr '*'
zstyle ':vcs_info:git*:*' stagedstr '+'

# Set up the prompt (with git branch name)
setopt prompt_subst
PROMPT='%m %F{blue}%~%f%F{red}${vcs_info_msg_0_}%f%# '

# Universal aliases

alias coinflip='if [[ $(( RANDOM % 2 )) -eq 0 ]]; then echo "heads"; else echo "tails"; fi'
alias dockerclean='docker images | rg "<none>" | awk '\''{ print $3 }'\'' | xargs docker rmi'
alias dumpcore='ulimit -c unlimited'
alias e='emacsclient -nw --alternate-editor=""'
alias holdmybeer='sudo'
alias ipy='ipython3'
alias ls='ls --color=auto'
alias ll='ls -alhF --color=auto'
alias weather='curl -sSL "https://wttr.in/Mountain+View?m"'

if [ -f "$HOME/.zshrc_bonsai" ]; then
    source "$HOME/.zshrc_bonsai"
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi

if [[ -f /etc/bash_completion.d/hgd ]]; then
  source /etc/bash_completion.d/hgd
fi


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
