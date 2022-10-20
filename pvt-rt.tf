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