
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



module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  // Input variables
  name                         = var.ec2_name
  ami                          = "ami-05a66dc4a507a82cc"
  instance_type                = "t4g.small"
  availability_zone            = element(module.vpc.azs, 0)
  subnet_id                    = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids       = [module.security_group.this_security_group_id]
  associate_public_ip_address  = true
  key_name                     = "keym"
  monitoring                   = true
  user_data                    = file("script.sh")

  iam_instance_profile = aws_iam_instance_profile.profile.name


    root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 10
      kms_key_id  = aws_kms_key.this.id
    },
  ]
}

resource "aws_iam_role" "role" {
  name = var.role_name
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession",
        "sts:SetSourceIdentity"
      ]
      Principal = {
               "Service": "ec2.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_iam_instance_profile" "profile" {
  name      = var.role_name
  role = aws_iam_role.role.name
}

  resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.disk1.id
  instance_id = module.ec2_instance.id
}

  resource "aws_volume_attachment" "this1" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.disk2.id
  instance_id = module.ec2_instance.id
}

resource "aws_ebs_volume" "disk1" {
  availability_zone = element(module.vpc.azs, 0)
  size= 3
  type = "gp3"
  encrypted   = true
  #kms_key_id = aws_kms_key.this

}

resource "aws_ebs_volume" "disk2" {
  availability_zone = element(module.vpc.azs, 0)
  size = 2
  type = "gp3"

  encrypted = true
  #kms_key_id = aws_kms_key.this
}

resource "aws_kms_key" "this" {
}

