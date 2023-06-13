#!/bin/bash

# Import the MongoDB GPG public key
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

# Create a MongoDB repository file
echo "deb [arch=amd64] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# Update the package list
sudo apt update

# Install git
sudo apt install git -y

# Install MongoDB
sudo apt install -y mongodb-org

# Install Mongosh
sudo npm install -g mongosh

# Clone the project repository
git clone https://github.com/caroldelwing/WCD-DevOps
cd WCD-DevOps/project_2

# Start the MongoDB service
sudo service mongod start
 
# Specify the MongoDB connection details
MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_DB="WCD_project2"
COLLECTION_NAME="nhl_stats_2022"
CSV_FILE="nhl-stats-2022.csv"

# Use mongoimport to import the CSV file into the specified MongoDB collection
mongoimport --host $MONGO_HOST --port $MONGO_PORT --db $MONGO_DB --collection $COLLECTION_NAME --type csv --headerline --file $CSV_FILE

