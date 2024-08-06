
# Specify the AWS details
provider "aws" {
  region = "ap-south-1"
}
# specify the ec2 detials
resource "aws_instance" "example" {
  ami             = "ami-0ad21ae1d0696ad58"
  instance_type   = "t2.micro"
}

