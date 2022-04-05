#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/a_sn.sh > a_sn.sh && chmod  +x a_sn.sh && ./a_sn.sh
#https://app.subsocial.network/5183/aptos-nastraivaem-prostuyu-telemetriyu-s-ispolzovaniem-32355
cd $HOME
echo -e "\n\033[32mСкачиваем снапшот\n\033[0m"
wget http://139.28.222.113/augusta-1_545284.tar
echo -e "\n\033[32mСохраняем priv_validator_key.json в папку $HOME/backup_a\n\033[0m"
cd $HOME
mkdir backup_a && cp ~/.archway/config/priv_validator_key.json ~/backup_a
echo -e "\n\033[32mМеняем настройки прунинга 100 1000 10\n\033[0m"
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="1000"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.archway/config/app.toml 
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.archway/config/app.toml
echo -e "\n\033[32mВыключаем индексирование транзакций\n\033[0m"
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.archway/config/config.toml
echo -e "\n\033[32mЧистим логи\n\033[0m"
journalctl --vacuum-time=1h
docker container stop archway
echo -e "\n\033[32mЧистим место\n\033[0m"
docker run --rm -it -v $HOME/.archway:/root/.archway archwaynetwork/archwayd:augusta unsafe-reset-all
wget -O ~/.archway/config/addrbook.json "http://139.28.222.113/addrbook.json"
echo -e "\n\033[32mРаспаковываем базу\n\033[0m"
tar -C ~/.archway/data -xvf augusta-1_545284.tar
rm -r ~/.archway/data/tx_index.db/*
rm augusta-1_545284.tar
docker container restart archway
