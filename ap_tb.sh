#!/bin/bash
read -p "Введите ID бота: " TGID1
sleep 1
read -p "Введите API бота: " TGAPI
sleep 1
read -p "Введите время на цикл (сек.): " DELAY
sleep 1
for (( ;; )); do
RS=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_data_client_error_responses" | grep "TOTAL_COUNT" | awk '{print $2}')
if [[ -z $RS ]]; then
RS=0
fi
if (( $RS > 0 )) ; then
echo -e "RESTART APTOS\n"
systemctl restart aptosd
sleep 60
fi
IP=$(wget -qO- eth0.me)
CP=$(cat /proc/loadavg | awk '{print $1}')
MD=$(df -m | grep "/dev/" | head -1 | awk '{print $1}')
FS=$(df -m | grep -w "$MD" | awk '{print $5}')
MU=$(free | grep "Mem" | awk '{print $3}')
MT=$(free | grep "Mem" | awk '{print $2}')
MU=$(($MU / 1000))
MT=$(($MT / 1000))
AC=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_data_client_success_responses" | grep "TOTAL_COUNT" | awk '{print $2}')
ASN=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version" | grep "synced" | awk '{print $2}')
echo -e "AC=${AC} ASN=${ASN} RS=${RS} IP=${IP} CP=${CP} FS=${FS} MU=${MU} MT=${MT}\n"
curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID1}&text=✅ aptos 1 | syn=${ASN} | co=${AC} | LO=${CP} | m=${MU}-${MT} | u=${FS}"
echo -e "\n"
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "* sleep for %02d sec\r" $timer
sleep 1
done
done
