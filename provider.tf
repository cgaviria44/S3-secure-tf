terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  profile = var.profile
}

terraform {
  backend "s3" {
    bucket = "cgaviria-mybackend-tf"
    key    = "vpc/dev/terraform.tfstate"
    region = "us-east-1"
  }
}