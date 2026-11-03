# Architecture

Consumers compose independently scoped modules from root configurations. A root owns provider configuration, state backend, account/region selection, and environment inputs. Modules create focused resources and receive provider configuration from their caller. The initial AWS component is networking; future providers should have provider-specific modules rather than a forced cross-cloud abstraction.

Each client and environment should have isolated state and deliberate account boundaries. Examples illustrate interfaces, not universal client architectures. Avoid copying development sizing or CIDRs into production.
