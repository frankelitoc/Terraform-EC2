# < Declare the region we are going to deploy our AWS resources >
provider "aws"{
    region = var.aws_region
}

# Default VPC for our EC2
resource "aws_default_vpc" "default" {

}

# <Our security group resource to configure public access to our EC2 >
resource "aws_security_group" "world_wide_access" {
  name = "world_wide_access"
  description = "default VPC security group to provide public access to our EC2 instance"
  vpc_id = aws_default_vpc.default.id

  # TCP access
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}


# <Our main EC2 instance which will host our NGINX configuartion >
resource "aws_instance" "ec2_instance" {
    ami = "ami-06878d265978313ca" # Ubuntu Server 22.04 Free Tier
    instance_type = "t2.micro" # t2.micro instance type on this case gives us enough hardware to play around here
    key_name = "${var.ssh_key_name}" # Decided to generate our SSH key pair manually here instead of creating it through Terraform. In a real world scenario we should be careful with keys and keep them private.
    
    #Script to install nginx
    user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing nginx"
  sudo apt update -y
  sudo apt-get install nginx -y
  sudo systemctl start nginx
  sudo systemctl enable nginx
  echo '<center><h1> Hi! I was fully deployed using code instead of boring clicks :> </h1></center>' > /var/www/html/index.html
  echo "*** Completed Installing nginx"
  EOF

    vpc_security_group_ids = [
     aws_security_group.world_wide_access.id
   ]
}

