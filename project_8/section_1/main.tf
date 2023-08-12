terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }
}
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  count = 1
  user_data = file("userdata.sh")

  tags = {
    name = "jenkins_project_8"
  }
}

#Create a security group for your Jenkins EC2
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "SG to allow inbound traffic in ports 22, 8080, and 443"

#Allow incoming TCP on port 22 from anywhere
  ingress {
    description = "Incoming SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#Allow incoming TCP on port 8080 from anywhere
  ingress {
    description = "Incoming 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#Allow incoming TCP on port 443 from anywhre
  ingress {
    description = "Incoming 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_sg"
  }
}