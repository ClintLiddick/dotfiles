autoload -Uz add-zsh-hook

if [ -f "$HOME/.zsh_aliases" ]; then
    source "$HOME/.zsh_aliases"
fi

# System-specific private values
if [ -f "$HOME/.env_vars_private" ]; then
    source "$HOME/.env_vars_private"
fi

export PATH=$HOME/.local/bin:/opt/homebrew/bin:$HOME/.cargo/bin:/Users/clint/Library/Python/3.9/bin:/opt/aurora/bin:$PATH

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory

export EDITOR='emacsclient -nw --alternate-editor=""'

autoload -U colors && colors

# Setup auto-completion
autoload -Uz compinit
compinit

# Load version control information
autoload -Uz vcs_info
add-zsh-hook precmd vcs_info

# Format the vcs_info_msg_0_ variable
# branch/uncommitted/changed
zstyle ':vcs_info:git:*' formats       ' (%b[%u%c])'
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
