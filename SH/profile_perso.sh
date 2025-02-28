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
#_________________________
#
#       Fonctions
#_________________________
#
# Efface l'écran et désactive le timeout
clear
unset TMOUT

# Définit la variable c selon que l'utilisateur est root ou non
[ "$(whoami)" = "root" ] && c=1 || c=5

# Configure le prompt de la ligne de commande (PS1)
PS1="\n\[\e[36m\][\[\e[0m\]\[\e[1m\e[32m\] $(hostname) \[\e[0m\]\[\e[36m\]|\[\e[0m\]\[\e[1m\e[3${c}m\] $(whoami) \[\e[0m\]\[\e[36m\]|\[\e[0m\]\[\e[1m\e[34m\] \$(pwd) - (\$(ls | wc -l) items) \[\e[0m\]\[\e[36m\]|\[\e[0m\]\[\e[1m\e[33m\] \$(date +'%H:%M:%S') \[\e[0m\]\[\e[36m\]]\n>\[\e[0m\] "

# Définit des alias
alias ..="cd .."
alias ll="ls -lahrt"
alias tree="tree -FalxhtC --du"
alias df="df -Ph --total"

# Déclare un tableau pour stocker les répertoires visités
declare -a _D

# Fonction pour sauvegarder le répertoire courant
_sv() {
    local i
    for ((i=0; i<=9; i++)); do
        [ "$1" = "${_D[$i]}" ] && return
    done
    for ((i=9; i>0; i--)); do
        _D[$i]="${_D[((i-1))]}"
    done
    _D[0]="$1"
}

# Fonction pour afficher les répertoires sauvegardés
_sh() {
    local i=0
    while [ "${_D[$i]}" ]; do
        echo -e "\033[0;34m$i:\033[0;33m - ${_D[$i]}\033[0m"
        ((i++))
    done
}

# Fonction pour changer de répertoire à partir de l'historique
_gd() {
    local d
    _sh
    printf "\nchoix : "
    read -n 1 d
    echo
    cd "${_D[$d]}"
}

# Configure la commande à exécuter avant chaque invite
PROMPT_COMMAND='_sv "$OLDPWD"'

# Alias pour changer de répertoire avec historique
alias cdh=_gd

# Configure le format de l'historique
export HISTTIMEFORMAT="-- %Y/%m/%d %H:%M:%S -- "
export HISTCONTROL=ignoredups:ignorespace

# Alias pour personnaliser l'affichage de l'historique
alias history="history | sed 's/\(.*[0-9]*\)/\x1b[32;1m\1\x1b[0m/; s/-- \([0-9/ :]*\) --/\x1b[38;5;214m-- \1 --\x1b[0m/'"
