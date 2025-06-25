#!/bin/bash

#__________________________________________________________________________
#
#       Nom     : profile_perso.sh
#       But     : Fichier de profile a ajouter parout 
#                  --> echo ". $(pwd)/profile_perso.sh" >> ~/.bashrc
#       Auteur  : erwanlr56@gmail.com
#       Date    : 06/02/2025 - V1 Init
#_______________________________________________________
#
clear; unset TMOUT; 
[ "$(whoami)" = "root" ] && c=1 || c=5; 

update_prompt() { 
    local rc=$?; 
    PS1="\n\[\e[36m\][\[\e[0m\]\[\e[1m\e[32m\] $(hostname) \[\e[0m\]\[\e[36m\]|\[\e[0m\]\[\e[1m\e[3${c}m\] $(whoami) \[\e[0m\]\[\e[36m\]|\[\e[0m\]\[\e[1m\e[34m\] \$(pwd) - (\$(ls | wc -l) items) \[\e[0m\]\[\e[36m\]|\[\e[0m\]\[\e[1m\e[33m\] \$(date +'%H:%M:%S') "
    if [[ $rc -ne 0 ]]; then
        PS1+="\[\e[0m\]\[\e[36m\]|\[\e[0m\]\[\e[1m\e[31m\] RC=$rc "
    fi
    PS1+="\[\e[0m\]\[\e[36m\]]\n>\[\e[0m\] "
}; 

# Alias pour navigation et affichage
alias ..="cd .."
alias ll="ls -lahrt"
alias tree="tree -FalxhtC --du"
alias df="df -Ph --total"

# Gestionnaire de répertoires
declare -a _D; 

_sv() { 
    local i; 
    for ((i=0;i<=9;i++)); do 
        [ "$1" = "${_D[$i]}" ] && return; 
    done; 
    for ((i=9;i>0;i--)); do 
        _D[$i]="${_D[((i-1))]}"; 
    done; 
    _D[0]="$1"; 
}; 

_sh() { 
    local i=0; 
    local c=0; 
    while [ "${_D[$i]}" ]; do 
        echo -e "\033[0;34m$i:\033[0;33m - ${_D[$i]}\033[0m"; 
        ((i++)); 
    done; 
}; 

_gd() { 
    local d; 
    _sh; 
    printf "\nchoix : "; 
    read -n 1 d; 
    echo; 
    cd "${_D[$d]}"; 
}; 

# Mise à jour du prompt et gestionnaire de répertoires
PROMPT_COMMAND='update_prompt; _sv "$OLDPWD"'; 

# Alias pour navigation
alias cdh=_gd; 

# Variables d'historique
export HISTTIMEFORMAT="-- %Y/%m/%d %H:%M:%S -- "
export HISTCONTROL=ignoredups:ignorespace; 

# Personnalisation de l'historique
alias history="history | sed 's/\(.*[0-9]*\)/\x1b[32;1m\1\x1b[0m/; s/-- \([0-9/ :]*\) --/\x1b[38;5;214m-- \1 --\x1b[0m/'"
