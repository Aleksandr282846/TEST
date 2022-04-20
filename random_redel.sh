#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/random_redel.sh > random_redel.sh && chmod +x random_redel.sh && screen -S BSRD './random_redel.sh'
D1=archwayvaloper1u8rks82gfsmc3527rnjll6q73cvm70df6w28pp
D2=archwayvaloper15h3kntd2x4p0agpdmk5vru80hukx7rd6y0hpnr
D3=archwayvaloper1c9zyd90kc0qpel29p27zq7m9y59t06f5rr7d33
D4=archwayvaloper18nkyh6h42hut7yzr3jet7nehp5zn8qy9c7umrh
#D5=
#D6=
#D7=
#D8=
#D9=
#D10=
DR=archwayvaloper1w54qanhedhyngdn375nudyt00lmnrl20en88pl
FS=100000
PASS=
DELAY=1800
WA=SRG0Z10
NN=archwayd
for (( ;; )); do
RP=$(( $RANDOM % 100 + 1 ))000000
RD=D$(( $RANDOM % 4 + 1 ))
RD=$(echo ${!RD})
echo -e "WIN $RD - $RPtorii\n"
echo -e "$(date) WIN ${RD} - ${RP}utorii\n" >> log.txt
FG=$(echo -e "${PASS}\ny\n" | ${NN} tx staking redelegate ${DR} ${RD} ${RP}utorii --from ${WA} --chain-id torii-1 --gas auto --fees ${FS}utorii --output json --yes | jq -r .code)
sleep 1
if (( FG > 0 )); then
sleep 10
echo -e "${PASS}\ny\n" | ${NN} tx staking redelegate ${DR} ${RD} ${RP}utorii --from ${WA} --chain-id torii-1 --gas 300000 --fees ${FS}utorii  --yes
fi
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "Break %02d \r" $timer
sleep 1
done
done
