#!/bin/bash
sudo apt update -y
sudo apt install -y curl git nodejs npm
git clone https://github.com/caroldelwing/WCD-DevOps.git
cd WCD-DevOps/project_2
npm install
TESTDB_HOST=testdb DB_HOST=10.0.10.10 DB_PORT=27017 DB_NAME=WCD_project2 npm run start:dev
