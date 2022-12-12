#!/bin/bash

# ENVIRONMENT VARIABLES
export PATH=/auto/share/bin:~/.local/bin:$PATH

# TERMINAL BEAUTIFICATION

ACCENT_COL="\[$(tput setaf 215)\]"
TEXT_COL1="\[$(tput setaf 249)\]"
RESET_COL="\[$(tput sgr0)\]"

if [ -f /etc/bashrc ]; then
      . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

if [[ "$TERM" =~ 256color ]]; then
    PS1="${TEXT_COL1}\u${RESET_COL}@${ACCENT_COL}\h${RESET_COL}:${TEXT_COL1}\w${RESET_COL}>"
fi

echo -ne "\e]12;white\a"

#  ALIASES

alias ll="ls -al"
alias cl="clear"
