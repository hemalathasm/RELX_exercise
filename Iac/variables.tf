variable "tfc_api_token" {
  type = string
}

variable "aws_key" {
  type = string
  
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "availability_zone" {
  type    = string
  default = "us-east-2a"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0d8c288225dc75373"
}

variable "key_value" {
  type    = string
  default = "ohio"
}