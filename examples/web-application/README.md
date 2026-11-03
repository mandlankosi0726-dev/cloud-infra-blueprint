# Web application composition example

Composes the networking, security-group, EC2, and ALB modules. It places one instance in a private subnet, exposes only HTTPS on a public ALB, scopes ALB client ingress to an explicit CIDR set, and permits target traffic from the ALB security group. HTTP redirect is opt-in and would also require adding TCP/80 ingress to the ALB security group.

Copy `terraform.tfvars.example` to `terraform.tfvars` and replace every placeholder with reviewed values. The sample CIDR is documentation-only. Use an approved AMI, existing ACM certificate in the selected region, non-overlapping address ranges, and client ranges intentionally approved for the service. Do not use `0.0.0.0/0` by default. Keep local tfvars files untracked.

The example does not install or configure an application on the EC2 instance, create NAT or VPC endpoints, or establish DNS records. Private targets therefore need an image that already runs the application and a deliberate egress path for management, updates, and dependencies. The ALB and EC2 instances are billable resources; this file is a composition template, not a production recommendation. Check the plan and resolve all unknown or replacement actions before applying.
