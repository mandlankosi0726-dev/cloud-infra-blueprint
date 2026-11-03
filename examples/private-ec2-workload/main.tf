terraform {
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"

  name                 = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  nat_gateway_mode     = "none"
  tags                 = var.tags
}

module "workload_sg" {
  source = "../../modules/security-groups"

  name        = "${var.project_name}-workload"
  description = "Private EC2 workload with explicitly scoped egress"
  vpc_id      = module.networking.vpc_id
  project     = var.project_name
  environment = var.environment

  egress_rules = [{
    description = "HTTPS to approved VPC endpoints"
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_ipv4   = var.vpc_cidr
  }]
  tags = var.tags
}

module "workload_role" {
  source = "../../modules/iam-role"

  name                    = "${var.project_name}-${var.environment}-ec2"
  project                 = var.project_name
  environment             = var.environment
  create_instance_profile = true
  trust_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  tags                = var.tags
}

module "instance" {
  source = "../../modules/ec2-instance"

  name                      = "${var.project_name}-${var.environment}-workload"
  project                   = var.project_name
  environment               = var.environment
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  subnet_id                 = module.networking.private_subnet_ids[0]
  security_group_ids        = [module.workload_sg.security_group_id]
  iam_instance_profile_name = module.workload_role.instance_profile_name
  root_volume_size_gib      = var.root_volume_size_gib
  monitoring_enabled        = var.monitoring_enabled
  tags                      = var.tags
}
