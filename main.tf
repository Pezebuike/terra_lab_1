#----------------------------------------------------------
#  Terraform - Projet
#
# Createing an automated way to deploy an AWS instance that is running Nginx (port 80) webservice
#
# Made by Ezebuike MIchael
#----------------------------------------------------------

provider "aws" {
  region = "ca-central-1"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

resource "aws_instance" "web" {
  ami                    = "ami-00842a994f5018db8" // Amazon Linux2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = templatefile("user_data.sh.tpl", { // Template File
    f_name = "Ezebuike"
    l_name = "MIchael"
  })

  tags = {
    Name  = "WebServer Built by Terraform"
    Owner = "Ezebuike Michael"
  }
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  ingress {
    description = "Allow port HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer SG by Terraform"
    Owner = "Ezebuike Michael"
  }
}

output "aws_instance_public_dns" {
  value = aws_instance.web.public_dns
}