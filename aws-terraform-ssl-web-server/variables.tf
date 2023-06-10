variable "region" {
  default = "eu-west-1"
  type = string
}

variable "vpc_subnet" {
  default = "10.0.0.0/16"
  type = string
}

variable "subnet" {
  default = "10.0.1.0/24"
  type = string
}

variable "local_ip" {
  default = "10.0.1.12"
  type = string
}
variable "ec2_ami" {
  default = "ami-01dd271720c1ba44f" # eu-west-1 (Ireland)
  type = string
  description = "AMI ID of EC2 Instance"
}

variable "filter_ami" {
  type = bool
}

variable "filter_strings" {
  default = ["Ubuntu","x86_64","22.04"]
  type = list(string)
}

variable "ec2_type" {
  default = "t2.micro"
  type = string
}

variable "private_ip" {
  default = "10.0.1.13"
}
# Required
variable "subdomain" {
  type = string
}

variable "domain" {
  type = string
}

variable "email_for_letsencrypt" {
  type = string
}

variable "key_name" {
  type = string 
}