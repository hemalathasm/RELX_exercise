provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id         = data.aws_vpc.default.id
  default_for_az = true
  }

resource "aws_security_group" "web-sg" {
  name        = "web_security_group"
  description = "Allow HTTP and SSH access"
  vpc_id      = data.aws_vpc.default.id

  #Allow SSH from anywhere
  ingress {                              
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound traffic 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EC2 instance creation
resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata.sh")

  tags = {
    name = "terraform-web-server"
  }
}