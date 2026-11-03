output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "Configured VPC IPv4 CIDR."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets in availability_zones order."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets in availability_zones order."
  value       = aws_subnet.private[*].id
}

output "public_route_table_id" {
  description = "Public route table ID, or null when no public subnets exist."
  value       = try(aws_route_table.public[0].id, null)
}

output "private_route_table_ids" {
  description = "Private route table IDs in availability_zones order."
  value       = aws_route_table.private[*].id
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs. Empty unless an explicit NAT mode is selected."
  value       = aws_nat_gateway.this[*].id
}
