#!/bin/bash 
git config --global user.name "Clint Liddick"
git config --global user.email "clint.liddick@gmail.com"
# add `git lol` pretty log command
git config --global --add alias.lol "log --graph --abbrev-commit --all --decorate --pretty=format:'%C(auto)%h %d %s - [%aN]'"
# set vim fugitive as merge tool
# git config --global mergetool.fugitive.cmd 'vim -f -c "Gvdiff" "$MERGED"'
# git config --global merge.tool fugitive
# git config --global push.default simple # until git 2 this becomes default
