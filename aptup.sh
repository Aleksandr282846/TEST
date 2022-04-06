#!/bin/bash
#curl -s https://raw.githubusercontent.com/defrisk0/TEST/main/aptup.sh > aptup.sh && chmod  +x aptup.sh && ./aptup.sh
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential jq wget git htop curl screen -y
ver="1.17.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz" 
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
