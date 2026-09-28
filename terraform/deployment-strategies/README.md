# Deployment strategies

Comparison (approximate; depends on traffic and tooling):

| Strategy   | Risk           | Relative cost      | Rollback speed | Complexity |
|------------|----------------|--------------------|----------------|------------|
| Blue-green | Low (full swap)| Higher (2x compute briefly) | Instant (weight flip) | Medium |
| Canary     | Lowest blast radius | Medium (partial dual run) | Fast (shift weights back) | Higher |
| A/B testing| Experiment risk | Medium | Rule change | Higher (product + infra) |

**Status:** Blue-green — not implemented yet (Phase 2). Canary / A/B — Roadmap stubs only.
