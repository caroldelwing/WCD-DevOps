#!/bin/bash

# Import the MongoDB GPG public key
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

# Create a MongoDB repository file
echo "deb [arch=amd64] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# Update the package list
sudo apt update

# Install Node.js and npm
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

# Install MongoDB
sudo apt install -y mongodb-org

#Download the csv file from the GitHub repo
curl -o nhl-stats-2022.csv https://raw.githubusercontent.com/caroldelwing/WCD-DevOps/main/project_2/nhl-stats-2022.csv

#Set the IP of the MongoDB host
sudo sed -i 's/127.0.0.1/10.0.10.10,127.0.0.1/g' /etc/mongod.conf

# Start the MongoDB service
sudo service mongod start

# Specify the MongoDB connection details
# IP PRIVADO DA MAQUINA NO MONGO_HOST
MONGO_HOST="10.0.10.10"
MONGO_PORT="27017"
MONGO_DB="WCD_project2"
COLLECTION_NAME="nhl_stats_2022"
CSV_FILE="nhl-stats-2022.csv"

# Use mongoimport to import the CSV file into the specified MongoDB collection
sudo mongoimport --host $MONGO_HOST --port $MONGO_PORT --db $MONGO_DB --collection $COLLECTION_NAME --type csv --headerline --file $CSV_FILE