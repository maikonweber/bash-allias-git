#!/bin/bash

# Verifica se o usuário é root
if [[ $EUID -ne 0 ]]; then
   echo "Este script precisa ser executado como root." 
   exit 1
fi

# Verifica se o comando nmcli está instalado
if ! command -v nmcli >/dev/null 2>&1; then
    echo "O comando nmcli não está instalado. Por favor, instale-o para executar este script."
    exit 1
fi

# Obtém a lista de interfaces Wi-Fi disponíveis
interfaces=$(nmcli device wifi list | awk 'NR>1 {print $1}')

# Loop através das interfaces e exibe as redes Wi-Fi próximas
for interface in $interfaces; do
    echo "Redes Wi-Fi próximas detectadas em $interface:"
    networks=$(nmcli device wifi list ifname "$interface" | awk 'NR>1 {print $1}')
    while IFS= read -r network; do
        echo "Conectando-se a $network..."
        nmcli device wifi connect "$network" password "ma128sio4"
    
    done <<< "$networks"
    echo
done
