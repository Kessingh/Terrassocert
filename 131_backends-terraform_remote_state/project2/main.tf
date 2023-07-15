provider "aws" {
	profile = "default"
	region = "ap-south-1"
}

data "terraform_remote_state" "vpc" {
	backend = "local"
	config = {
		path = "../project1/terraform.tfstate"
	}
}

module "apache-module" {
  source  = "Kessingh/apache-module/aws"
  version = "1.1.0"
	vpc_id = data.terraform_remote_state.outputs.vpc.vpc_id
	my_ip_with_cidr = var.my_ip_with_cidr
	public_key = var.public_key
	instance_type = var.instance_type
 	server_name = var.server_name
}

output "public_ip" {
  value = module.apache-module.public_ip
}