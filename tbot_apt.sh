#!/bin/bash
TGID=
TGAPI=
DELAY=300
SV1=0
for (( ;; )); do
CP=$(cat /proc/loadavg | awk '{print $1}')
MD=$(df -m | grep "/dev/" | head -1 | awk '{print $1}')
FS=$(df -m | grep -w "$MD" | awk '{print $5}')
MU=$(free | grep "Mem" | awk '{print $3}')
MT=$(free | grep "Mem" | awk '{print $2}')
MU=$(($MU / 1000))
MT=$(($MT / 1000))
SV=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version{.*\"synced\"}" | awk '{print $2}')
EV=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version{.*\"synced_epoch\"}" | awk '{print $2}')
if ((${SV} > 0)); then
EM=$(echo "${SV} - ${SV1}" | bc)
curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID}&text=✅ APT VN ${EV} | ${SV} ${EM} | ${CP} | ${MU}-${MT} | ${FS}"
echo -e "TBV SEND 1\n"
else
curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID}&text=❌ APT VN DONT WORK"
echo -e "TBV SEND 2\n"
fi
SV1=${SV}
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "Sleep for %02d sec\r" $timer
sleep 1
done
done
