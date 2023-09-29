# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#
# Bash setup
#

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=-1  # do not truncate
export HISTSIZE=-1  # save all
export HISTIMEFORMAT="[%F %T] "
export HISTFILE=~/.bash_eternal_history

#
# Terminal setup
#

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export TERM="rxvt-unicode-256color"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

case "$TERM" in
    xterm-color|rxvt-256color|rxvt-unicode-256color) TERM=xterm-256color
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Configure git prompt macros
if [ -f ~/src/git/contrib/completion/git-prompt.sh ]; then
    source ~/src/git/contrib/completion/git-prompt.sh
fi

export GIT_PS1_SHOWDIRTYSTATE=true
if [ "$color_prompt" = yes ]; then
    PROMPT_COMMAND='__git_ps1 "${VIRTUAL_ENV:+(${VIRTUAL_ENV##*/})}${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\w\[\e[0;31m\]" "\[\e[00m\]\$ "'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of common utilities
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#
# Aliases
#

# Common aliases

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias arr="autorandr"
# alias switchclip='xsel -p -o | xsel -b'
alias clip2mid='xsel -b -o | xsel -p -i'
alias clip2v='xsel -p -o | xsel -b -i'
alias coinflip='if [[ $(( RANDOM % 2 )) -eq 0 ]]; then echo "heads"; else echo "tails"; fi'
alias dig='dig +search'
alias dockerclean='docker images | rg "<none>" | awk '\''{ print $3 }'\'' | xargs docker rmi'
alias dumpcore='ulimit -c unlimited'
alias e='emacsclient -nw --alternate-editor=""'
alias filemanager='xfe'
alias generate_passphrase='rg -e "^[a-z]+$" /usr/share/dict/words | sort -R | head -25 | xargs -L 5 echo'
alias holdmybeer='sudo'
alias ipy='ipython3'
alias k='kubectl'
alias ll='ls -alhF'
alias maximum_power='lscpu -p=cpu | grep "[0-9]" | xargs -n 1 -P 0 sudo cpufreq-set -g performance -c'
alias perfit='sudo perf record --call-graph dwarf'
alias showperf='sudo perf report -g'
alias showpings='sudo tcpdump -i wlan0 icmp and icmp[icmptype]=icmp-echo'
alias toclip='xsel -b -o | xclip'
alias usecling='export PATH=/opt/cling/bin:$PATH'
alias weather='curl -sSL https://wttr.in/Mountain+View?m'

# System-specific aliases
if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

# System-specific private values
if [ -f "$HOME/.env_vars_private" ]; then
    . "$HOME/.env_vars_private"
fi

#
# Bash Completion
#

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# git bash completion
if [ -f ~/src/git/contrib/completion/git-completion.bash ]; then
    source ~/src/git/contrib/completion/git-completion.bash
fi

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

# kubectl/kubernetes bash completion
if [[ -n $(command -v kubectl) ]]; then
    source <(kubectl completion bash)
fi

# Cause AWS Go SDK and Terraform to read ~/.aws/config file
export AWS_SDK_LOAD_CONFIG=1

# AWS cli command completion

if [[ -n $(command -v aws_completer) ]]; then
    complete -C aws_completer aws
fi

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
