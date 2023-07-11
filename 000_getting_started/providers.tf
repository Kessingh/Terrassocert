provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  alias = "eu"
}

