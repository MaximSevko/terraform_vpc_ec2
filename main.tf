
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  // Input variables
  name                       = var.vpc_name
  cidr                       = var.vpc_cidr
  azs                        = ["${var.AWS_Region}a", "${var.AWS_Region}b", "${var.AWS_Region}c"]
  intra_subnets              = var.vpc_intra_subnets 
  public_subnets             = var.vpc_public_subnets
  enable_ipv6                = "true"
  enable_nat_gateway         = var.vpc_enable_nat_gateway
  intra_subnet_ipv6_prefixes = [11,22,33]
  public_subnet_ipv6_prefixes = [1,2,3]
  public_subnet_assign_ipv6_address_on_creation = "true"

}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  // Input variables
  name                         = var.ec2_name
  ami                          = "ami-0c0fcae772c706bbe"
  instance_type                = "t4g.micro"
  availability_zone            = element(module.vpc.azs, 0)
  subnet_id                    = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids       = [module.security_group_id]
  associate_public_ip_address  = true
  key_name                     = "keym"
  monitoring                   = true
  user_data                    = file("mount.sh")
  root_block_device            = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 10
    },
  ]
  ebs_block_device             = [
    {
      device_name = "/dev/sdb"
      volume_type = "gp3"
      volume_size = 3
      encrypted   = true
    },
    {
      device_name = "/dev/sdc"
      volume_type = "gp3"
      volume_size = 2
      encrypted   = true
    }
  ]

}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = var.securitygroup_name
  description = "Security group for EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_ipv6_cidr_blocks = ["::/0"]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]

}

