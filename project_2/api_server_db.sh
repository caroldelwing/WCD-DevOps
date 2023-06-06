#!/bin/bash

REGION="us-east-1"
SUBNET_PUBLIC_AZ="us-east-1a"

#Create VPC
VPC_ID=$(aws ec2 create-vpc \
--cidr-block 10.0.0.0/16 \
--tag-specification 'ResourceType=vpc,Tags=[{Key=Name,Value=vpc_project2}, {Key=project,Value=wecloud}]' \
--region $REGION \
--output text \
--query 'Vpc.VpcId')

echo "VPC $VPC_ID created successfully."

#Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway \
--tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=igw-project2}, {Key=project,Value=wecloud}]' \
--output text \
--query 'InternetGateway.InternetGatewayId')

echo "IGW $IGW_ID created successfully."

#Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway \
--internet-gateway-id $IGW_ID \
--vpc-id $VPC_ID

echo "IGW $IGW_ID successfully attached to VPC $VPC_ID."

#Create public subnet
SUBNET_PUBLIC=$(aws ec2 create-subnet \
--vpc-id $VPC_ID \
--cidr-block 10.0.0.0/24 \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=public_subnet_project2}, {Key=project,Value=wecloud}]' \
--availability-zone $SUBNET_PUBLIC_AZ \
--region $REGION \
--output text \
--query 'Subnet.SubnetId')

echo "Subnet $SUBNET_PUBLIC created successfully."

#Enable subnet to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUBLIC --map-public-ip-on-launch
echo "Public IP auto-assign enabled successfully."

#Create public route table
RT_PUBLIC=$(aws ec2 create-route-table --vpc-id $VPC_ID --output text --query 'RouteTable.RouteTableId' \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=public_rt_project2}, {Key=project,Value=wecloud}]')

echo "Route Table $RT_PUBLIC created successfully."

#Create route to internet gateway
aws ec2 create-route --route-table-id $RT_PUBLIC --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID

echo "Route to the IGW $IGW_ID created successfully."

#Associate the public subnet with the route table
aws ec2 associate-route-table --subnet-id $SUBNET_PUBLIC --route-table-id $RT_PUBLIC

echo "Subnet $SUBNET_PUBLIC associated with route table $RT_PUBLIC."

#Create private subnet
SUBNET_PRIVATE=$(aws ec2 create-subnet \
--vpc-id $VPC_ID \
--cidr-block 10.0.10.0/24 \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private_subnet_project2}, {Key=project,Value=wecloud}]' \
--availability-zone $SUBNET_PUBLIC_AZ \
--region $REGION \
--output text \
--query 'Subnet.SubnetId')

echo "Subnet $SUBNET_PRIVATE created successfully."

#Create private route table
RT_PRIVATE=$(aws ec2 create-route-table --vpc-id $VPC_ID --output text --query 'RouteTable.RouteTableId' \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=private_rt_project2}, {Key=project,Value=wecloud}]')

#Associate the private subnet with the private route table
aws ec2 associate-route-table --subnet-id $SUBNET_PRIVATE --route-table-id $RT_PRIVATE

echo "Subnet $SUBNET_PRIVATE associated with route table $RT_PRIVATE."

##################### The basic AWS infra was created: the VPC, public and private subnets, internet gateway, 
##################### public and private route tables.
##################### Now we need: 1) create a ec2 instance (what size?) inside the private subnet, create 
##################### a user data script to install the DB on EC2 launch, create the security group.
##################### 2) Create an auto scaling group (ASG) with 3 max EC2 instances (I think is enough) in the 
##################### public subnet, create a user data script to install the API server inside the ASG instances,
##################### create a SG for the ASG, create an Application Load Balancer (ALB) with endpoints + SG,
##################### create a NAT/Bastion Host instance inside the public subnet to access the db + SG, create an UI
##################### instance to interact with users (confused about this) + SG.





##################### From this point, is the old script. But we still can use it
##################### in this project

#Create security group
SG_ID=$(aws ec2 create-security-group \
    --group-name project1_sg \
    --description "SG to allow SSH Access" \
    --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=sg_project1}, {Key=project,Value=wecloud}]' \
    --vpc-id $VPC_ID \
    --output text \
    --query 'GroupId')

echo "Security group $SG_ID created successfully."

#Enable the security group to allow SSH and ICMP access
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol icmp --port -1 --source-group $SG_ID
echo "Security group $SG_ID authorized for SSH and ICMP ingress."

#Create key-pair
aws ec2 create-key-pair \
--key-name project1_key \
--key-type rsa \
--query 'KeyMaterial' \
--output text \
> project1_key.pem 

echo "Key-pair 'project1_key.pem' created successfully." 

#Create EC2 Instance Master-Node-1
MASTER_NODE=$(aws ec2 run-instances \
    --image-id ami-0aa2b7722dc1b5612 \
    --count 1 \
    --instance-type t2.small \
    --key-name project1_key \
    --subnet-id $SUBNET_PUBLIC \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=master-node-01}, {Key=project,Value=wecloud}]' \
    --user-data file://userdata.sh \
    --security-group-ids $SG_ID \
    --output text \
    --query 'Instances[0].InstanceId')

echo "Instance Master Node $MASTER_NODE created successfully."