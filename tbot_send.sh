#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/tbot_send.sh > tbot_send.sh && chmod  +x tbot_send.sh && screen -S AD-1 './tbot_send.sh'
read -p "Введите адрес валидатора: " ADD_V
sleep 0.5
read -p "Введите user_id: " TGID
sleep 0.5
read -p "Введите API токен: " TGAPI
sleep 0.5
read -p "Введите интервал опроса (сек.): " DELAY
sleep 0.5
read -p "Введите название исполняемого файла (cohod, evmosd, ect.): " PR_N
sleep 0.5
for (( ;; )); do
VB=$(curl -s localhost:26657/status | jq -r .result.sync_info.latest_block_height)
PJ=$(${PR_N} query staking validator ${ADD_V} --output json | jq .jailed)
VP=$(curl -s localhost:26657/status | jq -r .result.validator_info.voting_power)
echo -e "check, height block=${VB} | voting power=${VP}\n"
if ([ $PJ = false ]); then
curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID}&text=✅ ${PR_N} | height block=${VB} | voting power=${VP} | jailed=${PJ}"
echo -e "TB SEND 1\n"
else
curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID1}&text=❌ ${PR_N} in jail"
echo -e "TB SEND 2\n"
fi
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "sleep for %02d sec\r" $timer
sleep 1
done
done
