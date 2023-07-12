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
}

output "public_ip" {
  value = module.aws_server.public_ip
  sensitive = true
}