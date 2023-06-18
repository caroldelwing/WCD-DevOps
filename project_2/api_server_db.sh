#!/bin/bash

REGION="us-east-1"
SUBNET1_PUBLIC_AZ="us-east-1a"
SUBNET2_PUBLIC_AZ="us-east-1b"

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

#Create Public Subnet 1
SUBNET1_PUBLIC=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.0.0/24 \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=public_subnet1_project2}, {Key=project,Value=wecloud}]' \
    --availability-zone $SUBNET1_PUBLIC_AZ \
    --region $REGION \
    --output text \
    --query 'Subnet.SubnetId')
echo "Subnet $SUBNET1_PUBLIC created successfully."

#Enable public subnet1 to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $SUBNET1_PUBLIC --map-public-ip-on-launch
echo "Public IP auto-assign enabled successfully."

#Create public route table
RT_PUBLIC=$(aws ec2 create-route-table --vpc-id $VPC_ID --output text --query 'RouteTable.RouteTableId' \
    --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=public_rt_project2}, {Key=project,Value=wecloud}]')
echo "Route Table $RT_PUBLIC created successfully."

#Create route to internet gateway
aws ec2 create-route --route-table-id $RT_PUBLIC --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
echo "Route to the IGW $IGW_ID created successfully."

#Associate the public subnet 1 with the route table
aws ec2 associate-route-table --subnet-id $SUBNET1_PUBLIC --route-table-id $RT_PUBLIC
echo "Subnet $SUBNET1_PUBLIC associated with route table $RT_PUBLIC."

#Create Public Subnet 2
SUBNET2_PUBLIC=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.9.0/24 \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=public_subnet2_project2}, {Key=project,Value=wecloud}]' \
    --availability-zone $SUBNET2_PUBLIC_AZ \
    --region $REGION \
    --output text \
    --query 'Subnet.SubnetId')
echo "Subnet $SUBNET2_PUBLIC created successfully."

#Enable public subnet2 to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $SUBNET2_PUBLIC --map-public-ip-on-launch
echo "Public IP auto-assign enabled successfully."

#Associate the public subnet 2 with the route table
aws ec2 associate-route-table --subnet-id $SUBNET2_PUBLIC --route-table-id $RT_PUBLIC
echo "Subnet $SUBNET2_PUBLIC associated with route table $RT_PUBLIC."

#Create private subnet
SUBNET_PRIVATE=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.10.0/24 \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private_subnet_project2}, {Key=project,Value=wecloud}]' \
    --availability-zone $SUBNET1_PUBLIC_AZ \
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

#Create key-pair
aws ec2 create-key-pair \
    --key-name project2_key \
    --key-type rsa \
    --query 'KeyMaterial' \
    --output text \
    > project2_key.pem 
echo "Key-pair 'project2_key.pem' created successfully."

#Create ALB Security Group
SG_ALB_ID=$(aws ec2 create-security-group \
    --group-name project2_alb_sg \
    --description "Application Load Balancer sg" \
    --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=project2_alb_sg}, {Key=project,Value=wecloud}]' \
    --vpc-id $VPC_ID \
    --output text \
    --query 'GroupId')
echo "Security group $SG_ALB_ID created successfully."

#Enable the ALB security group to allow HTTP, HTTPS access from anywhere
aws ec2 authorize-security-group-ingress --group-id $SG_ALB_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ALB_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
echo "Security group $SG_ALB_ID authorized for HTTP and HTTPS ingress."

#Create Application Security Group
SG_APP_ID=$(aws ec2 create-security-group \
    --group-name project2_app_sg \
    --description "Application sg" \
    --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=project2_app_sg}, {Key=project,Value=wecloud}]' \
    --vpc-id $VPC_ID \
    --output text \
    --query 'GroupId')
echo "Security group $SG_APP_ID created successfully."

#Enable the APP security group to allow HTTP, HTTPS, and port 3000 access from the ALB SG
aws ec2 authorize-security-group-ingress --group-id $SG_APP_ID --protocol tcp --port 80 --source-group $SG_ALB_ID
aws ec2 authorize-security-group-ingress --group-id $SG_APP_ID --protocol tcp --port 443 --source-group $SG_ALB_ID
aws ec2 authorize-security-group-ingress --group-id $SG_APP_ID --protocol tcp --port 3000 --source-group $SG_ALB_ID
echo "Security group $SG_APP_ID authorized for HTTP and HTTPS ingress from the ALB SG."

#Allocate the Elastic IP
EIP_ALLOC_ID=$(aws ec2 allocate-address \
    --query 'AllocationId' --output text)
echo "Elastic IP allocated successfully."

#Create a NAT Gateway
NAT_GW_ID=$(aws ec2 create-nat-gateway \
    --subnet-id $SUBNET1_PUBLIC \
    --allocation-id $EIP_ALLOC_ID \
    --query 'NatGateway.NatGatewayId' \
    --output text)
echo "NAT Gateway $NAT_GW_ID created successfully."

#Wait for the NAT Gateway to be available
echo "Waiting for NAT Gateway to be available..."
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_ID
echo "NAT Gateway available to be used."

#Add a route to the NAT Gateway in the private route table
aws ec2 create-route --route-table-id $RT_PRIVATE --destination-cidr-block 0.0.0.0/0 --gateway-id $NAT_GW_ID
echo "Route created in the private subnet to the NAT Gateway."

#Create Database Security Group
SG_DB_ID=$(aws ec2 create-security-group \
    --group-name project2_db_sg \
    --description "Database sg" \
    --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=project2_db_sg}, {Key=project,Value=wecloud}]' \
    --vpc-id $VPC_ID \
    --output text \
    --query 'GroupId')
echo "Security group $SG_DB_ID created successfully."

#Enable the DB security group to allow access from the APP SG.
aws ec2 authorize-security-group-ingress --group-id $SG_DB_ID --protocol tcp --port 27017 --source-group $SG_APP_ID
echo "Security group $SG_DB_ID authorized for ingress from the APP SG."

#Enable the APP security group to allow access from the DB SG.
aws ec2 authorize-security-group-ingress --group-id $SG_APP_ID --protocol tcp --port 27017 --source-group $SG_DB_ID
echo "Security group $SG_APP_ID authorized for ingress from the DB SG."

#Create EC2 Instance Database
DB_EC2=$(aws ec2 run-instances \
    --image-id ami-0aa2b7722dc1b5612 \
    --count 1 \
    --instance-type t2.micro \
    --key-name project2_key \
    --subnet-id $SUBNET_PRIVATE \
    --private-ip-address 10.0.10.10 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=db-ec2}, {Key=project,Value=wecloud}]' \
    --user-data file://userdata.sh \
    --security-group-ids $SG_DB_ID \
    --output text \
    --query 'Instances[0].InstanceId')
echo "Instance Database $DB_EC2 created successfully."

#Create a target group and retrieve the ARN
TG_ARN=$(aws elbv2 create-target-group --name project2-target-group \
    --protocol HTTP \
    --port 3000 \
    --vpc-id $VPC_ID \
    --tags "Key=Name,Value=target_group_project2" "Key=Project,Value=wecloud" \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)
echo "Target group $TG_ARN created successfully."

#Create the Application Load Balancer
ALB_ARN=$(aws elbv2 create-load-balancer --name project2-load-balancer \
    --subnets $SUBNET1_PUBLIC $SUBNET2_PUBLIC \
    --security-groups $SG_ALB_ID \
    --type application \
    --tags "Key=Name,Value=alb_project2" "Key=Project,Value=wecloud" \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)
echo "ALB $ALB_ARN created successfully."

#Create a listener for the load balancer
aws elbv2 create-listener --load-balancer-arn $ALB_ARN \
    --protocol HTTP \
    --port 80 \
    --tags "Key=Name,Value=listener_project2" "Key=Project,Value=wecloud" \
    --default-actions Type=forward,TargetGroupArn=$TG_ARN
echo "Listener for the ALB created successfully."

#Create a launch template
LAUNCH_TEMPLATE_ID=$(aws ec2 create-launch-template --launch-template-name project2-launch-template \
    --launch-template-data "ImageId=ami-0aa2b7722dc1b5612,InstanceType=t2.micro,SecurityGroupIds=$SG_APP_ID,KeyName=project2_key,UserData=$(base64 -w 0 userdata_app.sh)" \
    --tag-specifications 'ResourceType=launch-template,Tags=[{Key=Name,Value=launchtemp_project2}, {Key=project,Value=wecloud}]' \
    --query 'LaunchTemplate.LaunchTemplateId' \
    --output text)  
echo "Launch template $LAUNCH_TEMPLATE_ID created successfully."

#Create an Auto Scaling group
aws autoscaling create-auto-scaling-group --auto-scaling-group-name project2-scaling-group \
    --launch-template "LaunchTemplateId=$LAUNCH_TEMPLATE_ID,Version=1" \
    --min-size 2 \
    --max-size 4 \
    --desired-capacity 2 \
    --target-group-arns $TG_ARN \
    --vpc-zone-identifier $SUBNET1_PUBLIC,$SUBNET2_PUBLIC \
    --tags "Key=Name,Value=asg_project2" "Key=Project,Value=wecloud" \
    --default-cooldown 300
echo "Auto scaling group created successfully."

#Create an scaling policy base on CPU Utilization
aws autoscaling put-scaling-policy --policy-name cpu-scaling-policy \
    --auto-scaling-group-name project2-scaling-group \
    --policy-type TargetTrackingScaling \
    --target-tracking-configuration "PredefinedMetricSpecification={PredefinedMetricType=ASGAverageCPUUtilization},TargetValue=80"
