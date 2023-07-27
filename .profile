 # If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

is_vdt=false && [[ -f /etc/vdt-owner ]] && is_vdt=true
my_vdt=false && $is_vdt && [[ "$(cat /etc/vdt-owner)" == "${USER}" ]] && my_vdt=true
is_buk=false && [[ $HOSTNAME == *buk* ]] && is_buk=true

if $is_vdt && $is_buk && [[ $HOME != *buk* ]]; then
    export HOME=/auto/homebuk.nas01/battagel
    source $HOME/.profile
    cd $HOME
    return
fi
