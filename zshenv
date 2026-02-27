# ~/.zshenv is sourced by all shell types: interactive, login, etc. so it's the right
# place to configure global environmental variables.
#
# Changes here won't be picked up by the graphical login without a fresh login.

# Add user ansible install path to PATH
PATH=$HOME/Library/Python/3.12/bin:$HOME/Library/Python/3.9/bin:$PATH
# Add common binary tool locations to PATH
export PATH=$HOME/.local/bin:/opt/homebrew/bin:$HOME/.cargo/bin:/opt/aurora/bin:$PATH

export EDITOR='emacsclient -nw --alternate-editor=""'

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# System-specific private values
if [ -f "$HOME/.env_vars_private" ]; then
    source "$HOME/.env_vars_private"
fi
