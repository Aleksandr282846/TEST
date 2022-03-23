#!/bin/bash
#sudo apt-get install curl gnupg apt-transport-https ca-certificates \
#lsb-release -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
#| sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
#echo "deb [arch=$(dpkg --print-architecture) \
#signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
#https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
#| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#sudo apt-get update && \
#sudo apt-get install docker-ce docker-ce-cli containerd.io -y

#update package and install dependencies
sudo apt update
sudo apt install ca-certificates curl git gnupg lsb-release -y
# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y 
sudo apt install docker-ce docker-ce-cli containerd.io -y

#Install compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
