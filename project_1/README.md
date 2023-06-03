# Project 1 - Linux Server on Aws

This project deploys an AWS cloud infrastructure using the AWS CLI command line tool and a Bash Shell script. The AWS cloud environment has a VPC, internet gateway, public subnet, public route table, and three EC2 instances. The EC2 instances must be in the same public subnet and VPC, reachable to each other, and accessible remotely by SSH. Moreover, the instances must have Python 3.10, Node 18.0, Java 11.0, and Docker engine installed.

URL for the public GitHub repo: https://github.com/caroldelwing/WCD-DevOps/tree/main/project_1

## Table of contents

- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Removal](#removal)
- [Network Diagram](#network-diagram)
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

To execute the script, in your terminal, navigate to the folder where the scripts are stored. Then, grant execution permission to both main (linux_server_aws_setup.sh) and auxiliary (userdata.sh) scripts. Lastly, execute the main script.

The main script is responsible for creating the cloud architecture, while the auxiliary script is responsible for installing the required software in each EC2 instance.

Running the script:

```sh
$ chmod +x linux_server_aws_setup.sh userdata.sh cleanup.sh
$ ./linux_server_aws_setup.sh
```

After executing the script, go to the AWS Console in the us-east-1 region, and you will be able to see the EC2 instances running. Wait for the Status Checks to be completed to check the version of the software installed in each instance.
If you want to rerun the same script, firstly you'll have to manually delete the created SSH key pair on the AWS Console and in your machine.

## Removal

You can try using `./cleanup.sh` to remove resources that are associated with the VPC. The script targets resources with `--filters "Name=tag:project,Values=wecloud"`.

## Network Diagram

![Screenshot of the project 1 network diagram.](/project_1/project1_network_diagram.png)

## Authors

- Beatriz Carvalho de Oliveira - https://github.com/beatrizCarvalhoOliveira
- Carolina Delwing Rosa - https://github.com/caroldelwing
- Zakiir Juman - https://github.com/zakiirjuman
