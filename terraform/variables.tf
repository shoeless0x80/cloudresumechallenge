variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "prefix" {
  type    = string
  default = "crc"
}

variable "domain_name" {
  type    = string
  default = "banta.click"
}

variable "bucket_name" {
  type    = string
  default = "banta.click"
}

variable "common_tags" {
  type = map(string)
  default = {
    Project = "cloud-resume"
  }
}