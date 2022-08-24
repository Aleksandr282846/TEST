#!/bin/bash
read -p "Введите IP адрес сервера валидатора: " ADD_V
sleep 0.5
read -p "Введите IP адрес сервера фулноды: " ADD_F
sleep 0.5
read -p "Введите порт API сервера валидатора: " ADD_PV
sleep 0.5
read -p "Введите порт API сервера фулноды: " ADD_PF
sleep 0.5
read -p "Введите user_id: " TGID
sleep 0.5
read -p "Введите API токен бота: " TGAPI
sleep 0.5
read -p "Введите интервал опроса (сек.): " DELAY
sleep 0.5
for (( ;; )); do
CIDV=$(curl -s http://${ADD_V}:${ADD_PV}/v1/ | jq -r .chain_id)
CIDF=$(curl -s http://${ADD_F}:${ADD_PF}/v1/ | jq -r .chain_id)
sleep 0.1
EPV=$(curl -s http://${ADD_V}:${ADD_PV}/v1/ | jq -r .epoch)
EPF=$(curl -s http://${ADD_F}:${ADD_PF}/v1/ | jq -r .epoch)
sleep 0.1
HGV=$(curl -s http://${ADD_V}:${ADD_PV}/v1/ | jq -r .block_height)
HGF=$(curl -s http://${ADD_F}:${ADD_PF}/v1/ | jq -r .block_height)
sleep 0.1
NRV=$(curl -s http://${ADD_V}:${ADD_PV}/v1/ | jq -r .node_role)
NRF=$(curl -s http://${ADD_F}:${ADD_PF}/v1/ | jq -r .node_role)
sleep 0.1
echo -e "CHECK ${CIDV} ${EPV} ${HGV} ${NRV}"
echo -e "CHECK ${CIDF} ${EPF} ${HGF} ${NRF}"
sleep 0.1
  if ((${HGV} > 0)); then
  curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID}&text=✅ APT ${NRV} | C_ID ${CIDV} | EP ${EPV} | HG ${HGV}"
  echo -e "TBV SEND 1\n"
  else
  curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID}&text=❌ APT ${NRV} dont work"
  echo -e "TBV SEND 2\n"
  fi
  if ((${HGF} > 0)); then
  curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID}&text=✅ APT ${NRF} | C_ID ${CIDF} | EP ${EPF} | HG ${HGF}"
  echo -e "TBF SEND 1\n"
  else
  curl -s -X POST --connect-timeout 10 "https://api.telegram.org/bot${TGAPI}/sendMessage?chat_id=${TGID}&text=❌ APT ${NRF} dont work"
  echo -e "TBF SEND 2\n"
  fi
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "Sleep for %02d sec\r" $timer
sleep 1
done
done
