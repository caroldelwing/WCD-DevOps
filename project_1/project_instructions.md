# Project 1 - Linux Servers on AWS

Due date: June 4, 2023

In this project, students will work in a team to deploy AWS cloud infrastructure using the AWS CLI command line tool in bash shell scripts. Specifically, the AWS cloud environment will have a VPC, internet gateway, public subnet, public route table, EC2 instances. These scripts will be stored in GitHub.

## Requirements

1. Create bash shell script(s) that leverages the AWS CLI tool to create the following cloud architecture and set up:
   1. All resources to be in us-east-1
   2. VPC
   3. Internet gateway
      1. Internet gateway attached to VPC
   4. Public subnet
   5. Enable auto-assign public IP on public subnet
   6. Public route table for pubilc subnet
      1. Route table has a routing rule to internet gateway
   7. Associate the public subnet with the public route table
   8. EC2 instances
      1. Master node 1
         1. Size: t2.small
         2. Image: Ubuntu 20.04
         3. Installed software
            1. Python 3.10
            2. Node 18.0
            3. Java 11.0
            4. Docker engine
         4. Tag `key=Name ,value=master-node-01`
      2. Worker node 1
         1. Size: t2.micro
         2. Image: Ubuntu 20.04
         3. Installed software
            1. Python 3.10
            2. Node 18.0
            3. Java 11.0
            4. Docker engine
         4. Tag `key=Name ,value=worker-node-01`
      3. Worker node 2
         1. Size: t2.micro
         2. Image: Ubuntu 20.04
         3. Installed software
            1. Python 3.10
            2. Node 18.0
            3. Java 11.0
            4. Docker engine
         4. Tag `key=Name ,value=worker-node-02`
   9. All three EC2 instances are
      1. In the same public subnet and VPC,
      2. Are reachable to each other - e.g. via the ping command
      3. Are accessible remotely by SSH
      4. All resources created are tagged: `key=project ,value=wecloud`
2. The scripts are stored in a public GitHub repo
3. Architectural diagram depicting the AWS cloud infrastructure setup
4. A README.md file in the GitHub repo c ontaining
   1. URL to public GitHub repo
      1. Instructions on how to run the scripts and deploy the cloud infrastructure
   2. Pertinent diagrams

## Submission Instructions

Download a zip of your completed GitHub repo
Click on Hand In tab in the learning portal project page
Click on Upload Assignment and upload the zip file
