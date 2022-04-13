#!/bin/bash
#sudo apt update && sudo apt upgrade -y
#sudo apt install build-essential jq wget git htop curl screen -y
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/arch_ad.sh > arch_ad.sh && chmod  +x arch_ad.sh && screen -S arch_ad.sh './sad.sh'
read -p "\n\033[32mВведите wallet_adress (archway...): \n\033[0m" ADR_W
sleep 0.2
read -p "\n\033[32Введите пароль от кошелька: \n\033[0m" PASS
sleep 0.5
read -p "\n\033[32Введите время на цикл (сек.): \n\033[0m" DELAY
sleep 0.5
CHAIN=torii-1
PR_N=archwayd
TOKN=torii
source $HOME/.bash_profile
if [ -z "$PASS" ]; then
KB="--keyring-backend test"
else
KB=""
fi
