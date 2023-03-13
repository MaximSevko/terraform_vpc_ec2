# Exports the VPC ID created by the terraform-aws-modules/vpc/aws module.
output "vpc_id" {
  value = module.vpc.vpc_id
}

# Exports the IDs of the public subnets created by the terraform-aws-modules/vpc/aws module.
output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

# Exports the ID of the EC2 instance created by the terraform-aws-modules/ec2-instance/aws module.
output "instance_id" {
  value = module.ec2_instance.instance_id
}

# Exports the public IP address of the EC2 instance created by the terraform-aws-modules/ec2-instance/aws module.
output "instance_public_ip" {
  value = module.ec2_instance.public_ip
}
