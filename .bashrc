# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Git
alias config='/usr/bin/git --git-dir=$HOME/.dot/ --work-tree=$HOME'

# Node
export PATH=$HOME/.local/bin:$PATH

