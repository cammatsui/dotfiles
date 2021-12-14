#!/bin/bash

# Set terminal variable.
export TERM=xterm-kitty;

# Colors.
export CLICOLOR=1;

# Custom PS1 prompt.
export PS1="[\[$(tput sgr0)\]\[\033[38;5;197m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;14m\]\h\[$(tput sgr0)\]: \[$(tput sgr0)\]\[\033[38;5;112m\]\w\[$(tput sgr0)\]]\\$\[$(tput sgr0)\] "

# Suppress zsh warning on mac.
export BASH_SILENCE_DEPRECATION_WARNING=1;

# PATH updates.
export PATH=$PATH:/usr/local/mysql/bin;
export PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"

# Aliases
alias ls='exa --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -lh --color=always --group-directories-first'
alias vim='nvim'
alias ..='cd ..'
alias rm='rm -i'
alias mv='mv -i'
alias bluetoothon="bluetoothctl power on"
alias connectairpods='bluetoothctl connect E4:76:84:6F:B5:D4'
alias gitcfg="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# Set caps lock to escape
setxkbmap -option "caps:swapescape"
