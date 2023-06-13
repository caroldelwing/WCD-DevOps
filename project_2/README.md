# Project 2 - API Server and Databases

In this project you will deploy an API microservice connected to a database. This API will have exposed endpoints that users can send HTTP requests to and get a response. Data will be returned to users as JSON payloads. AWS cloud infrastructure using the AWS CLI command line tool in bash shell scripts. Specifically, the AWS cloud environment will have a VPC, internet gateway, public subnet, public route table, EC2 instances.

URL for the public GitHub repo: https://github.com/caroldelwing/WCD-DevOps/tree/main/project_2

## Table of contents

- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Testing the Results](#testing-the-results)
- [Authors](#authors)

## Getting Started

To be able to run the script, you'll need an AWS account, an IAM (Identity and Access Management) user with the right permissions, and a secret access key (download the file with your secret access key, you'll need it later). We used a user with the 'AdministratorAcess' policy attached. For more info about IAM users and secret access keys, go to:
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html
https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html

Once the user is created on the AWS Console, open a new Linux terminal in your machine, and install AWS CLI.

Use the following command to install AWS CLI:

```sh
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
```

Access the following link for more info about how to install AWS CLI:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

To access your AWS account, execute the following command in your terminal:

```sh
$ aws configure
AWS Access Key ID [None]: paste your access key id
AWS Secret Access Key [None]: paste your secret access key
Default region name [None]: us-east-1
Default output format [None]:
```
## Installation

Option 1: Clone this repository. For this option, you will need to install git on your terminal first, then clone the repository:

To install Git, please go to this link and follow the steps:
https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

Cloning the repository:

```sh
$ git clone https://github.com/caroldelwing/WCD-DevOps
```

Option 2: Download the scripts and save in your local machine.

## Usage

To execute the script, in your terminal, navigate to the folder where the scripts are stored. Then, grant execution permission to both main (api_server_db.sh) and auxiliary (userdata.sh, userdata_app.sh) scripts. Lastly, execute the main script.

Running the script:

```sh
$ chmod +x api_server_db.sh userdata.sh userdata_app.sh
$ ./api_server_db.sh
```

The main script is responsible for creating the cloud architecture,the infraestructure to run our application. The userdata.sh auxiliary script is responsible to install mongo db and create our database and collection using data from a csv file. The userdata_app.sh script is respnsible for calling and runing the js application. 

##Testing the Results   



## Authors

- Beatriz Carvalho de Oliveira - https://github.com/beatrizCarvalhoOliveira
- Carolina Delwing Rosa - https://github.com/caroldelwing
- Zakiir Juman - https://github.com/zakiirjuman
