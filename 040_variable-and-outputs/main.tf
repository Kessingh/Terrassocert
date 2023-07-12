terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

module "aws_server" {
	source = "./aws_server"
	instance_type = "t2.micro"
}

output "public_ip" {
  value = module.aws_server.public_ip
  sensitive = false
}

output "ami-image-name" {
    value = module.aws_server.ami-image-name
}