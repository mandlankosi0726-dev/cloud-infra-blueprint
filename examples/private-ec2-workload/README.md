# Private EC2 workload example

Composes networking, a narrowly scoped security group, an EC2-trusted IAM role with an instance profile, and an encrypted IMDSv2-only EC2 instance in a private subnet. It creates no public subnet, NAT gateway, or public IP. The SSM managed policy is attached so that Systems Manager can be used when the required SSM endpoints and IAM access are configured.

Copy `terraform.tfvars.example` to a local `terraform.tfvars` and replace the AMI ID, region-specific AZs, CIDRs, owner, and cost center. The placeholder AMI ID is not deployable. Keep variable files containing environment-specific values out of Git. This example is not a production design: choose instance sizing, patching, backups, endpoint connectivity, logging, and recovery controls for the workload.

Since NAT is disabled, private instances cannot reach public AWS endpoints. Add interface endpoints for Systems Manager services (and any other required AWS APIs) or explicitly choose a NAT design after reviewing its cross-AZ and ongoing cost trade-offs. This configuration has not been planned against AWS and creates no resources by itself.
