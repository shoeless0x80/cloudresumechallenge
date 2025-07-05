terraform {
  backend "s3" {
    bucket         = "crc-terraform-state-banta"        # the bucket you just made
    key            = "cloudresumechallenge/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "crc-terraform-locks"        # name of your lock table
  }
}