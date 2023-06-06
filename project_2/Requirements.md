## Requirements

1. Create a database to store some simple data using any data of your choice and using any database server of your choice.
   1. For example you can use the attached NHL data that has data on NHL hockey players, their goals, assists and points.
   2. Some examples of databases you can use to store the data include MySQL, PostgreSQL, MongoDB, etc.
2. Create an API server in any programming language and framework of your choice. Some examples:
   1. FastAPI
   2. Node + Express
   3. Java Springboot
3. Create a few GET endpoints in your API server so users can retrieve data from your database via your API microservice. Some examples of endpoints
   1. /players: Returns the first 10 players from the data, e.g. via query SELECT Player Name FROM nhl LIMIT 10
   2. /toronto: Returns all players from the Toronto Maple Leafs, e.g. via query SELECT Player Name FROM nhl WHERE Team = ‘TOR’ information about the Linux OS
   3. /points: Returns top 10 players leading in points scored, e.g. via query SELECT Player Name,Pts FROM nhl ORDER BY Pts LIMIT 10
4. Deploy your database server and API microservice on the AWS cloud. Since you've already created AWS infrastructure using bash shell scripts from project 1, you can re-use those scripts and modify accordingly to deploy the API and databases if it's convenient to do so.
5. Ensure your API is accessible on the public internet.
6. Create a public GitHub repo to store all your code used in this project.
7. In the README.md of your GitHub repo
   1. Include an architectural diagram of your API and database set up.
   2. Include instructions on how users can use your API service, including available endpoints.
8. Bonus:
   1. If you want to make your API microservice fancy you can create a frontend e.g. Angular, React, Bootstrap, etc. to allow users to interact with your API endpoints. However this is not necessary. Users can hit your endpoints via entering the endpoints as URL’s in the web browser, using Postman, or other API clients, etc.
   2. To add high availability and scalability to your API service you can deploy your API in EC2 instances that are part of an autoscaling group, and add an application load balancer in front. Your users will then hit your API via the application load balancer address.

Note: Sample data file you can use for your database can be found in the tab "Exercise Files". The file is called "nhl-stats-2022.csv".

## Submission Instructions

1. In the README.md of your GitHub repo include the names of members in your group
2. Download a Zip file of your completed GitHub repo
3. Click on Hand In tab in the learning portal project page
4. Click on Upload Assignment and upload the zip file
5. After you have submitted your assignment, make your API service available on the public internet - e.g. turn on your AWS servers that are hosting the API - and notify Nhat with the address to your API server. Nhat will then test some of your endpoints.
