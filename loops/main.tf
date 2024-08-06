# Create multiple user
#variable "user_name" {
#  description = "create IAM user with these names"
#  default     = ["naveen", "sagar", "yaswant", "suraj"]
#}

# AWS details
provider "aws" {
  region = "ap-south-1"
}

# using ternay operator trying to put a condition
variable "enable_usercreation" {
  description = "enable or disable user creation"
}

resource "aws_iam_user" "example" {
  count = var.enable_usercreation ? 1 : 0
  name  = "mohi"
}


# use case of for_each loop
#resource "aws_iam_user" "example" {
#  for_each = toset(var.user_name)
#  name     = each.value
#}

# use case of count loop
#resource "aws_iam_user" "example" {
#  count = length(var.user_name)
#  name  = var.user_name[count.index]
#}


# create single user
#resource "aws_iam_user" "example" {
 # name = "sajal"
#}

