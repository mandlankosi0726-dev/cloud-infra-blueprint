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
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  nat_gateway_mode     = "none"
  tags                 = var.tags
}

module "load_balancer_security_group" {
  source = "../../modules/security-groups"

  name        = "${var.project_name}-alb"
  description = "Approved client HTTPS access and application target egress"
  vpc_id      = module.networking.vpc_id
  project     = var.project_name
  environment = var.environment
  ingress_rules = concat(
    [for cidr in var.client_cidrs : {
      description = "HTTPS from approved client network ${cidr}"
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = cidr
    }],
    var.enable_http_redirect ? [for cidr in var.client_cidrs : {
      description = "HTTP redirect from approved client network ${cidr}"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = cidr
    }] : []
  )
  egress_rules = [{
    description = "Application traffic to VPC targets"
    ip_protocol = "tcp"
    from_port   = var.application_port
    to_port     = var.application_port
    cidr_ipv4   = var.vpc_cidr
  }]
  tags = var.tags
}

module "application_security_group" {
  source = "../../modules/security-groups"

  name        = "${var.project_name}-app"
  description = "Application traffic only from the load balancer"
  vpc_id      = module.networking.vpc_id
  project     = var.project_name
  environment = var.environment
  ingress_rules = [{
    description                  = "Application port from ALB"
    ip_protocol                  = "tcp"
    from_port                    = var.application_port
    to_port                      = var.application_port
    referenced_security_group_id = module.load_balancer_security_group.security_group_id
  }]
  egress_rules = []
  tags         = var.tags
}

module "application_instance" {
  source = "../../modules/ec2-instance"

  name               = "${var.project_name}-${var.environment}-app"
  project            = var.project_name
  environment        = var.environment
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.networking.private_subnet_ids[0]
  security_group_ids = [module.application_security_group.security_group_id]
  tags               = var.tags
}

module "application_load_balancer" {
  source = "../../modules/application-load-balancer"

  name                 = "${var.project_name}-${var.environment}-web"
  project              = var.project_name
  environment          = var.environment
  internal             = false
  subnet_ids           = toset(module.networking.public_subnet_ids)
  vpc_id               = module.networking.vpc_id
  security_group_ids   = [module.load_balancer_security_group.security_group_id]
  target_port          = var.application_port
  target_type          = "instance"
  target_ids           = [module.application_instance.instance_id]
  health_check_path    = var.health_check_path
  certificate_arn      = var.certificate_arn
  enable_http_redirect = var.enable_http_redirect
  tags                 = var.tags
}
