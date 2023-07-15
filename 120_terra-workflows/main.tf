terraform {

  cloud {

    organization = "kessingh"



    workspaces {

      name = "terra-vcs-workflow"

    }

}



}







provider "aws" {



  region = "ap-south-1"



}



resource "aws_s3_bucket" "bucket" {

	bucket = "vcs-ksingh-test-tf-workflow-1010" 

}





module "apache-module" {

  source  = "Kessingh/apache-module/aws"

  version = "1.1.0"

  vpc_id          = var.vpc_id



  my_ip_with_cidr = var.my_ip_with_cidr



  public_key      = var.public_key



  instance_type   = var.instance_type



  server_name     = var.server_name



}







output "public_ip" {



    value = module.apache-module.public_ip



  



}

