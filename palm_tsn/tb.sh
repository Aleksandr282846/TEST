#!/bin/bash
TGID1=
TGAPI=
DELAY=
NAME=
for (( ;; )); do
CP=$(cat /proc/loadavg | awk '{print $1}')
MD=$(df -m | grep "/dev/" | head -1 | awk '{print $1}')
FS=$(df -m | grep -w "$MD" | awk '{print $5}')
MU=$(free | grep "Mem" | awk '{print $3}')
MT=$(free | grep "Mem" | awk '{print $2}')
MU=$(($MU / 1000))
MT=$(($MT / 1000))
BS=$(curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "eth_blockNumber", "params":[]}' http://127.0.0.1:18545 | jq -r .result)
BS=$(echo $(($BS)))
curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID1}&text=✅ ${NAME} ${BS} | CP=${CP} | MU=${MU}-${MT}  | US=${FS}"
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "* sleep for %02d sec\r" $timer
sleep 1
done
done
