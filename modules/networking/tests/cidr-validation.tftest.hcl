mock_provider "aws" {}

run "accepts_subnets_inside_vpc_without_overlap" {
  command = plan
  variables {
    name                 = "network"
    environment          = "test"
    vpc_cidr             = "10.90.0.0/16"
    availability_zones   = ["us-east-1a", "us-east-1b"]
    public_subnet_cidrs  = ["10.90.0.0/24", "10.90.1.0/24"]
    private_subnet_cidrs = ["10.90.16.0/20", "10.90.32.0/20"]
    nat_gateway_mode     = "none"
  }
  assert {
    condition     = length(aws_subnet.public) == 2 && length(aws_subnet.private) == 2
    error_message = "The module should create one subnet per tier per AZ."
  }
}

run "rejects_overlapping_tiers" {
  command = plan
  variables {
    name                 = "network"
    environment          = "test"
    vpc_cidr             = "10.90.0.0/16"
    availability_zones   = ["us-east-1a", "us-east-1b"]
    public_subnet_cidrs  = ["10.90.0.0/24", "10.90.1.0/24"]
    private_subnet_cidrs = ["10.90.0.0/24", "10.90.32.0/20"]
  }
  expect_failures = [aws_vpc.this]
}

run "rejects_subnet_outside_vpc" {
  command = plan
  variables {
    name                 = "network"
    environment          = "test"
    vpc_cidr             = "10.90.0.0/16"
    availability_zones   = ["us-east-1a"]
    private_subnet_cidrs = ["10.91.0.0/24"]
  }
  expect_failures = [aws_vpc.this]
}
