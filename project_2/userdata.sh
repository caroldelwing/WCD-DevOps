#!/bin/bash

#Update and upgrade packages
sudo apt update -y
sudo apt upgrade -y

#Install gnupg
sudo apt-get install gnupg

#Import public key used by apt
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

#List File for mongoDB (ubuntu 20)
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.com/apt/ubuntu focal/mongodb-enterprise/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list

#Update and upgrade packages
sudo apt update -y
sudo apt upgrade -y

#Install MongoCLI
sudo apt-get install -y mongocli
