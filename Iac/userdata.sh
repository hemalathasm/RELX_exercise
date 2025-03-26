#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Hello, world!</h1>" > /var/www/html/index.html

#cloud watch agent installation
#sudo yum install -y amazon-cloudwatch-agent
#sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
#-a fetch-config \
#-m ec2 \
#-c ssm:AmazonCloudWatch-linux
#-s
#sudo systemctl enable amazon-cloudwatch-agent