#!/bin/bash
source $HOME/.bash_profile
read -p "Введите название кошелька: " ADR_N
sleep 1
read -p "Введите пароль от кошелька: " PASS
sleep 1
read -p "Введите chain-id: " CHAIN
sleep 1
read -p "Введите название исполняемого файла (cohod, evmosd, ect.): " PR_N
sleep 1
read -p "Введите название токена: " TOKN
sleep 1
read -p "Введите время на цикл (сек.):\n " DELAY
sleep 1

if [ -z "$PASS" ]; then
KB="--keyring-backend test"
else
KB=""
fi

ADR_W=$(${PR_N} keys show ${ADR_N} ${KB} --output json | jq -r .address)
ADR_V=$(${PR_N} keys show ${ADR_N} ${KB} --bech val -a)

for (( ;; )); do
echo -e "Получаем награду за делегацию:\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx distribution withdraw-rewards ${ADR_V} --chain-id ${CHAIN} --from ${ADR_N} ${KB} --commission --yes
for (( timer=20; timer>0; timer-- ))
do
printf "Ждем %02d секунд\r" $timer
sleep 1
done
BAL=$(${PR_N} q bank balances ${ADR_W} -o json | jq -r '.balances | .[].amount')
echo -e "Баланс: ${BAL}u${TOKN}\n"
echo -e "Клеймим награды:\n"
echo -e "${PASS}\n${PASS}\n" | ${PR_N} tx distribution withdraw-all-rewards --from ${ADR_N} ${KB} --chain-id ${CHAIN} --yes
for (( timer=20; timer>0; timer-- ))
do
printf "Ждем %02d секунд\r" $timer
sleep 1
done
BAL=$(${PR_N} q bank balances ${ADR_W} -o json | jq -r '.balances | .[].amount')
BAL=$(($BAL-990000))
echo -e "Баланс: ${BAL}u${TOKN}\n"
if (( BAL > 1000000 )); then
echo -e "Всю сумму отправляем в стейк:\n"
echo -e "${PASS}\n${PASS}\n" | ${PR_N} tx staking delegate ${ADR_V} ${BAL}u${TOKN} --from ${ADR_N} ${KB} --chain-id ${CHAIN} --yes
else
echo -e "Баланс: ${BAL} ${TOKN} BAL < 1 ${TOKN}\n"
fi
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "Ждем %02d секунд\r" $timer
sleep 1
done
done
