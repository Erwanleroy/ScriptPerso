#!/bin/bash:

#fonction de recherche textuelle des adresses
getAddr(){
#nombre infini de pipe illisible qui selectionne la ligne contenant largument de la fonction (wlp/enp/lo) recherchees
numLigneEthernet=$((($(ifconfig | cat -n | egrep "$1" | colrm 7))+1))
#ici on reprend la commande entiere en utilisant uniquement la ligne trouvee precedemment puis on prend le deuxieme mot (grace a awk) qui contient ladresse
adrIp=$(ifconfig | head -n$numLigneEthernet | tail -n1 | awk '{print $2}')
#puis on laffiche quoi :)
echo "$adrIp"
echo
}

#on prepare un bel affichage (plus beau que mon code avec tout mes commentaire en tout cas)
clear
echo
echo "Your Wifi Address : "
getAddr "wlp"
echo "Your Ethernet Address : "
getAddr "enp"
echo "Your Local Address : "
getAddr "lo:"
echo
