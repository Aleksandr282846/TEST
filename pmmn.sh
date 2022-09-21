#!/bin/bash
# wget https://raw.githubusercontent.com/bitcoin/bips/master/bip-0039/english.txt
PR=1
ADD=
DT=$(date)
for (( ;; )); do
PS=$(sed -n ${PR}p english.txt)
MNEM="half decide tent pave ${PS} rose card goddess potato brush merry indicate balcony skate course cotton weasel visa slice rice stay parent nose gap"
echo -e ${PS}
echo -e "${MNEM}" | haqqd keys add TEST --recover --keyring-backend test
SS=$(haqqd keys show TEST --keyring-backend test --output json | jq -r .address)
echo -e ${SS}
echo -e ${DT} ${SS} >> log.txt
echo -e ${MNEM}
echo -e ${DT} ${MNEM} >> log.txt
if [[ ${SS} = ${ADD} ]]; then
break
else
haqqd keys delete TEST --keyring-backend test -y
PR=$((${PR}+1))
fi
done
