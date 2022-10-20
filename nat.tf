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
