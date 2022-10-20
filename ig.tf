# Creating Internet Gateway 
resource "aws_internet_gateway" "Project-IG" {
  vpc_id = aws_vpc.project-vpc.id

  tags = {
    Name = "Project-IG"
  }
}
