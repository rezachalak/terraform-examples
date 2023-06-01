data "aws_caller_identity" "current" {
  
}
#1. Create a VPC
resource "aws_vpc" "tf" {
  cidr_block = var.vpc_subnet
}
#2. Create a Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tf.id
  depends_on = [ aws_vpc.tf ]
  tags = {
    Name = "tf"
    created_by = data.aws_caller_identity.current.user_id
  }
}
#3. Create a subnet
resource "aws_subnet" "tf" {
  vpc_id     = aws_vpc.tf.id
  cidr_block = var.subnet
  map_public_ip_on_launch = true
    depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "tf"
  }
}
#4. Create Elastic IP

resource "aws_eip" "tf" {
  domain = "vpc"
  instance                  = aws_instance.tf.id
  associate_with_private_ip = "10.0.0.12"
  depends_on                = [aws_internet_gateway.gw]
}
#5. Create Security Group and allow 22, 80, 443/tcp

resource "aws_security_group" "tf" {
  name        = "tf"
  description = "Allow http/https/ssh inbound traffic"
  vpc_id      = aws_vpc.tf.id

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.tf.cidr_block]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.tf.cidr_block]
  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.tf.cidr_block]
  }

  tags = {
    Name = "tf"
  }
}
#6. Create dns record and point to the EIP
resource "aws_route53_zone" "domain" {
  name = var.domain
}
resource "aws_route53_record" "tf" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = var.subdomain
  type    = "A"
  ttl     = 300
  records = [aws_eip.tf.public_ip]
}
#7. Filter AMI ID to find the latest one according to var.filter_strings
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [""]

  filter {
    name   = "name"
    values = var.filter_strings
  }
}

#8. Create an EC2 Instance with the interface with nginx and certbot installed and say "hello IaC"
resource "aws_instance" "tf" {
  # eu-west-1
  ami           = if var.filter_ami ? data.aws_ami.ubuntu.id : var.ec2_ami
  instance_type = var.ec2_type
  security_groups = [ aws_security_group.tf.name ]
  private_ip = var.private_ip
  subnet_id  = aws_subnet.tf.id
}
