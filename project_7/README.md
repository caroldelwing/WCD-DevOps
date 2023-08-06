# Projects 7 -  Infrastructure Provisioning Automation

This project deploys AWS infrastructure using infrastructure provisioning automation tools.The infrastructures that are deployed will then be used to host web apps.In this project, Ansible is used to set up the API and database infrastructure, and start up a Jenkins server inside a EC2. And Terraform is used to drploy a entire AWS EKS cluster.  

This repository is composed of to Deployment YAML files (app-deployment.yaml, mongo-deployment.yaml), two service YAML files (app-service.yaml, mongo-service.yaml), three ansible playbooks (infra.ansible.yaml, jenkins.ansible.yaml,jenkinsinfra.ansible.yaml), two bash scripts (userdata.sh , userdata_app.sh) and six terraform configuration files (eks-cluster.tf, main.tf, outputs.tf, terraform.tf, variable.tf, vpc.tf).

URL for the public GitHub repository: [https://github.com/caroldelwing/WCD-DevOps/tree/main/project_7]

## Table of contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Testing the Results](#testing-the-results)
- [Authors](#authors)

## Prerequisites

- AWS account;
- IAM user with sufficient rights;
- Access to a linux terminal;
- Have AWS CLI, git , python3, pip, botocore, boto3, ansible and  installed on your machine;
- Basic knowledge of Ansible, Terraform, AWS EKS, and Git. 

## Installation

To install the required tools, follow the steps in the links below:

- AWS CLI:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

- Git:
https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

- Ansible:
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

- Terraform:
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

- Python3, pip, botocore, boto3:
```sh
#Python3
sudo apt update
sudo apt install python3

#pip
sudo apt install python3-pip

#botocore and boto3
pip3 install botocore boto3
```


## Getting Started

- To have access to your AWS account through your IAM user, execute the following command in your terminal
```sh
$ aws configure
AWS Access Key ID [None]: paste your access key id
AWS Secret Access Key [None]: paste your secret access key
Default region name [None]: us-east-1
Default output format [None]:
```

-Clone this repository and open project 7 directory:
```
git clone https://github.com/caroldelwing/WCD-DevOps

#change directory:
cd WCD-DevOps/project7
```
 Make sure your path to project 7 is home/ubuntu/WCD-DevOps/project_7

## Usage

- Execute the ansible playbooks in the following order:
```sh
ansible-playbook infra.ansible.yaml
ansible-playbook jenkinsinfra.ansible.yaml
ansible-playbook -i hosts jenkins.ansible.yaml
```

- Deploy cluster with terraform:
```sh
terraform init
```
```sh
terraform validate
```
```sh
terraform plan
```
```sh
terraform apply -auto-approve
```

## Testing the Results

Copy the public IP of your EC2 instance, and paste it on your web browser according to the model below, editing the route according to the desired output:
<PublicIPV4>:3000/

Available routes:

- `/` - returns all documents in the nhl_stats_2022 collection.
- `/players/top/:number` - returns top players. For example, /players/top/10 will return the top 10 players leading in points scored.
- `/players/team/:teamname` - returns all players of a team. For example, /players/team/TOR will return all players of Toronto Maple Leafs.
- `/teams` - returns a list of the teams.

## Diagram



## Authors

- Beatriz Carvalho de Oliveira - https://github.com/beatrizCarvalhoOliveira
- Carolina Delwing Rosa - https://github.com/caroldelwing
- Zakiir Juman - https://github.com/zakiirjuman
