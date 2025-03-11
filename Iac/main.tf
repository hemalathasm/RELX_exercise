provider "aws" {
  region = var.aws_region
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

#EC2 instance creation
resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_value
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  associate_public_ip_address = true
<<<<<<< HEAD
  monitoring                  = true      #for detailed monitoring
=======
  monitoring                  = true          #for detailed monitoring
>>>>>>> 35dac4789921fa08daef5dd9a0150052db91fd33

  user_data = file("${path.module}/userdata.sh")

  tags = {
    name = "terraform-web-server"
  }
}

output "instance_pblic_ip" {
  description = "public IP of EC2"
  value       = aws_instance.web_server.public_ip
}
