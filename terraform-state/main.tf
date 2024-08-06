# Specify the AWS details
provider "aws" {
  region = "ap-south-1"
}
resource "aws_s3_bucket" "example" {
  # NOTE: S3 bucket names must be unique accross all aws account
  bucket = "mohi722-demo-s3"
}



