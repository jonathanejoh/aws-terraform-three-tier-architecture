# Define the Terraform configuration
terraform {
  required_providers { # Specify the required providers
    aws = {
      source  = "hashicorp/aws" # Use the official AWS provider from HashiCorp
      version = ">= 5.73.0"
    }
  }
  cloud {

    organization = "medium25"

    workspaces {
      name = "my-portfolio"
    }
  }
}
# Configure the AWS provider for the primary region
provider "aws" {
  region = "us-east-1" # Set the AWS region to US East (N. Virginia)
}
