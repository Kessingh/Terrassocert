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
resource "aws_instance" "my_server" {
  ami           = "ami-0d13e3e640877b0b9"
  instance_type = "t2.micro"
	tags = {
		Name = "MyServer"
	}
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-new-bucket-0909"
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}