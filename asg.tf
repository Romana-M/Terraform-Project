# Creating Launch Template 
resource "aws_launch_template" "project-launch-template" {
  name_prefix   = "Project"
  image_id      = var.EC2_AMI
  instance_type = var.instance_type
  key_name      = var.key_name
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
