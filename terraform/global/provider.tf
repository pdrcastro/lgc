terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.43.0"
    }
  }
}


provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket         = "letsgetchecked-terraform"
    key            = "letsgetchecked-aws/global/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}
