# Networking module

Creates an IPv4 VPC, optional public and private subnet tiers, route tables, an internet gateway for public subnets, and optional NAT gateways. Neither tier auto-assigns public IPs to launched instances; an internet-facing ALB can use public subnets without enabling instance public IP assignment. It does not create security groups, endpoints, firewall controls, or IPv6 configuration.

## Architecture and usage

Supply one subnet CIDR for each selected AZ in each enabled tier. Public subnets have a default route to the internet gateway but do not auto-assign public IPs. Private subnets also do not assign public IPs. With `nat_gateway_mode = "none"` private route tables have no internet default route. `single` shares one NAT across private subnets (less expensive, but AZ dependency and cross-AZ traffic); `per_az` provides a NAT per AZ at higher hourly and data-processing cost. NAT gateways require both tiers. Omit public CIDRs when the workload does not need public subnets.

```hcl
module "networking" {
  source               = "../../modules/networking"
  name                 = "platform"
  environment          = "development"
  vpc_cidr             = "10.40.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.40.0.0/24", "10.40.1.0/24"]
  private_subnet_cidrs = ["10.40.16.0/20", "10.40.32.0/20"]
  nat_gateway_mode     = "none"
  tags                 = { Owner = "platform-team" }
}
```

## Inputs and outputs

Inputs are declared and typed in `variables.tf`: `name`, `environment`, `vpc_cidr`, `availability_zones`, `public_subnet_cidrs`, `private_subnet_cidrs`, `nat_gateway_mode`, DNS toggles, and additional `tags`. Required outputs include `vpc_id`, `vpc_cidr_block`, public/private subnet IDs, route table IDs, and NAT gateway IDs. See output descriptions in `outputs.tf`.

The module validates CIDR syntax, containment within the VPC, overlap across public and private tiers, duplicate CIDRs, distinct AZs, tier/AZ counts, and invalid NAT combinations. Operators must also check overlap with connected networks and reserved ranges; address planning should be reviewed before planning.

## Security, operations, and cost

No workloads or ingress rules are created. Keep private workloads in private subnet IDs and attach explicitly designed security groups. Public subnet placement alone does not make a resource reachable; routing, public addressing, and security rules also matter. NAT gateways and Elastic IPs incur ongoing charges and data transfer costs. Evaluate VPC endpoints, NAT count, AZ failure behavior, and egress needs for each environment.

Resource names and tags include Project, Environment, and ManagedBy; additional tags should be non-sensitive. VPC CIDR changes and subnet resizing can force replacement. Review plans for destroy/recreate operations. There is no lifecycle protection on the VPC; protect critical environments with state isolation, permissions, and review gates.

## Testing and upgrade notes

Run `terraform fmt -check -recursive`, `terraform init -backend=false`, and `terraform validate` for the calling root. No AWS integration test is included. Compatibility: Terraform `>= 1.10.0, < 2.0.0`, AWS provider `>= 5.0, < 7.0`. This initial module version is `0.x` until tagged; changes may be breaking and should be checked against plans before upgrade.
