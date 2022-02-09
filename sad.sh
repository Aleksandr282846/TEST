#!/bin/bash
source $HOME/.bash_profile
read -p "Введите название кошелька: " ADR_N
sleep 1
read -p "Введите пароль от кошелька: " PASS
sleep 1
read -p "Введите время на цикл (сек.): " DELAY
sleep 1
if [ -z "$PASS" ]; then
KB="--keyring-backend test"
else
KB=""
fi
TOKN=ucoho
PR_N=cohod
CHAIN=darkmatter-1 
ADR_W=$(${PR_N} keys show ${ADR_N} ${KB} --output json | jq -r .address)
ADR_V=$(${PR_N} keys show ${ADR_N} ${KB} --bech val -a)
for (( ;; )); do
echo -e "Получаем награду за делегацию\n"
echo -e "${PASS}\ny\n" | ${PR_N} tx distribution withdraw-rewards ${ADR_V} --chain-id ${CHAIN} --from ${ADR_N} ${KB} --commission --yes
for (( timer=20; timer>0; timer-- ))
do
printf "Ждем %02d секунд\r" $timer
sleep 1
done
BAL=$(${PR_N} q bank balances ${ADR_N} -o json | jq -r '.balances | .[].amount')
echo -e "Баланс: ${BAL}${TOKN}\n"
echo -e "Клеймим награды\n"
echo -e "${PASS}\n${PASS}\n" | ${PR_N} tx distribution withdraw-all-rewards --from ${ADR_N} ${KB} --chain-id ${CHAIN} --yes
for (( timer=20; timer>0; timer-- ))
do
printf "Ждем %02d секунд\r" $timer
sleep 1
done
BAL=$(${PR_N} q bank balances ${ADR_N} -o json | jq -r '.balances | .[].amount')
BAL=$(($BAL-990000))
echo -e "Баланс: ${BAL}${TOKN}\n"
echo -e "Всю сумму отправляем в стейк\n"
if (( BAL > 1000000 )); then
echo -e "${PASS}\n${PASS}\n" | ${PR_N} tx staking delegate ${ADR_V}  ${BAL}${TOKN} --from ${ADR_N} ${KB} --chain-id ${CHAIN} --yes
else
echo -e "Баланс: ${BAL} ${TOKN} BAL < 1000000 ${TOKN}\n"
fi
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "Ждем %02d секунд\r" $timer
sleep 1
done
done
