resource "aws_vpc" "main"{
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true 
    enable_dns_support = true 

    tags = merge(local.common_tags, {
        Name = "${local.combined_name}-${var.region}-mainVpc"
    })
}

resource "aws_subnet" "main"{
    for_each = local.subnets

    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    
    tags = merge(local.common_tags, {
        Name = "${each.key}"
    })
}

resource "aws_internet_gateway" "main"{
    vpc_id = aws_vpc.main.id

    tags = merge(local.common_tags, {
        Name = "${local.combined_name}-IG-main"
    })
}

resource "aws_eip" "nat_ip" {
    domain = "vpc"
    tags = merge(local.common_tags, {
        Name = "${local.combined_name}-nat_ip"
    })
}

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat_ip.id
    subnet_id = aws_subnet.main[keys(local.public_subnets)[0]].id
    
    tags = merge(local.common_tags, {
        Name = "${local.combined_name}-main_nat"
    })
}

resource "aws_route_table" "public"{
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    
    route {
        cidr_block = data.aws_vpc.default.cidr_block
        vpc_peering_connection_id = aws_vpc_peering_connection.default_main.id
    }

    route {
        cidr_block = aws_vpc.main.cidr_block
        gateway_id = "local"
    }

    tags = merge(local.common_tags, {
        Name = "${local.combined_name}-public"
    })
}

resource "aws_route_table" "private"{
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
    }

    route {
        cidr_block = data.aws_vpc.default.cidr_block
        vpc_peering_connection_id = aws_vpc_peering_connection.default_main.id
    }
    
    route {
        cidr_block = aws_vpc.main.cidr_block
        gateway_id = "local"
    }

    tags = merge(local.common_tags, {
        Name = "${local.combined_name}-private"
    })
}

resource "aws_route_table_association" "public"{
    for_each = local.public_subnets
    route_table_id = aws_route_table.public.id
    subnet_id = aws_subnet.main[each.key].id
}

resource "aws_route_table_association" "private"{
    for_each = local.private_subnets
    route_table_id = aws_route_table.private.id
    subnet_id = aws_subnet.main[each.key].id
}