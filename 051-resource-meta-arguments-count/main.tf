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
  instance_type = "t2.micro"
  count = 2 

  tags = {
    Name = "test-${count.index }"
  }
}

output "public_ip" {
  value = aws_instance.test[1].public_ip
}