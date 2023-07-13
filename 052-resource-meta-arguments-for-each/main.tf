terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}
resource "aws_instance" "test" {
  ami           = "ami-0d13e3e640877b0b9"
  instance_type = each.value
  for_each = {
    "nano" = "t2.small"
    "micro"="t2.micro"
    "small"="t2.small" 
  }

  tags = {
    Name = "test-${each.key}"
  }
}

output "public_ip" {
  value = values(aws_instance.test)[*].public_ip
}