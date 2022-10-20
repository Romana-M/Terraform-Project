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