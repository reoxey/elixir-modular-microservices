# MicroElixir design

## Agreed scope
Rebuild the reference e-commerce domain, not its wire contracts. One application, one release, one BEAM node. LiveView storefront: registration/login, catalog, cart, addresses, checkout and order tracking. Simulated payments and shipping, no external providers. No containers, broker, Redis or cluster. Modules may own separate databases in the future; this version deliberately uses one SQLite database.

## Boundaries
Accounts owns credentials; Catalog owns products and available stock; Carts owns editable baskets; Orders owns immutable checkout snapshots and workflow state; Payments owns simulated authorizations; Shipping owns addresses and shipments. Public context APIs define the seams. Ecto schemas live with their owner. The Orders checkout coordinator may compose these APIs in a shared transaction; separate databases would require a new consistency design.

## Runtime
Phoenix supervises connections. Catalog.Cache owns a disposable ETS table. Workflow.Supervisor contains a unique Registry, bounded DynamicSupervisor and periodic recovery scanner. One transient GenServer per active order advances durable state using native messages. Database transactions guard state transitions and prevent double reservation/payment/shipment. The scanner recovers lost wakeups. No custom event bus. Phoenix PubSub remains Phoenix infrastructure; domain notifications use a local duplicate Registry and send/2.

## Persistence and failures
Checkout reserves stock, snapshots prices/address, creates an order and clears the cart atomically. A client-generated checkout key makes submission idempotent per account. Payment decline or exhausted simulated transient failures releases stock once. Success creates one shipment then marks it dispatched. Each transition persists before notification. Messages/timers/cache are not durable; the SQLite file and workflow records are. Bound active workers and scan batches. Retry provider failures with persisted attempt count and due time. Unexpected worker crashes are supervised; failed database transactions leave state recoverable.

## UI and security
Session cookie authentication, CSRF protections and server-side ownership checks for every user operation. Passwords use salted PBKDF2; no plaintext persistence. Demo-only payment outcomes are explicit. Money is integer EUR cents. Catalog prices refresh in carts until checkout; orders preserve their snapshot. Operations information is limited to safe counters, no public crash controls or credentials.

## Verification
Test real context operations, invalid input, ownership, overselling, idempotency, rollback, retry exhaustion, cache loss, worker death, missed wakeups, LiveView journeys, and release restart with a persistent database. Document limitations: single node and local disk, no real payments/carriers, SQLite write concurrency, external host supervision and backups still needed.
