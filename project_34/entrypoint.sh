#!/bin/bash

#Start MongoDB
docker-entrypoint.sh mongod &

#Wait for MongoDB to start
sleep 30

#MongoDB connection variables
MONGO_PORT="27017"
MONGO_DB="WCD_project2"
COLLECTION_NAME="nhl_stats_2022"
CSV_FILE="nhl-stats-2022.csv"

#Import the CSV file into the MongoDB collection
mongoimport --host db --port $MONGO_PORT --db $MONGO_DB --collection $COLLECTION_NAME --type csv --headerline --file $CSV_FILE

#Keep the container running
tail -f /dev/null