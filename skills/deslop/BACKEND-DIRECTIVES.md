# Backend Directives

Loaded when repo has backend code. Every finding must cite file:line.

## Architecture Assessment

- **Fit check**: What architecture is this? (monolith/microservices/serverless/modular monolith). Does it match repo size + team size + complexity? Microservices for 3 endpoints = overengineered. Monolith with 50 unrelated domains = under-structured.
- **Why this way?**: Distinguish intentional design vs fast-and-dirty vs AI slop. Evidence: commit history patterns, inconsistent patterns across modules = slop. Consistent but wrong = bad design. Consistent and reasoned = respect, but still assess.
- **Service boundaries**: Too many tiny services = distributed monolith. One service doing everything = monolith pretending. Check if boundaries align with domain, not technical layers.

## Crons & Scheduled Jobs

- **Existence audit**: List every cron/scheduled job. What does each do? Can it be event-driven instead?
- **Race conditions**: Multiple crons touching same data? Overlapping schedules? No locking? → flag critical.
- **Overlap**: Cron A produces what cron B consumes with timing assumptions → fragile. Flag.
- **Idempotency**: Cron runs twice — breaks? → flag critical. Must be idempotent.
- **Event-driven alternative**: If cron polls for state changes → replace with event/webhook/queue. Polling = last resort.

## Communication Patterns

- **HTTP polling**: Client/service polling endpoint repeatedly → SSE or WebSocket candidate. Flag if poll interval < 10s.
- **Sync chains**: Service A calls B calls C synchronously → timeout cascades. Flag if chain > 2 hops.
- **Fire-and-forget HTTP**: POST without awaiting result, no queue, no retry → data loss. Flag critical.
- **Event-driven opportunity**: Any place where "when X happens, do Y" implemented as polling/cron → should be event/queue/hook.
- **Message queue assessment**: If using queues — dead letter handling? Retry policy? Idempotent consumers?

## Database

- **Choice justification**: Postgres for most things = good default. TimescaleDB, Mongo, Redis-as-primary, Cassandra, etc → must justify. If justification = "data retention" achievable with pg partitioning → flag. SIMPLIFY.
- **Schema bloat**: Tables with > 30 columns → likely AI slop or lazy normalization. Assess.
- **Normalization**: Over-normalized (10 joins for simple query) = bad. Under-normalized (data duplication everywhere) = bad. Find balance.
- **Indexes**: Missing indexes on foreign keys and frequently queried columns → flag.
- **Migrations**: Reversible? Idempotent? Or destructive one-way? Flag destructive without reason.
- **Connection pooling**: Configured? Sized for load? Or default connection-per-request? Flag if absent.
- **Transactions**: Multi-table writes without transaction → flag critical. Race conditions on read-modify-write without locking → flag critical.
- **Soft deletes everywhere**: Needed? Or lazy? If most tables soft-delete but never query deleted rows → flag. Just delete.

## API Design

- **Consistency**: Mix of REST conventions (some `/getUser`, some `/users/:id`) → flag. Pick one.
- **Status codes**: Everything returns 200 with error in body → flag. Proper HTTP semantics.
- **Validation**: Input validated at handler level? Or trusting client? Missing validation → flag.
- **Versioning**: Breaking changes without versioning → flag.
- **Auth**: Every protected endpoint actually checking auth? Middleware gaps? → flag critical.
- **Rate limiting**: Public endpoints without rate limiting → flag if user-facing.

## Reliability

- **Downtime recovery**: App restarts — what's lost? In-memory queues? Unfinished jobs? → flag each.
- **Backfill**: If indexing/syncing external data — downtime gap recovery exists? Or data lost forever? → flag critical if no backfill.
- **Graceful shutdown**: SIGTERM handler? Drain connections? Finish in-flight requests? Or hard kill? → flag if missing.
- **Health checks**: Endpoint exists? Checks real deps (DB, queues) or just returns 200? → flag if shallow.
- **Timeouts**: HTTP client timeouts configured? DB query timeouts? Or hang forever? → flag if defaults/missing.
- **Retry logic**: External API calls retry on transient failure? With backoff? Or single-shot-and-fail? → flag if critical path.

## Logging & Observability

- **No structured logging**: Console.log / print statements in production → flag. Use structured logger (pino, winston, tracing crate, etc).
- **No request tracing**: Requests not traceable across services → flag. Correlation IDs needed.
- **Sensitive data in logs**: Passwords, tokens, PII logged → flag critical.
- **No metrics**: No health/performance metrics exposed → flag major for production services.
- **Log levels wrong**: Everything at INFO/DEBUG in production → flag. ERROR for errors, WARN for degradation, INFO for lifecycle.

## Secret Management

- **Secrets in code**: Hardcoded API keys, passwords, connection strings → flag critical.
- **Secrets in env files committed**: `.env` in git → flag critical. Only `.env.example` with placeholder values.
- **No secret rotation**: Long-lived secrets with no rotation mechanism → flag major.
- **Secrets in Docker image**: Build args or ENV with secrets baked into image → flag critical. Use runtime injection.

## External Dependencies

- **Blast radius**: External service down — app crashes? Or degrades gracefully? → flag if crash.
- **Circuit breakers**: Absent on external calls that can hang → flag for critical paths.
- **API version pinning**: Using `latest` or unpinned external API → flag.
- **Webhook verification**: Receiving webhooks without signature verification → flag critical.

## Web3 / Blockchain (if applicable)

- **Indexer downtime**: Indexer stops — events lost? Backfill mechanism? → flag critical if no recovery.
- **Chain reorgs**: Handled? Or assume finality immediately? → flag if no reorg handling.
- **RPC reliability**: Single RPC endpoint? No fallback? → flag. Need fallback + health checks.
- **Transaction submission**: Nonce management? Gas estimation? Stuck transaction handling? → flag gaps.
- **State consistency**: On-chain state vs off-chain DB — reconciliation mechanism? Drift detection? → flag if none.
- **Block confirmation**: How many confirmations before acting? Zero-conf on critical path → flag.
