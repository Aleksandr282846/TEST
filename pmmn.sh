#!/bin/bash
AD_N=1
read -p "Введите адрес: " AD_A
sleep 1

# if any params recived
if [ "$#" -gt 0 ]; then
if [ "$1" != "-file" ]; then
echo "Нажмите клашину [ -file <file_location> ] для указания пути к файлу. (1)"
exit	#exit if wrong key
fi
if [ "$2" = "" ]; then
echo "Укажите путь в файлу."
exit	#exit if now file name
else
file_path=$2	#file path
if [ ! -f "$file_path" ]; then
echo "$file_path does not exist."
fi
fi
#read file by lines
while read line; do
FIND=$line	#value from file's line
for (( ;; )); do
echo -e "Проверка слова ${FIND}"
MNEM=" $FIND"
echo -e "${MNEM}\ny\n" | cohod keys add ${AD_N} --recover --keyring-backend test --output json | jq -r .address
SS=$(cohod keys show ${AD_N} --keyring-backend test --output json | jq -r .address)
echo -e ${SS}
if [[ $SS = $AD_A ]]; then
echo -e "Необходимое слово ${FIND}"
break
else
echo -e "${SS} не является ${AD_A}"
cohod keys delete ${AD_N} --keyring-backend test --yes
AD_N=$(($AD_N+1))
fi
for (( timer=5; timer>0; timer-- )); do
printf "Ждем %02d секунд\r" $timer
sleep 1
done
done
done < $file_path

else
	echo "Please, use key [ -file <file_location> ] to specify path to text file."
fi
