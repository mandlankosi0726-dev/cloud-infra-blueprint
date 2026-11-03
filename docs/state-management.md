# Terraform state management

State maps Terraform resource addresses and provider identifiers to real infrastructure and can contain secrets and sensitive metadata. Local state is unsuitable as the default for collaborative or production operations because it is easy to lose, leak, or change concurrently. State and saved plans are excluded from Git; terminal redaction does not remove sensitive values from their files.

## S3 backend and bootstrap

Create the state bucket and its access controls through a separate, tightly controlled bootstrap configuration or approved platform process before configuring a workload backend. Enable bucket versioning, server-side encryption, public access blocking, and least-privilege bucket/KMS policies. Keep bootstrap state independent from the bucket it creates. Do not assume backend initialization creates the bucket.

Example backend block (bucket and key are non-secret identifiers; credentials come from the AWS credential chain):

```hcl
terraform {
  backend "s3" {
    bucket       = "replace-with-approved-state-bucket"
    key          = "client-a/development/network/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

S3 native lockfiles (`use_lockfile`) are supported by Terraform 1.10 and newer. Locking requires the caller's role to read/write the lock object; restrict state object access separately. Avoid putting credentials in backend configuration. Use distinct keys (or separately governed buckets/accounts) for clients and environments.

## Access, recovery, and change safety

Grant state access only to roles that need it; audit access and separate plan/apply permissions. S3 versioning supports recovery from accidental object changes. Document an owner-approved recovery procedure: stop concurrent runs, identify the correct object version, preserve a copy, confirm state-to-resource alignment, and only then restore. Do not edit state by hand as routine repair. For state moves, back up first and use Terraform state migration commands with reviewed plans. Resolve stale locks only after confirming no run is active.
