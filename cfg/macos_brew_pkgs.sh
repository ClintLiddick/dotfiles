#!/usr/bin/env bash

set -euo pipefail

brew_pkgs=(
    git
    bazelisk
    clang-format
)

brew_cask_pkgs=(
    emacs-app
    kitty
    docker-desktop
)

brew install ${brew_pkgs[@]}

brew install --cask ${brew_cask_pkgs[@]}
