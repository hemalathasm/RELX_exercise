terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.55.0"  # Use a stable version
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Use the latest AWS provider version
    }
  }
  backend "remote" {
    organization = "me_myself"
    workspaces {
      name = "new-one"
    }
  }
}

provider "hcp" {
  client_secret = var.tfc_api_token
}

provider "aws" {
  region = var.aws_region
  access_key = var.access_id
  secret_key = var.secret_key
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "availability-zone"
    values = [var.availability_zone]
  }
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

/*#Cloud watch configuration
resource "aws_iam_instance_profile" "cloudwatch-profile" {
  name = "CloudWatchInstanceProfile"
  role = aws_iam_role.cloudWatchRole.id
}*/

#EC2 instance creation
resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_value
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  associate_public_ip_address = true

  #iam_instance_profile        = aws_iam_instance_profile.cloudwatch-profile.name

  user_data = file("${path.module}/userdata.sh")

  tags = {
    name = "terraform-web-server"
  }
}

output "instance_public_ip" {
  description = "public IP of EC2"
  value       = aws_instance.web_server.public_ip
}
