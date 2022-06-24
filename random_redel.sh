#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/random_redel.sh > random_redel.sh && chmod +x random_redel.sh && screen -S BSRD './random_redel.sh'
D1=quickvaloper1yxydwcrqwtuehm0k3anfjhf2pffyl8x4jwhuqu
D2=quickvaloper1lwaw46t3mn6njes5krra2lqpwaks5hfjzr8v2s
D3=quickvaloper1nj4wfrah2yshhr4tyvqc2c7crxx4sl9qrqyej9
D4=quickvaloper1egtrpshx6vg3v7pkksvd8xmgv53sskl5ehfucq
D5=quickvaloper1h7m4exrg3gux672pp7wyg78cs2ftateegn8mut
D6=quickvaloper1nze0w7jt74m0xmu3evzyunrtss9zeqrwjc8t0g
D7=quickvaloper17vsqv50glpv5nahc8cdqkmqqgzjjcpmjr90lxl
D8=quickvaloper1plux0hlt5kpxwr7e9kgg8zlk0e4cetcxj22c2s
D9=quickvaloper1s42upp5fjvxy9gnsax9zsvqjxzrcuxns6za6ec
D10=quickvaloper1r46j5qhnme5klumyf6g3hy6d8gc9hukn4drjfq
DR=quickvaloper1zcm6a3thfsv54glc3e2l27fnp7n7fnuzxy7q7u
#FS=--fees 100000utorii
PASS=
DELAY=600
WA=SRG0Z10
NN=quicksilverd
for (( ;; )); do
RP=$(( $RANDOM % 50 + 1 ))0000
RD=D$(( $RANDOM % 10 + 1 ))
RD=$(echo ${!RD})
echo -e "WIN ${RD} - ${RP}uqck\n"
echo -e "$(date) WIN ${RD} - ${RP}uqck\n" >> log.txt
FG=$(echo -e "${PASS}\ny\n" | ${NN} tx staking redelegate ${DR} ${RD} ${RP}uqck --from ${WA} --chain-id killerqueen-1 --gas auto ${FS} --output json --yes | jq -r .code)
sleep 1
if (( FG > 0 )); then
sleep 10
echo -e "${PASS}\ny\n" | ${NN} tx staking redelegate ${DR} ${RD} ${RP}uqck --from ${WA} --chain-id killerqueen-1 --gas auto ${FS} --yes
fi
for (( timer=${DELAY}; timer>0; timer-- ))
do
printf "Break %02d \r" $timer
sleep 1
done
done
