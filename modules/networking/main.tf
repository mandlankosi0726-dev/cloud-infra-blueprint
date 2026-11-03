locals {
  common_tags = merge(var.tags, {
    Project     = var.name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
  nat_count    = var.nat_gateway_mode == "none" ? 0 : var.nat_gateway_mode == "single" ? 1 : length(var.availability_zones)
  subnet_cidrs = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)
  subnet_pairs = [
    for pair in setproduct(range(length(local.subnet_cidrs)), range(length(local.subnet_cidrs))) : pair
    if pair[0] < pair[1]
  ]
  cidr_ranges = [
    for cidr in concat([var.vpc_cidr], local.subnet_cidrs) : {
      start = sum([
        for index, octet in split(".", try(cidrhost(cidr, 0), "0.0.0.0")) :
        tonumber(octet) * pow(256, 3 - index)
      ])
      size = pow(2, 32 - try(tonumber(split("/", cidr)[1]), 0))
    }
  ]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.common_tags, { Name = "${var.name}-${var.environment}-vpc" })

  lifecycle {
    precondition {
      condition     = length(var.public_subnet_cidrs) == 0 || length(var.public_subnet_cidrs) == length(var.availability_zones)
      error_message = "Provide either no public subnets or exactly one public subnet per availability zone."
    }
    precondition {
      condition     = length(var.private_subnet_cidrs) == 0 || length(var.private_subnet_cidrs) == length(var.availability_zones)
      error_message = "Provide either no private subnets or exactly one private subnet per availability zone."
    }
    precondition {
      condition     = var.nat_gateway_mode == "none" || (length(var.private_subnet_cidrs) > 0 && length(var.public_subnet_cidrs) > 0)
      error_message = "NAT gateways require private and public subnets."
    }
    precondition {
      condition = alltrue([for cidr in local.subnet_cidrs :
        local.cidr_ranges[index(local.subnet_cidrs, cidr) + 1].start >= local.cidr_ranges[0].start &&
        local.cidr_ranges[index(local.subnet_cidrs, cidr) + 1].start + local.cidr_ranges[index(local.subnet_cidrs, cidr) + 1].size <= local.cidr_ranges[0].start + local.cidr_ranges[0].size
      ])
      error_message = "Every subnet CIDR must be fully contained within the VPC CIDR."
    }
    precondition {
      condition = alltrue([for pair in local.subnet_pairs :
        local.cidr_ranges[pair[0] + 1].start + local.cidr_ranges[pair[0] + 1].size <= local.cidr_ranges[pair[1] + 1].start ||
        local.cidr_ranges[pair[1] + 1].start + local.cidr_ranges[pair[1] + 1].size <= local.cidr_ranges[pair[0] + 1].start
      ])
      error_message = "Subnet CIDRs must not overlap across public and private tiers."
    }
  }
}

resource "aws_internet_gateway" "this" {
  count  = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-${var.environment}-igw" })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, { Name = "${var.name}-${var.environment}-public-${var.availability_zones[count.index]}", Tier = "public" })
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, { Name = "${var.name}-${var.environment}-private-${var.availability_zones[count.index]}", Tier = "private" })
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
  tags = merge(local.common_tags, { Name = "${var.name}-${var.environment}-public-rt" })
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_eip" "nat" {
  count  = local.nat_count
  domain = "vpc"

  tags       = merge(local.common_tags, { Name = "${var.name}-${var.environment}-nat-${count.index + 1}" })
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count         = local.nat_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[var.nat_gateway_mode == "single" ? 0 : count.index].id

  tags       = merge(local.common_tags, { Name = "${var.name}-${var.environment}-nat-${count.index + 1}" })
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.nat_gateway_mode == "none" ? [] : [1]
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[var.nat_gateway_mode == "single" ? 0 : count.index].id
    }
  }
  tags = merge(local.common_tags, { Name = "${var.name}-${var.environment}-private-${count.index + 1}-rt" })
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
