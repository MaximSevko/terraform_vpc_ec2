variable "aws_region" {
    default = "us-east-1"
}

variable "env" {
    description = "enviroment"
    default = "dev"
}

variable "AWS_Region" {
    default = "eu-central-1"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "vpc3"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.81.0.0/16"
}

variable "vpc_intra_subnets" {
  description = "Intra subnets for VPC"
  type        = list(string)
  default     = ["10.81.1.0/24", "10.81.2.0/24", "10.81.3.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.81.101.0/24", "10.81.102.0/24", "10.81.103.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = false
}

variable "securitygroup_name" {
  type        = string
  default     = "amilinux_security_group"
}

variable "ec2_name" {
  type        = string
  default     = "Amazon Linux 2 Instance"
}
  