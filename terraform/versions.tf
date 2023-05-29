terraform {
    backend "s3" {
        bucket         = "terraform-remote-state-ljenecker-worth"
        encrypt        = true
        key            = "terraform.tfstate"
        region         = "eu-west-1"
        dynamodb_table = "Terraform-backend-lock"
    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

