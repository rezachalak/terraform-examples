provider "aws" {
  region = "us-east-1" # Set your desired region here
}

terraform {
  required_version = ">= 1.4.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}