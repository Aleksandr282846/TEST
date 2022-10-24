```
cd $HOME
```
```
mkdir temp_tx && cd temp_tx
```
```
mkdir tx
```
```
mkdir utx
```
```
nano gen_ls_val.sh
```
```
#!/bin/bash
N_CLI=uptickd
PRM1=1
PRM2=20

for (( ;; )); do
	if ((${PRM1} < ${PRM2})); then
		ADD_V=$(${N_CLI} query staking validators --limit 500 -o json | jq -r '.validators[] | select(.status=="BOND_STATUS_BONDED") | [.operator_address] | @csv' | jq -r | sed -n ${PRM1}p)
		echo ${ADD_V} >> list_val.txt
		PRM1=$((${PRM1}+1))
	else
		break
	fi
done
```
```
chmod +x gen_ls_val.sh
```
```
nano gen_sign_dl.sh
```
```
#!/bin/bash
ADR1=
PASS=
N_CLI=uptickd
N_CHN=uptick_7000-1
FEES=50
AMNT=10
N_TCK=auptick
PRM1=1
PRM2=1
N_WL=$(echo -e "${PASS}\ny\n" | ${N_CLI} keys show ${ADR1} --output json | jq -r .name)
A_SQC=$(${N_CLI} q account ${ADR1} --output json | jq -r .base_account.sequence)
A_NMB=$(${N_CLI} q account ${ADR1} --output json | jq -r .base_account.account_number)

for (( ;; )); do
	ADR_V=$(sed -n ${PRM1}p list_val.txt)
	if [ -z "${ADR_V}" ]; then
		break
		else
			echo -e "${PASS}\ny\n" | ${N_CLI} tx staking delegate ${ADR_V} ${AMNT}${N_TCK} --chain-id ${N_CHN} --gas auto --fees ${FEES}${N_TCK} --from ${N_WL} --generate-only > ~/temp_tx/utx/unsigned_tx_dl_${PRM1}.json
			echo -e "${PASS}\ny\n" | ${N_CLI} tx sign ~/temp_tx/utx/unsigned_tx_dl_${PRM1}.json -s ${A_SQC} -a ${A_NMB} --chain-id ${N_CHN} --from ${N_WL} --offline --output-document ~/temp_tx/tx/signed_tx_dl_${PRM1}.json
			PRM1=$((${PRM1}+1))
			A_SQC=$((${A_SQC}+1))
			rm ~/temp_tx/utx/*
		fi
done
```
```
chmod +x gen_sign_dl.sh
```
```
nano broadcast_dl.sh
```
```
#!/bin/bash
N_CLI=uptickd
SFL=$(ls -l ~/temp_tx/tx | grep "json" | wc | awk '{print $1}')
PRM1=1
RPC="--node http://127.0.0.1:26657"

for (( ;; )); do
	if ((${PRM1} < ${SFL})); then
		${N_CLI} tx broadcast ${RPC} ~/temp_tx/tx/signed_tx_dl_${PRM1}.json
		PRM1=$((${PRM1}+1))
	else
		rm ~/temp_tx/tx/*
		break
	fi
done
```
```
chmod +x broadcast_dl.sh
```
```
nano gen_sign_war.sh
```
```
#!/bin/bash
ADR1=
PASS=
N_CLI=uptickd
N_CHN=uptick_7000-1
GAS=1500000
PRM1=1
PRM2=1500
N_WL=$(echo -e "${PASS}\ny\n" | ${N_CLI} keys show ${ADR1} --output json | jq -r .name)
A_SQC=$(${N_CLI} q account ${ADR1} --output json | jq -r .base_account.sequence)
A_NMB=$(${N_CLI} q account ${ADR1} --output json | jq -r .base_account.account_number)

for (( ;; )); do
	if ((${PRM1} < ${PRM2})); then
		echo -e "${PASS}\ny\n" | ${N_CLI} tx distribution withdraw-all-rewards --from ${N_WL} --chain-id ${N_CHN} --gas ${GAS} --generate-only > ~/temp_tx/utx/unsigned_tx_war_${PRM1}.json
		echo -e "${PASS}\ny\n" | ${N_CLI} tx sign ~/temp_tx/utx/unsigned_tx_war_${PRM1}.json -s ${A_SQC} -a ${A_NMB} --chain-id ${N_CHN} --from ${N_WL} --offline --output-document ~/temp_tx/tx/signed_tx_war_${PRM1}.json
		PRM1=$((${PRM1}+1))
		A_SQC=$((${A_SQC}+1))
		rm ~/temp_tx/utx/*
	else
		break
	fi
done
```
```
chmod +x gen_sign_war.sh
```
```
nano broadcast_war.sh
```
```
#!/bin/bash
N_CLI=uptickd
SFL=$(ls -l ~/temp_tx/tx | grep "json" | wc | awk '{print $1}')
PRM1=1
RPC="--node http://127.0.0.1:26657"

for (( ;; )); do
	if ((${PRM1} < ${SFL})); then
		${N_CLI} tx broadcast ${RPC} ~/temp_tx/tx/signed_tx_war_${PRM1}.json
		PRM1=$((${PRM1}+1))
	else
		rm ~/temp_tx/tx/*
		break
	fi
done
```
```
chmod +x gen_sign_war.sh
```
```
./gen_ls_val.sh
```
```
./gen_sign_dl.sh
```
```
./broadcast_dl.sh
```
```
./gen_sign_war.sh
```
```
./broadcast_war.sh
```
