#!/bin/bash

# Specify the MongoDB connection details
MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_DB="WCD_project2"
COLLECTION_NAME="nhl_stats_2022"
CSV_FILE="/home/ubuntu/WCD-DevOps/project_2/nhl-stats-2022.csv"

# Use mongoimport to import the CSV file into the specified MongoDB collection
mongoimport --host $MONGO_HOST --port $MONGO_PORT --db $MONGO_DB --collection $COLLECTION_NAME --type csv --headerline --file $CSV_FILE

