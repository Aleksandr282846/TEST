#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/pars_bl_arch.sh > pars_bl_arch.sh && chmod +x pars_bl_arch.sh
NB=$(curl localhost:26657/status | jq -r .result.sync_info.latest_block_height)
NA=31500
NS=0
for (( ;; )); do
PA=$(archwayd query block $NB | jq -r .block.last_commit | jq '.signatures[] | select(.validator_address=="4C3B9A84FE88A46B622C9060B5C4764E669DC586")')
if [[ ! -z "$PA" ]]; then
echo "Блок $NA. Всего: $NS" >> log_a.txt
echo $PA >> log_a.txt
NA=$(($NA+1))
NS=$(($NS+1))
else
NA=$(($NA+1))
fi
if (( NA >= NB )); then
break
fi
done
