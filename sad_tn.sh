#!/bin/bash
read -p "Введите wallet_adress: " ADR_W
sleep 0.2
read -p "Введите пароль от кошелька: " PASS
sleep 0.2
PR_N=archwayd #
CHAIN=torii-1 #
TK=torii #
FS=250000 #
DR=2000000 #
DELAY=60
if [ -z "$PASS" ]; then
KB="--keyring-backend test"
else
KB=""
fi
ADR_V=$(echo -e "${PASS}\ny\n" | ${PR_N} keys show ${ADR_W} ${KB} --bech val -a)
NAM_W=$(echo -e "${PASS}\ny\n" | ${PR_N} keys show ${ADR_W} ${KB} --output json | jq -r .name)
SC=$(screen -ls | grep "SAD" | awk '{print $1}')
echo -e "\033[32mТеперь можно свернуть сессию screen. Для этого зажмите \033[31m"Ctrl", затем нажните "D" и "A"\033[0m"
echo -e "\033[32mЧтобы вернуться в активную сессию скрипта автоделегирования, введите в командной строке \033[31mscreen -x $SC\033[0m"
sleep 5
for (( ;; )); do
DP=$(${PR_N} query distribution rewards ${ADR_V} ${ADR_W} --chain-id ${CHAIN} -o json | jq -r  .rewards[].amount)
echo -e "Проверяем rewards. Сумма: ${DP}u${TK}\n"
if ((DP > DR)); then
echo -e "Шаг 1 - клеймим награду за делегацию \033[32m(${ADR_V})\033[0m:\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx distribution withdraw-rewards ${ADR_V} --chain-id ${CHAIN} --from ${NAM_W} ${KB} --commission --gas auto --fees ${FS}u${TK} --yes
for (( timer=15; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
echo -e "Шаг 2 - клеймим награды:\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx distribution withdraw-all-rewards --from ${NAM_W} ${KB} --chain-id ${CHAIN} --gas auto --fees ${FS}u${TK} --yes
for (( timer=15; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
BAL=$(${PR_N} q bank balances ${ADR_W} -o json | jq -r '.balances | .[].amount')
echo -e "\n"
echo -e "Проверяем баланс. Баланс: ${BAL}u${TK}\n"
BAL=$(($BAL-990000))
if ((BAL > 1000000)); then
echo -e "Шаг 3. Делегируем всю сумму:\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx staking delegate ${ADR_V} ${BAL}u${TK} --from ${NAM_W} ${KB} --chain-id ${CHAIN} --gas auto --fees ${FS}u${TK} --yes
else
echo -e "Баланс ${BAL}u${TK} меньше безопасного значения, собираем дальше.\n"
fi
else
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "Пауза %02d \r" $timer
sleep 1
done
done
