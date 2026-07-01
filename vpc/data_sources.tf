data "aws_availability_zones" "zones"{
    region = "us-east-1"
}

data "aws_vpc" default{
    default = true 
}

