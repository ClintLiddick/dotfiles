# Clint's dotfiles repo Agents file

This public-facing repository contains the configuration files I use on every work and
personal computer, along with Ansible scripts for more complex configuration.

The repo should be easy to use for simple configurations, and self-bootstrapping as much
as is practical.

## Dotfiles

Dotfiles are stored in the repo root and symlinked from their installation
location. Configuration subdirectories may be used for applications that require it.

## Ansible configuration

The root ansible directory is in cfg/. See cfg/README.md for setup, configuration, and
testing instructions.

All hosts are contained in the cfg/hosts.yml script, and a single cfg/playbook.yml file
declares all configuration. 

ansible-playbook is always run locally against the localhost host only.

Ansible roles should support Debian Linux and Mac OSX systems as much as possible.
