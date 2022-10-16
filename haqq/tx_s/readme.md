```
cd $HOME
```
mkdir temp_tx && cd temp_tx
```
mkdir tx
mkdir utx
nano gen_sign.sh

#!/bin/bash
ADR1=
ADR2=
PASS=
NP=haqqd
CH=haqq_54211-3
WL=
AM=100
FS=5000
AS=$(haqqd q account ${ADR1} -o json | jq -r .base_account.sequence)
AN=$(haqqd q account ${ADR1} -o json | jq -r .base_account.account_number)
NM=1
for (( ;; )); do
if ((${NM} < 1000)); then
${NP} tx bank send ${ADR1} ${ADR2} ${AM}aISLM --chain-id ${CH} --fees ${FS}aISLM --generate-only > ~/temp_tx/utx/unsigned_tx_${NM}.json
echo -e "${PASS}\ny\n" | ${NP} tx sign ~/temp_tx/utx/unsigned_tx_${NM}.json -s ${AS} -a ${AN} --offline --from ${WL} ${KB} --chain-id ${CH} --output-document ~/temp_tx/tx/signed_tx_${NM}.json
NM=$((${NM}+1))
AS=$((${AS}+1))
else
rm ~/temp_tx/utx/*
break
fi
done

nano broadcast.sh

#!/bin/bash
SF=$(ls -l ~/temp_tx/tx | grep "json" | wc | awk '{print $1}')
NM=1
for (( ;; )); do
if ((${NM} < ${SF})); then
haqqd tx broadcast --node http://65.109.12.191:26657/ ~/temp_tx/tx/signed_tx_${NM}.json
NM=$((${NM}+1))
else
rm ~/temp_tx/tx/*
break
fi
done

chmod +x gen_sign.sh && chmod +x broadcast.sh
./gen_sign.sh
./broadcast.sh
