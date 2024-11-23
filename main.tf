provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }

#   required_version = ">= 1.0.0"
# }

# # Data block to fetch available availability zones
# data "aws_availability_zones" "available" {
#   state = "available"
# }
