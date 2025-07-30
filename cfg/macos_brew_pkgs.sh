#!/usr/bin/env bash

set -euo pipefail

brew_pkgs=(
    bazelisk
    clang-format
    git
    pyenv
)

brew_cask_pkgs=(
    emacs-app
    kitty
    docker-desktop
)

brew install ${brew_pkgs[@]}

brew install --cask ${brew_cask_pkgs[@]}
