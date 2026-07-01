variable "project"{
    type = string 
}

variable "region"{
    type = string 
    default = "us-east-1"
}

variable "environment" {
    type = string 
    default = "dev"
    
    validation {
      condition = contains(local.valid_environments, var.environment)
      error_message = "Invalid Environment"
    }
}

variable subnets{
    type = map(object({
        subnet_type = string  
        subnet_index = number 
    }))

    default = {
        public = {
            subnet_index = 1
            subnet_type = "public"
        }
        private-backend = {
            subnet_index = 2
            subnet_type = "private"
        }
        private-database = {
            subnet_index = 3
            subnet_type = "private"
        }
    }

    #validate the subnet_types
    validation {
        condition  = alltrue([
            for subnet_name, sub_details in var.subnets: 
                contains(["public", "private"], sub_details.subnet_type)
        ])

        error_message = "invalid subnet type"
    }
}

variable peering_to_default_vpc{
    type = bool 
    default = true
}

variable number_of_availability_zones{
    type = number 
    default = 2 
}