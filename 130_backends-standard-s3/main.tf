terraform {
  backend "s3" {
    bucket = "terraform-backend-4329408"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "force-unlock-terraform"
  }
}


provider "aws" {
  region = "ap-south-1"
  assume_role = "${var.workspace_iam_roles[terraform.workspace]}"
} 

resource "aws_s3_bucket" "bucket" {
	bucket = var.bucket
}

module "apache-module" {
  source  = "Kessingh/apache-module/aws"
  version = "1.1.0"
	vpc_id = var.vpc_id
	my_ip_with_cidr = var.my_ip_with_cidr
	public_key = var.public_key
	instance_type = var.instance_type
 	server_name = var.server_name
}

output "public_ip" {
  value = module.apache-module.public_ip
}