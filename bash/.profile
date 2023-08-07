 # If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

is_vdt=false && [[ -f /etc/vdt-owner ]] && is_vdt=true
my_vdt=false && $is_vdt && [[ "$(cat /etc/vdt-owner)" == "${USER}" ]] && my_vdt=true
is_buk=false && [[ $HOSTNAME == *buk* ]] && is_buk=true

if $is_vdt && $is_buk && [[ $HOME != *buk* ]]; then
    export HOME=/auto/homebuk.nas01/battagel
    source $HOME/.profile
    cd $HOME || exit
    return
fi

# ENVIRONMENT VARIABLES
export PATH=/auto/share/bin:~/.local/bin:$PATH
export SHELL="/bin/zsh"
export HFSIM_SIMULATION_PATH=/auto/workspace/$USER/hfsim


# TERMINAL BEAUTIFICATION - Mostly not used if using zsh

ACCENT_COL="\[$(tput setaf 110)\]"
TEXT_COL1="\[$(tput setaf 249)\]"
RESET_COL="\[$(tput sgr0)\]"

if [[ "$TERM" =~ 256color ]]; then
    PS1="${TEXT_COL1}\u${RESET_COL}@${ACCENT_COL}\h${RESET_COL}:${TEXT_COL1}\w${RESET_COL}>"
fi

echo -ne "\e]12;white\a"

#  ALIASES
#  Oh My Zsh has lots of aliases. To view use "alias"

alias ls="ls --color=tty"
alias la="ls -al "
alias ll="ls -l"
alias cl="clear"

# Work
alias proxy="export {http, https, ftp}_proxy='http://web-proxy.corp.hpecorp.net:8080'"
alias unproxy="unset {http, https, ftp}_proxy"
alias ws="cd /data/workspaces/battagel"
alias cdws="cd /export/ws/ws0/battagel"
alias bsrv="ssh battagel@cxo-buildsrv03-vm.cxo.storage.hpecorp.net"

# Finally launch into zsh
zsh --login
