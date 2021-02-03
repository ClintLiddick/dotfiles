## Setup

    $ sudo pip3 install ansible
    $ ansible-galaxy collection install community.general

## Running

    $ ansible-playbook -i hosts.yml -l <host> -K playbook.yml

### Only certain tasks

To run only a certain task, add `tags: new` (or any string) and then run the
playbook with `--tags new`, and only those tagged tasks are executed.

