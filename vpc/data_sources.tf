data "aws_availability_zones" "zones"{
    region = var.region
}

data "aws_vpc" default{
    default = true 
}

