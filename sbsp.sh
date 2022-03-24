#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/sbsp.sh > sbsp.sh && chmod +x sbsp.sh && ./sbsp.sh
read -p "Введите название ноды: " NM_N
sleep 0.5
read -p "Введите адрес на который будем фармить: " ADR_W
sleep 0.5

cd $HOME
rm -rf subspace*
sleep 0.5
wget -O subspace-node https://github.com/subspace/subspace/releases/download/snapshot-2022-mar-09/subspace-node-ubuntu-x86_64-snapshot-2022-mar-09
wget -O subspace-farmer https://github.com/subspace/subspace/releases/download/snapshot-2022-mar-09/subspace-farmer-ubuntu-x86_64-snapshot-2022-mar-09
chmod +x subspace*
mv subspace* /usr/local/bin/

echo "[Unit]
Description=Subspace Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which subspace-node) --chain testnet --wasm-execution compiled --execution wasm --bootnodes \"/dns/farm-rpc.subspace.network/tcp/30333/p2p/12D3KooWPjMZuSYj35ehced2MTJFf95upwpHKgKUrFRfHwohzJXr\" --rpc-cors all --rpc-methods unsafe --ws-external --validator --telemetry-url \"wss://telemetry.polkadot.io/submit/ 1\" --name $NM_N
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
ExecStart=$(which subspace-farmer) farm --reward-address $ADR_W
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/subspaced-farmer.service

mv $HOME/subspaced* /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced subspaced-farmer
sudo systemctl restart subspaced
sudo systemctl restart subspaced-farmer

echo -e "Ваш public-key"
echo -e subspace-farmer identity view --public-key
echo -e "Ваш mnemonic"
echo -e subspace-farmer identity view --mnemonic
