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


variable "instance_type" {
  type = string
}

resource "aws_instance" "test" {
  ami           = "ami-0d13e3e640877b0b9"
  instance_type = var.instance_type

  tags = {
    Name = "test-variables"
  }
}

output "public_ip" {
  value = aws_instance.test.public_ip
  sensitive = true
}