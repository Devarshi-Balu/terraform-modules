output "vpc_details"{
    value = {
        id = aws_vpc.main.id
        cidr_block = aws_vpc.main.cidr_block
        main_route_table_id = aws_vpc.main.main_route_table_id
    }
}

output "subnet_details"{
    value = {
        for subnet, subnet_details in aws_subnet.main: 
            subnet => {
                id = subnet_details.id 
                availability_zone = subnet_details.availability_zone
                cidr_block = subnet_details.cidr_block
                is_private = (local.subnets[subnet].is_private)
            }
    }
}

output "private_subnets"{
    value = {
        for subnet, subnet_details in aws_subnet.main: 
            subnet => {
                id = subnet_details.id 
                availability_zone = subnet_details.availability_zone
                cidr_block = subnet_details.cidr_block
            }
        
        if ((local.subnets[subnet].is_private))
    }
}

output "public_subnets"{
    value = {
        for subnet, subnet_details in aws_subnet.main: 
            subnet => {
                id = subnet_details.id 
                availability_zone = subnet_details.availability_zone
                cidr_block = subnet_details.cidr_block
            }
        
        if (!(local.subnets[subnet].is_private))
    }
}

output "public_route_table_id"{
    value = aws_route_table.public.id 
}

output "private_route_table_id"{
    value = aws_route_table.private.id 
}

