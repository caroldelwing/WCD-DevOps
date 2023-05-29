#!/bin/bash

REGION="us-east-1"
SUBNET_PUBLIC_AZ="us-east-1a"

#Create VPC
VPC_ID=$(aws ec2 create-vpc \
--cidr-block 10.0.0.0/16 \
--tag-specification 'ResourceType=vpc,Tags=[{Key=Name,Value=vpc_project1}, {Key=project,Value=wecloud}]' \
--region $REGION \
--output text \
--query 'Vpc.VpcId')

echo "VPC $VPC_ID created successfully."

#Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway \
--tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=igw-project1}, {Key=project,Value=wecloud}]' \
--output text \
--query 'InternetGateway.InternetGatewayId')

echo "IGW $IGW_ID created successfully."

#Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway \
--internet-gateway-id $IGW_ID \
--vpc-id $VPC_ID

echo "IGW $IGW_ID successfully attached to VPC $VPC_ID."

#Create public subnet
SUBNET_ID=$(aws ec2 create-subnet \
--vpc-id $VPC_ID \
--cidr-block 10.0.0.0/24 \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=subnet_project1}, {Key=project,Value=wecloud}]' \
--availability-zone $SUBNET_PUBLIC_AZ \
--region $REGION \
--output text \
--query 'Subnet.SubnetId')

echo "Subnet $SUBNET_ID created successfully."

#Enable subnet to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID --map-public-ip-on-launch
echo "Public IP auto-assign enabled successfully."

#Create route table
RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --output text --query 'RouteTable.RouteTableId' \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=rt_project1}, {Key=project,Value=wecloud}]')

echo "Route Table $RT_ID created successfully."

#Create route to internet gateway
aws ec2 create-route --route-table-id $RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID

echo "Route to the IGW $IGW_ID created successfully."

#Associate the subnet with the route table
aws ec2 associate-route-table --subnet-id $SUBNET_ID --route-table-id $RT_ID

echo "Subnet $SUBNET_ID associated with route table $RT_ID."

#Create security group
SG_ID=$(aws ec2 create-security-group \
    --group-name project1_sg \
    --description "SG to allow SSH Access" \
    --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=sg_project1}, {Key=project,Value=wecloud}]' \
    --vpc-id $VPC_ID \
    --output text \
    --query 'GroupId')

echo "Security group $SG_ID created successfully."


#Enable the security group to allow SSH access
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

echo "Security group $SG_ID authorized for SSH ingress."

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
    --subnet-id $SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=master-node-01}, {Key=project,Value=wecloud}]' \
    --user-data file://User-data.sh \
    --security-group-ids $SG_ID \
    --output text \
    --query 'Instances[0].InstanceId')

echo "Instance Master Node $MASTER_NODE created successfully."

#Create EC2 Instance Worker-Node-1
WORKER_NODE1=$(aws ec2 run-instances \
    --image-id ami-0aa2b7722dc1b5612 \
    --count 1 \
    --instance-type t2.micro \
    --key-name project1_key \
    --subnet-id $SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=worker-node-01}, {Key=project,Value=wecloud}]' \
    --user-data file://User-data.sh \
    --security-group-ids $SG_ID \
    --output text \
    --query 'Instance.InstanceId')

echo "Instance Worker Node 1 $WORKER_NODE1 created successfully."

#Create EC2 Instance Worker-Node-2
WORKER_NODE2=$(aws ec2 run-instances \
    --image-id ami-0aa2b7722dc1b5612 \
    --count 1 \
    --instance-type t2.micro \
    --key-name project1_key \
    --subnet-id $SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=worker-node-02}, {Key=project,Value=wecloud}]' \
    --user-data file://User-data.sh \
    --security-group-ids $SG_ID \
    --output text \
    --query 'Instance.InstanceId')

echo "Instance Worker Node 2 $WORKER_NODE2 created successfully."