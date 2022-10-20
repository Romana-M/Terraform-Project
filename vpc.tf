# Create a VPC 
resource "aws_vpc" "project-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Project-vpc"
}
}