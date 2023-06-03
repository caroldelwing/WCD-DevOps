#!/bin/bash

#HEY! If you're on a mac make sure that you're using bash and not zsh, the read command will not work in zsh.

export AWS_PAGER=""

REGION="us-east-1"
SUBNET_PUBLIC_AZ="us-east-1a"

instance_ids=$(aws ec2 describe-instances \
    --filters "Name=tag:project,Values=wecloud" \
    --query 'Reservations[*].Instances[*].InstanceId' \
    --output text)

echo "$instance_ids" | xargs -I {} aws ec2 terminate-instances --instance-ids {}

for id in $instance_ids; do
    aws ec2 wait instance-terminated --instance-ids $id
done


# List all internet gateways with tag project=wecloud and detach
gateway_output=$(aws ec2 describe-internet-gateways --filters "Name=tag:project,Values=wecloud" --query 'InternetGateways[*].InternetGatewayId' --output text)
IFS=$'\t' read -ra gateways <<< "$gateway_output"
for gateway in "${gateways[@]}"
do
  echo "Processing $gateway"
  vpc_output=$(aws ec2 describe-internet-gateways --internet-gateway-ids "$gateway" --query 'InternetGateways[*].Attachments[*].VpcId' --output text)
  IFS=$'\t' read -ra attached_vpcs <<< "$vpc_output"
  for vpc in "${attached_vpcs[@]}"
  do
    echo "Detaching $gateway from $vpc"
    aws ec2 detach-internet-gateway --internet-gateway-id "$gateway" --vpc-id "$vpc"
  done
done

#List all internet gateways with tag project=wecloud and delete
aws ec2 describe-internet-gateways \
    --filters "Name=tag:project,Values=wecloud" \
    --query 'InternetGateways[*].InternetGatewayId' \
    --output text | tr '\t' '\n' | xargs -I {} aws ec2 delete-internet-gateway \
    --internet-gateway-id {}

#List the associations with the route table tagged with project=wecloud and disassociate
aws ec2 describe-route-tables \
    --filters "Name=tag:project,Values=wecloud" \
    --query 'RouteTables[*].Associations[].RouteTableAssociationId' \
    --output text | tr '\t' '\n' | xargs -I {} aws ec2 disassociate-route-table --association-id {}

#List the route tables tagged with project=wecloud and delete them
aws ec2 describe-route-tables \
    --filters "Name=tag:project,Values=wecloud" \
    --query 'RouteTables[*].RouteTableId' \
    --output text | tr '\t' '\n' | xargs -I {} aws ec2 delete-route-table --route-table-id {}

#List the subnets tagged with project=wecloud and delete them
aws ec2 describe-subnets \
    --filters "Name=tag:project,Values=wecloud" \
    --query 'Subnets[*].SubnetId' \
    --output text | tr '\t' '\n' | xargs -I {} aws ec2 delete-subnet \
    --subnet-id {}

#List the security groups tagged with project=wecloud and delete them
aws ec2 describe-security-groups \
    --filters "Name=tag:project,Values=wecloud" \
    --query 'SecurityGroups[*].GroupId' \
    --output text | tr '\t' '\n' | xargs -I {} aws ec2 delete-security-group \
    --group-id {}

#List vpcs that are tagged with project=wecloud and delete them
aws ec2 describe-vpcs \
    --filters "Name=tag:project,Values=wecloud" \
    --query 'Vpcs[*].VpcId' \
    --output text | tr '\t' '\n' | xargs -I {} aws ec2 delete-vpc \
    --vpc-id {}

echo "Cleanup complete. Still, double check your resources and remember delete your keys!"