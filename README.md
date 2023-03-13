Terraform AWS VPC and EC2 Instance
This Terraform project creates an Amazon Web Services (AWS) virtual private cloud (VPC) with three public subnets in different availability zones (AZs), and an EC2 instance in one of those subnets.

Prerequisites
Before you can use this project, you'll need:

An AWS account
Terraform 3.0 or later installed on your computer
AWS credentials with permission to create and manage VPCs, subnets, and EC2 instances

## Usage

1. Clone this repository: git clone https://github.com/MaximSevko/ec2.git

2. Change directory to the cloned repository: `cd ec2`

3. Modify the `variables.tf` file to set the VPC and subnet CIDR blocks as desired. You can also modify the `aws_region` variable if you want to deploy to a different AWS region.

4. Run `terraform init` to initialize the Terraform workspace:

5. Run `terraform plan` to see the changes that will be made.

6. If the plan looks good, run `terraform apply` to create the resources.

7. When you're finished, run `terraform destroy` to delete the resources.
