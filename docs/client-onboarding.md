# Client environment onboarding

1. Gather workload requirements, data classification, availability targets, recovery objectives, support ownership, and compliance constraints.
2. Select the closest example pattern and confirm that its assumptions fit; do not treat examples as universal architectures.
3. Confirm client AWS account ID, region, partition, service availability, billing ownership, and approved deployment role.
4. Define CIDR and connected-network plans, routing/egress needs, administrative access, TLS/DNS ownership, and network segmentation.
5. Choose modules and supply explicit environment inputs, IAM permissions, encryption keys, retention, sizing, tags, and alert destinations.
6. Bootstrap separate versioned, encrypted S3 state with restricted access and native lockfile permissions. Keep bootstrap state independent.
7. Run formatting, validation, module tests, lint, secret scanning, and security scans. Review findings and accepted exceptions.
8. Generate a plan for the confirmed account/region/state key. Review costs, public paths, permissions, replacements, destroys, and unknown values.
9. Obtain client and internal change authorization according to the environment's controls.
10. Apply only the reviewed plan using an approved short-lived role; production requires explicit protected-environment authorization.
11. Verify resources, access boundaries, TLS, target health, alarms, logs, backup behavior, and expected reachability.
12. Hand over source revision/module ref, architecture, access instructions, monitoring, backup/restore, costs, operational ownership, and recovery steps.
