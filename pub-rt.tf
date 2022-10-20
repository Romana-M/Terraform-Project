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