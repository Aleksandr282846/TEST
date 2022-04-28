#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/sad_tn.sh > sad_tn.sh && chmod +x sad_tn.sh && screen -S SAD './sad_tn.sh'
#sudo apt update && sudo apt upgrade -y
#sudo apt install build-essential jq wget git htop curl screen bc -y
echo -e "\033[32m"
read -p "Введите wallet_adress: " ADR_W
sleep 0.2
read -p "Введите пароль от кошелька (при использовании флага keyring-backend test оставьте поле пустым): " PASS
sleep 0.2
read -p "Введите имя сервиса: " PR_N
sleep 0.2
read -p "Введите имя сети: " CHAIN
sleep 0.2
read -p "Введите имя токена: " TK
sleep 0.2
read -p "Введите значение fees: " FS
sleep 0.2
read -p "Введите значение gas (пустое поле - auto): " GS
sleep 0.2
read -p "Введите сумму ревардов с которой запускаем цикл: " DR
sleep 0.2
read -p "Введите значение задержки между транзакциями сек.: " TM
sleep 0.2
echo -e "\033[0m"
if [ -z "${PASS}" ]; then
KB="--keyring-backend test"
else
KB=""
fi
if [ -z "${GS}" ]; then
KP="auto"
else
KP=${GS}
fi
echo -e "\033[0m"
ADR_V=$(echo -e "${PASS}\ny\n" | ${PR_N} keys show ${ADR_W} ${KB} --bech val -a)
NAM_W=$(echo -e "${PASS}\ny\n" | ${PR_N} keys show ${ADR_W} ${KB} --output json | jq -r .name)
SC=$(screen -ls | grep "SAD" | awk '{print $1}')
echo -e "\033[32mТеперь можно свернуть сессию screen. Для этого зажмите \033[31m"Ctrl", затем нажните "D" и "A"\033[0m"
echo -e "\033[32mЧтобы вернуться в активную сессию скрипта автоделегирования, введите в командной строке \033[31mscreen -x $SC\033[0m"
for (( ;; )); do
sleep 1
CK=$(echo "($(${PR_N} query distribution commission ${ADR_V} -o json | jq -r  .commission[].amount) + 0.5)/1" | bc)
sleep 1
CR=$(echo "($(${PR_N} query distribution rewards ${ADR_W} ${KB} ${ADR_V} -o json | jq -r  .rewards[].amount) + 0.5)/1" | bc)
sleep 1
CV=$(echo "($(${PR_N} query distribution validator-outstanding-rewards ${ADR_V} -o json | jq -r  .rewards[].amount) + 0.5)/1" | bc)
DS=$(bc <<< "${CK} + ${CR}")
DD=$(bc <<< "(${CK} + ${CR}) / 1000000")
DP=$(bc <<< "${CV} - ${CK} + ${CR}")
echo -e "\033[32mПроверка суммы. Комиссия ${CK}u${TK} + реварды ${CR}u${TK} = ${DD}${TK}. Разница = ${DP}u${TK}\033[0m"
if ((${DS} > ${DR})); then
echo -e "\033[32mКлеймим награду за делегацию \033[31m(${ADR_V})\033[0m:\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx distribution withdraw-rewards ${ADR_V} --chain-id ${CHAIN} --from ${NAM_W} ${KB} --commission --gas ${KP} --fees ${FS}u${TK} --yes
for (( timer=${TM}; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
if ((${DP} > 10)); then
echo -e "\033[32mКлеймим все награды:\033[0m\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx distribution withdraw-all-rewards --from ${NAM_W} ${KB} --chain-id ${CHAIN} --gas ${KP} --fees ${FS}u${TK} --yes
for (( timer=${TM}; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
else
BAL=$(${PR_N} q bank balances ${ADR_W} -o json | jq -r '.balances | .[].amount')
echo -e "\033[32mПроверяем баланс. Баланс: ${BAL}u${TK}\033[0m\n"
sleep 1
BAL=$(echo "${BAL} - 990000" | bc)
if ((${BAL} > 1000000)); then
echo -e "\033[32mШаг 3. Делегируем всю сумму:\033[0m\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx staking delegate ${ADR_V} ${BAL}u${TK} --from ${NAM_W} ${KB} --chain-id ${CHAIN} --gas ${KP} --fees ${FS}u${TK} --yes
for (( timer=${TM}; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
else
echo -e "\033[31Баланс ${BAL}u${TK} меньше безопасного значения, собираем дальше.\033[0m\n"
fi
fi
else
for (( timer=${TM}; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
fi
done
