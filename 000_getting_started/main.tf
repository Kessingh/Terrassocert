terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

variable "instance_type" {
  type = string
}

locals {
  project_name = "keshav"
}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

resource "aws_instance" "test" {
  ami           = "ami-0d13e3e640877b0b9"
  instance_type = var.instance_type

  tags = {
    Name = "test-${local.project_name}"
  }
}

output "instance_ip_addr"{
  value = aws_instance.test.public_ip
}