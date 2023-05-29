# Project 1 - Linux Server on Aws 
Bash shell scripts to deploy AWS cloud infrastructure using the AWS CLI command line tool. The AWS cloud environment will have a VPC, internet gateway, public subnet, public route table, EC2 instances.

## Table of contents 
  - [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Authors](#authors)


## Getting Started 
To run these scripts you will have to first install AWS CLI on a linux terminal and configure users security credentians on aws. 

Use following command to install AWS CLI: 
```sh
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
```

To configure users security credentials:
First, create an account on aws.com and loggin in as root user. Search for IAM on search bar and then create an userwith admnistrator access policy and the create an access key.Copy the acces key and secret access key generated on a notepad.
Then use following comand to access your aws account: 

```sh
$ aws configure
AWS Access Key ID [None]: paste access key id generated 
AWS Secret Access Key [None]: paste secret access key generated
Default region name [None]: us-east-1
Default output format [None]: 
```

## Installation 
 Option 1: Clone this repository. For this option you will need to install git on your terminal first, then clone the repository: 
 
 Git Installation:
 ```sh
 $ sudo apt-get install git
 ```
 Cloning Repository: 
 ```sh
 $ git clone https://github.com/caroldelwing/WCD-DevOps/tree/project_1_dev/project_1
 ```
 Option 2: Download the scripts and save in your local machine.
 
 ## Usage 
 
 Run the scripts by using bash and file name: 
 ```sh
 $bash linux_server_aws_setup.sh
 $bash userdata.sh 
```

## Authors 
- Beatriz Carvalho de Oliveira - https://github.com/beatrizCarvalhoOliveira
- Carol Delwing - https://github.com/caroldelwing
- Zakiir Juman - https://github.com/zakiirjuman
