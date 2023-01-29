#!/usr/bin/env bash

set -euo pipefail

brew_pkgs=(
    git
)

brew_cask_pkgs=(
    emacs
)

brew install ${brew_pkgs[@]}

brew install --cask ${brew_cask_pkgs[@]}
