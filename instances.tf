# Create an Instance in Public Subnet 1b 
# This will act as Bastion Host for Private Instances
resource "aws_instance" "Project-Bastion-Instance" {
    ami = "ami-062df10d14676e201"
    key_name = "AWS-Key-Pair"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.project-subnet-1b-pub.id
    vpc_security_group_ids = [aws_security_group.allow_80-22.id]

	  user_data = "${file("install_apache.sh")}"
    
    tags = {
        Name = "Project-Bastion-Instance"
 }
}

# Create a Private Instance in Private Subnet 1a 
resource "aws_instance" "Project-Pvt-Instance" {
    ami = "ami-062df10d14676e201"
    key_name = "AWS-Key-Pair"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.project-subnet-1a-pvt.id

	  user_data = "${file("install_apache.sh")}"
    
    tags = {
        Name = "Project-Pvt-Instance"
 }
}
