# Versioning and releases

The repository is versioned as a whole using immutable Git tags (`vMAJOR.MINOR.PATCH`). Consumers pin module sources to a reviewed tag, for example:

```hcl
module "networking" {
  source = "git::https://github.com/ArpScayl/arpscayl-terraform-modules.git//modules/networking?ref=v0.1.0"
  # Inputs omitted
}
```

During the initial `0.x` phase, interfaces may change; review release notes and plans before upgrading. Once `1.0.0` is approved, use semantic versioning conventions: breaking interface or behavior changes raise MAJOR, additive compatible changes raise MINOR, and compatible fixes raise PATCH. Provider constraints and semver alone do not guarantee behavior; validate each consumer and inspect plans.

For each release, review changes and security findings, run CI and module tests, update a `CHANGELOG.md` with migration steps and limitations, tag the reviewed commit, then deliberately dispatch the manual release workflow for that existing tag. Have a second engineer verify tag/release contents. Never use an unreviewed branch as a production source. There is no module registry publication or automatic infrastructure deployment in this repository.
