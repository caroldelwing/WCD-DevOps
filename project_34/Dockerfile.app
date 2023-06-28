#Base image and multi-stage build
FROM node:14-alpine as build
#Set the working dir
WORKDIR /app
#Copy package.json to the working dir
COPY package.json ./
#Install the dependencies
RUN npm install
#Copy the rest of the application code and packages
COPY . .
#Starts the next stage of the dockerfile
FROM build as prod
#Expose the app port
EXPOSE 3000
#Start the app
CMD ["npm", "start"]