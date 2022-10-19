terraform {
  required_providers {
  aws = {
    source = "hashicorp/aws"
    version = "4.33.0"
  }
  }

# To maintain the state at Backend 
  backend "s3" {
  bucket = "terraform-romana-project"
  key    = "state"
  region = "ap-south-1"
  }
}

# Configure the AWS Provider 
provider "aws" {
    region = "ap-south-1"
}

# Create a VPC 
resource "aws_vpc" "project-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Project-vpc"
}
}

# Create Public Subnets 
resource "aws_subnet" "project-subnet-1a-pub" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "project-subnet-1a-pub"
  }
}

resource "aws_subnet" "project-subnet-1b-pub" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "project-subnet-1b-pub"
  }
}

# Create Private Subnets 
resource "aws_subnet" "project-subnet-1a-pvt" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "ap-south-1a"
  # map_public_ip_on_launch = "true"

  tags = {
    Name = "project-subnet-1a-pvt"
  }
}

resource "aws_subnet" "project-subnet-1b-pvt" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "ap-south-1b"
  # map_public_ip_on_launch = "true"

  tags = {
    Name = "project-subnet-1b-pvt"
  }
}

# Creating Internet Gateway 
resource "aws_internet_gateway" "Project-IG" {
  vpc_id = aws_vpc.project-vpc.id

  tags = {
    Name = "Project-IG"
  }
}

# Creating Public Route Table 
resource "aws_route_table" "Project-route-table" {
  vpc_id = aws_vpc.project-vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Project-IG.id  
  }

  tags = {
    Name = "Project-route-table"
  }
}

# Creating Public Route Table Association 
resource "aws_route_table_association" "Project-RT-association-1a" {
  subnet_id      = aws_subnet.project-subnet-1a-pub.id
  route_table_id = aws_route_table.Project-route-table.id 
}

resource "aws_route_table_association" "Project-RT-association-1b" {
  subnet_id      = aws_subnet.project-subnet-1b-pub.id
  route_table_id = aws_route_table.Project-route-table.id
}

# Creating Private Route Table 
resource "aws_route_table" "Project-pvt-route-table" {
  vpc_id = aws_vpc.project-vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Project-NAT-Gateway.id
  }
  
  tags = {
    Name = "Project-pvt-route-table"
  }
}

# Creating Private Route Table Association 
resource "aws_route_table_association" "Project-pvt-RT-association-1a" {
  subnet_id      = aws_subnet.project-subnet-1a-pvt.id
  route_table_id = aws_route_table.Project-pvt-route-table.id 
}

resource "aws_route_table_association" "Project-pvt-RT-association-1b" {
  subnet_id      = aws_subnet.project-subnet-1b-pvt.id
  route_table_id = aws_route_table.Project-pvt-route-table.id
}

# Creating Elastic IP for NAT Gateway
resource "aws_eip" "Project-elastic-ip" {
  vpc      = true
} 

# Creating NAT Gateway
resource "aws_nat_gateway" "Project-NAT-Gateway" {
  allocation_id = aws_eip.Project-elastic-ip.id
  subnet_id     = aws_subnet.project-subnet-1a-pub.id

  tags = {
    Name = "Project-NAT-Gateway"
  }
  depends_on = [aws_internet_gateway.Project-IG]
}

# Create the Target Group, Load Balancer and Listener for Auto Scaling 
# Creating Target Group for Load Balancer 
resource "aws_lb_target_group" "project-LB-target-group" {
  name     = "project-LB-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project-vpc.id
}

# Creating the Load Balancer
resource "aws_lb" "Romana-project-LB" {
  name               = "Romana-project-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-Port-80-for-LB.id]
  subnets            = [aws_subnet.project-subnet-1a-pub.id,aws_subnet.project-subnet-1b-pub.id]

  tags = {
    Environment = "production"
  }
}

# Creating Listener 
resource "aws_lb_listener" "project-listener" {
  load_balancer_arn = aws_lb.Romana-project-LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project-LB-target-group.arn
  }
}

# Creating Launch Template 
resource "aws_launch_template" "project-launch-template" {
  name_prefix   = "Project"
  image_id      = "ami-062df10d14676e201"
  instance_type = "t2.micro"
  key_name      = "AWS-Key-Pair"
  vpc_security_group_ids = [aws_security_group.allow_80-22.id]
  # user_data = "${file("install_apache.sh")}"
  user_data = "${filebase64("install_apache.sh")}"
}

# Create Auto Scaling Group 
resource "aws_autoscaling_group" "project-ASG" {
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
  vpc_zone_identifier = [aws_subnet.project-subnet-1a-pub.id,aws_subnet.project-subnet-1b-pub.id]
  
  target_group_arns = [aws_lb_target_group.project-LB-target-group.arn]
  
  launch_template {
    id      = aws_launch_template.project-launch-template.id
    version = "$Latest"
  }
}
