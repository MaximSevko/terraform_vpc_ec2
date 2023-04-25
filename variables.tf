variable "aws_region" {
  description = "The AWS region to deploy to."
  default     = "us-east-1"
}

variable "env" {
  description = "The environment for the deployment."
  default     = "dev"
}

variable "AWS_Region" {
  description = "The AWS region to deploy resources to."
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the VPC to be created."
  type        = string
  default     = "vpc3"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.81.0.0/16"
}

variable "vpc_intra_subnets" {
  description = "The list of CIDR blocks for the intra subnets of the VPC."
  type        = list(string)
  default     = ["10.81.1.0/24", "10.81.2.0/24", "10.81.3.0/24"]
}

variable "vpc_public_subnets" {
  description = "The list of CIDR blocks for the public subnets of the VPC."
  type        = list(string)
  default     = ["10.81.101.0/24", "10.81.102.0/24", "10.81.103.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Set to true to enable a NAT gateway for the VPC."
  type        = bool
  default     = false
}

variable "securitygroup_name" {
  description = "The name of the security group to be created."
  type        = string
  default     = "amilinux_security_group"
}

variable "ec2_name" {
  description = "The name of the EC2 instance to be created."
  type        = string
  default     = "VPN Amazon Linux 2023"
}

variable "role_name" {
  type        = string
  default     = "amilinux_role"
}

#Route 53

variable "route53_zone_id" {
  type        = string
  default     = ""
}

variable "route53_record_name" {
  type        = string
  default     = "vpn.dev.qkdev.net"
}

variable "route53_record2_name" {
  type        = string
  default     = "vpn1.dev.qkdev.net"
}

