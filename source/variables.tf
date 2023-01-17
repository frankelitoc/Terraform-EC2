variable "aws_region" {
    type = string
    description = "AWS Region to deploy our resources"
    default = "us-east-1"
}

variable "ssh_key_name" {
    type = string
    description = "Our key pair key name created from our AWS console for security purposes"
    default = "master-key"
}