## Setup

    $ sudo apt install libssl-dev python3-setuptools python3-wheel python3-venv
    $ pip3 install ansible
    $ ansible-galaxy collection install community.general

You may need to install rust tools first for new Python cryptography packages.

## Running

    $ ansible-playbook -i hosts.yml -l <host> -K playbook.yml

### MacOS prerequisite

- Install Homebrew:

Install pkg from [GitHub release](https://github.com/Homebrew/brew/releases) or:

        $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

- Setup PATH

        $ echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc

- Install brew packages (the community.general.homebrew ansible rules don't current work correctly for casks):

        $ ./macos_brew_pkgs.sh


### Only certain tasks

To run only a certain task, add `tags: new` (or any string) and then run the
playbook with `--tags new`, and only those tagged tasks are executed.

