resource "aws_instance" "ec2"{
    ami = var.image_id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.sg_id]

    tags = merge(local.common_tags, var.tags)


    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = "ec2-user"
            password = "DevOps321"
            host = "${self.public_ip}"
        }
        inline = ["sudo dnf install nginx -y"]
    }
}

