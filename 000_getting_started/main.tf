terraform {
  cloud {
    organization = "kessingh"

    workspaces {
      name = "getting-started"
    }
  }
}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }


locals {
  project_name = "keshav"
}