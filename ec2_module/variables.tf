variable "instance_type" {
    type = string   
}

variable "image_id" {
    type = string    
}

variable "sg_id"{
    type = string 
}

variable "tags"{
    type = map(string)
    default = {}
}

variable "environment"{
    type = string
}

variable "project" {
    type = string
}   