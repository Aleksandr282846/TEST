#!/bin/bash
#sudo apt update && sudo apt upgrade -y
#sudo apt install build-essential jq wget git htop curl screen -y
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/arch_ad.sh > arch_ad.sh && chmod +x arch_ad.sh && screen -S SAD arch_ad.sh './sad.sh'
read -p "Введите wallet_adress (archway...): " ADR_W
sleep 0.2
read -p "Введите пароль от кошелька: " PASS
sleep 0.2
read -p "Введите время на цикл (сек.): " DELAY
sleep 0.2
CHAIN=torii-1
PR_N=archwayd
TK=torii
FS=60000
if [ -z "$PASS" ]; then
KB="--keyring-backend test"
else
KB=""
fi
ADR_V=$(echo -e "${PASS}\ny\n" | ${PR_N} keys show ${ADR_W} ${KB} --bech val -a)
NAM_W=$(echo -e "${PASS}\ny\n" | ${PR_N} keys show ${ADR_W} ${KB} --output json | jq -r .name)
SC=$(screen -ls | grep "SAD" | awk '{print $1}')
echo -e "\033[32mТеперь можно всернуть сессию screen. Для этого зажмите \033[31m"Ctrl", затем нажните "D" и "A"\033[0m"
echo -e "\033[32mЧтобы вернуться в активную сессию скпипта автоделегирования, введите в командной строке \033[31mscreen -x $SC\033[0m"
sleep 10
for (( ;; )); do
echo -e "Шаг 1 - клеймим награду за делегацию \033[32m(${ADR_V})\033[0m:\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx distribution withdraw-rewards ${ADR_V} --chain-id ${CHAIN} --from ${NAM_W} ${KB} --commission --gas auto --fees ${FS}u${TK} --yes
for (( timer=15; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
BAL=$(${PR_N} q bank balances ${ADR_W} -o json | jq -r '.balances | .[].amount')
echo -e "\n"
echo -e "Проверяем баланс. Баланс: ${BAL}u${TK}\n"
echo -e "Шаг 2 - клеймим награды:\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx distribution withdraw-all-rewards --from ${NAM_W} ${KB} --chain-id ${CHAIN} --gas auto --fees ${FS}u${TK} --yes
for (( timer=15; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
BAL=$(${PR_N} q bank balances ${ADR_W} -o json | jq -r '.balances | .[].amount')
BAL=$(($BAL-99000))
echo -e "\n"
if ((BAL > 100000)); then
echo -e "Делегируем всю сумму:\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx staking delegate ${ADR_V} ${BAL}u${TK} --from ${NAM_W} ${KB} --chain-id ${CHAIN} --gas auto --fees ${FS}u${TK} --yes
else
echo -e "Баланс ${BAL} u${TK} меньше безопасного значения, собираем дальше.\n"
fi
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
done
