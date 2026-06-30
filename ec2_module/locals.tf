locals {
    common_tags = {
        ManagedBy = "Terraform"
        Project = var.project
        environment = var.environment 
    }
}