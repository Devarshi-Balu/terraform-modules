resource "aws_vpc_peering_connection" "default_main"{
    peer_vpc_id = data.aws_vpc.default.id
    vpc_id = aws_vpc.main.id

    auto_accept = true

    requester {
      allow_remote_vpc_dns_resolution = true
    }

    accepter {
      allow_remote_vpc_dns_resolution = true
    }

    tags = merge(local.common_tags, {
        Name = "${local.combined_name}-vpc-peering-to-default"
    })
}

# adding the project vpc route to the default vpc 
resource "aws_route" "default_to_main"{
    route_table_id = data.aws_vpc.default.main_route_table_id
    destination_cidr_block = aws_vpc.main.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.default_main.id
}

