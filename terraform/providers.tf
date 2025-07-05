terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# us-east-1 is required for ACM certs used by CloudFront
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}