autoload -Uz add-zsh-hook

if [ -f "$HOME/.zsh_aliases" ]; then
    source "$HOME/.zsh_aliases"
fi

export PATH=$HOME/.local/bin:/opt/homebrew/bin:$HOME/.cargo/bin:/Users/clint/Library/Python/3.9/bin:$PATH

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
PROMPT='%F{blue}%~%f%F{red}${vcs_info_msg_0_}%f$ '