#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/sbsp.sh > sbsp.sh && chmod +x sbsp.sh && ./sbsp.sh
read -p "Введите название ноды: " NM_N
sleep 0.5
read -p "Введите адрес на который будем фармить: " ADR_W
sleep 0.5
read -p "Введите размер PLOT_SIZE (например 100G): " PS
sleep 0.5
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential jq wget git htop curl -y
cd $HOME
rm -rf subspace*
sleep 0.5
wget -O subspace-node https://github.com/subspace/subspace/releases/download/snapshot-2022-may-19/subspace-node-ubuntu-x86_64-snapshot-2022-may-19
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/snapshot-2022-may-19/subspace-farmer-ubuntu-x86_64-snapshot-2022-may-19
chmod +x subspace*
mv subspace* /usr/local/bin/

echo "[Unit]
Description=Subspace Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-node) --chain testnet --execution wasm -unsafe-pruning --pruning 1024 --keep-blocks 1024 --validator --name $NM_N
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/subspaced.service

echo "[Unit]
Description=Subspaced Farm
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-farmer) farm --reward-address $ADR_W --plot-size $PS
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/subspaced-farmer.service

mv $HOME/subspaced* /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced subspaced-farmer
sudo systemctl restart subspaced


cd $HOME

#sudo systemctl stop subspaced && sudo systemctl stop subspaced-farmer
#sudo systemctl disable subspaced subspaced-farmer
#rm /usr/local/bin/subspace-node
#rm /usr/local/bin/subspace-farmer
#rm /etc/systemd/system/subspaced.service
#rm /etc/systemd/system/subspaced-farmer.service
#rm -r ~/.local/share/subspace
#rm -r ~/.local/share/subspace-node
