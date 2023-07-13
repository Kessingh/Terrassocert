terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

provider "aws" {
  #profile = "default"
  region = "ap-south-1"
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.0.20230503.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "test" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  tags = {
    Name = "test-meta-arguments"
  }
}


output "public_ip" {
  value = aws_instance.test.public_ip
}