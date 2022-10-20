# Create Public Subnets 
resource "aws_subnet" "project-subnet-1a-pub" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = var.AZ-1a
  map_public_ip_on_launch = "true"

  tags = {
    Name = "project-subnet-1a-pub"
  }
}

resource "aws_subnet" "project-subnet-1b-pub" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = var.AZ-1b
  map_public_ip_on_launch = "true"

  tags = {
    Name = "project-subnet-1b-pub"
  }
}

# Create Private Subnets 
resource "aws_subnet" "project-subnet-1a-pvt" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = var.AZ-1a
  # map_public_ip_on_launch = "true"

  tags = {
    Name = "project-subnet-1a-pvt"
  }
}

resource "aws_subnet" "project-subnet-1b-pvt" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.10.4.0/24"
  availability_zone = var.AZ-1b
  # map_public_ip_on_launch = "true"

  tags = {
    Name = "project-subnet-1b-pvt"
  }
}
