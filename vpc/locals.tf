locals {
    valid_environments = ["dev", "qa", "test", "prod"]
    common_tags = {
        Project = var.project 
        Environment = var.environment
        Managedby = "Terraform" 
    }

    combined_name = "${var.project}-${var.environment}"
    
    zones = slice(data.aws_availability_zones.zones.names, 0, var.number_of_availability_zones)

    az_idxs = {
        for zone in local.zones: 
            zone => index(local.zones, zone)
    }
    
    subnets_array = flatten([
        for subnet, subnet_details in var.subnets: 
            [
                for az, idx in local.az_idxs: 
                    {
                        key = "${var.project}-${var.environment}-${subnet}-${az}"
                        value = {
                            cidr_block = "10.0.${subnet_details.subnet_index}${idx}.0/24"
                            availability_zone = az 
                            is_private = (subnet_details.subnet_type == "private")
                        }
                    } 
            ]
    ])


    subnets = {
        for subnet in local.subnets_array: 
            subnet.key => subnet.value
    }
    
    public_subnets = {
        for key, value in local.subnets: 
            key => value 
        if (!value.is_private)
    }

    private_subnets = {
        for key, value in local.subnets: 
            key => value 
        if (value.is_private)
    }
}