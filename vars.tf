variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "EC2_AMI" {
  type    = string
  default = "ami-062df10d14676e201"
}

variable "key_name" {
  type    = string
  default = "AWS-Key-Pair"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "AZ-1a" {
  type    = string
  default = "ap-south-1a"
}

variable "AZ-1b" {
  type    = string
  default = "ap-south-1b"
}