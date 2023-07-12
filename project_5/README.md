# Projects 5 - Containerizing an Application & Docker-Compose

This project deploys a web app onto a cloud production Kubernetes cluster that can be consumed by user on the public internet. The orchestration of the app containers is done using the AWS's managed Kubernetes service AWS Elastic Kubernetes Service (EKS).

This repository is composed of two Deployment files (app-deployment.yaml, mongo-deployment.yaml), and two service files (app-service.yaml, monog-service.yaml)

URL for the public GitHub repository: https://github.com/caroldelwing/WCD-DevOps

## Table of contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Testing the Results](#testing-the-results)
- [Authors](#authors)

## Prerequisites

- AWS account;
- Required IAM permissions to work with Amazon EKS IAM roles;
- Access to a terminal;
- Have AWS CLI and kubectl installed in your terminal;
- Basic knowledge of Kubernets, AWS EKS and Git. 

## Getting Started

Set up the AWS EKS infrastructure:
-  Create VPC for the Worker Nodes using a CloudFormation Template (private and public subnets)
https://docs.aws.amazon.com/eks/latest/userguide/creating-a-vpc.html
- Create a cluster IAM role and attach the required Amazon EKS IAM managed policy to it.
- Create the EKS Cluster:
	- Give it a name, latest version, and select the EKS IAM Role
	- Select the created VPC, subnets, and security group
	- Set the cluster endpoint access as Public and Private
	- Leave the other options as default and create the cluster (it takes about 15 minutes)
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html#eks-launch-workers
- Connect Kubectl with your EKS Cluster
	- In your terminal, run aws configure (use the same user that created the EKS Cluster on the console) and install kubectl
	- Then, run aws eks update-kubeconfig --name EKS-Lab --region us-east-1
	- Test it with kubectl cluster-info
If you get an error, you might find the answer here:
https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html#unauthorized
- Create an EC2 IAM Role for Node Group
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html#eks-launch-workers
- reate the Node Group
	- In the EKS Cluster page, select your cluster, then click on Compute, and add a Node Group
	- Give it a name, select the Node Group IAM role, and click on next
	- Select the Amazon Linux 2 AMI, On-Demand capacity, t2.micro size, 20GiB disk size, and click on next
	- Enable remote access, select your SSH key-pair (it might be useful for troubleshooting), and allow SSH remote access from all
	- Click on next, review, and create (it takes a few minutes)
 
## Installation

To install required tools follow the steps in the links bellow :

- AWS CLI:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

- Git:
  https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

- Kubectl:
  https://kubernetes.io/docs/tasks/tools/

## Usage

- Clone the repository:
```sh
$ git clone https://github.com/caroldelwing/WCD-DevOps.git
```

- Inside project 5 folder deploy the application following the order bellow:
```sh
kubectl -f apply mongo-service.yaml
kubectl -f apply mongo-deployment.yaml
kubectl -f apply app-service.yaml
kubectl -f apply app-deployment.yaml
```
## Testing the Results

 In your terminal use the following command to get the external ip of the load balancer:
 ```sh
kubectl get services
```
Paste the load balancer external ip in your browser and add the desire route. 

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
