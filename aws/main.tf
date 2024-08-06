
# Specify the AWS details
provider "aws" {
  region = "ap-south-1"
}

#data "aws_availability_zones" "example" {
# state = "available"
#}

data "aws_instances" "test" {
  filter {
    name = "instance.group-id"
    values = ["sg-0a4b86efefd9999b7"] 
}

filter {
  name = "instance-type"
  values = ["t2.micro", "t2.small"]
}
instance_state_names = ["running", "stopped"]
}


#output "azlist" {
#  value = data.aws_availability_zones.example.names
#}


