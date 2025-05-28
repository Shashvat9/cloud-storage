terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "shashvat-remote-backend-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "remote-lock-table"
    profile = "cloud-storage"
  }
}
