terraform {

}

provider "aws" {
  region = "ap-south-1"
}

module "apache" {
  source          = ".//terraform-aws-apache-example"
  vpc_id          = "vpc-0c7c01d8f590aaf57"
  my_ip_with_cidr = "49.37.177.252/32"
  public_key      = file("/home/ksingh/.ssh/id_rsa.pub")
  private_key     = file("/home/ksingh/.ssh/id_rsa")
  instance_type   = "t2.micro"
  server_name     = "apache-modules"
}


