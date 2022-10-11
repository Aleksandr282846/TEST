#!/bin/bash
TGID=1877445107
TGAP=2048454991:AAGRYuZwkH5VviIgcTuedFAd0gKrsPiybcY
PS=1
DELAY=3
for (( ;; )); do
IPP=$(sed -n ${PS}p list.txt)
if [ -z "${IPP}" ]; then
PS=1
fi
IPP=$(sed -n ${PS}p list.txt)
PP=$(nc -zv ${IPP} 2>&1 | grep succeeded | awk '{print $7}')
if [ -z "${PP}" ]; then
curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAP}/sendMessage?chat_id=${TGID}&text=❌ SRV ${IPP} DOWN"
else
echo -e "${IPP} CHECK"
fi
PS=$((${PS}+1))
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "* sleep for %02d sec\r" $timer
sleep 1
done
done
