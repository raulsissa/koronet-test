variable "aws_region" { default = "us-east-1" }
variable "cluster_name" { default = "koronet-cluster" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnets" { default = ["10.0.1.0/24","10.0.2.0/24"] }
variable "private_subnets" { default = ["10.0.11.0/24","10.0.12.0/24"] }
variable "allowed_cidr" { default = "0.0.0.0/0" }
