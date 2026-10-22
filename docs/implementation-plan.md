# MicroElixir implementation plan

**Goal:** Show Elixir strengths through a working single-release ecommerce application.
**Spec:** [Design](design.md)
**Execution:** Inline implementation; conventional commits for independently testable features.

## Constraints
Single BEAM deployment; no Docker/Kubernetes/Redis/external broker. LiveView frontend. Simulated payment/shipping. Existing Go source remains untouched.

## Milestones
- [ ] Foundation: Phoenix/Ecto/SQLite configuration, dependency lock, baseline tests, design.
- [ ] Commerce: Accounts.register/authenticate; Catalog.create/list/update/reserve; Carts.put/items; Shipping.add_address/list_addresses; Orders.checkout/get/list. Test authentication, ownership, validation, stock and atomic checkout.
- [ ] Runtime: Orders.advance; Payments.authorize; Shipping.dispatch; bounded supervised order workers, recovery scan, native subscriptions and ETS cache. Test duplicate steps, declines, retries, worker/cache failure and recovery.
- [ ] Storefront: session controller and LiveView catalog/cart/checkout/orders with live status; accessible responsive styling. Test authenticated/anonymous routes and complete checkout journey.
- [ ] Delivery: seed data, release commands, architecture/runbook/demo documentation, restart smoke test and final review.

## Review focus
Cross-user IDs; malformed/negative quantities; concurrent last-item checkout; duplicate checkout after cart changes; crash between durable commit and notification. Tests must exercise real DB state and runtime behaviour, not just compilation.

## Validation ledger
Generated scaffold uses installed Phoenix 1.8.9 and Elixir 1.20.3 / OTP 29. New project is isolated in its own repository, so no extra worktree is needed. SQLite is an implementation choice for a self-contained single-node demonstration, not a distributed database claim.
