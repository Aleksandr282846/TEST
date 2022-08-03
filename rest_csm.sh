#!/bin/bash
NN=seid
NR=127.0.0.1:26657
PR=https:// #RPC
DP=100
DL=300
for (( ;; )); do
VP=$(curl ${NR}/status | jq -r .result.sync_info.latest_block_height)
sleep 0.5
RP=$(curl -X POST ${PR}/status? | jq -r .result.sync_info.latest_block_height)
DS=$(bc <<< "${RP} - ${VP}")
echo -e "Разница: ${DS}\n"
  if ((${DS} > ${DP})); then
  sudo systemctl restart ${NN}
    for (( timer=${DL}; timer>0; timer-- ))
    do
    printf "PS %02d \r" $timer
    sleep 1
    done
  else
    for (( timer=${DL}; timer>0; timer-- ))
    do
    printf "PS %02d \r" $timer
    sleep 1
    done
  fi
done
