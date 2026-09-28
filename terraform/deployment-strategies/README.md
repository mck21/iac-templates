# Deployment strategies

Comparison (approximate; depends on traffic and tooling):

| Strategy   | Risk                | Relative cost                 | Rollback speed              | Complexity |
|------------|---------------------|-------------------------------|-----------------------------|------------|
| Blue-green | Low (full swap)     | Higher (2× compute briefly)   | Instant (weight flip)       | Medium     |
| Canary     | Lowest blast radius | Medium (partial dual run)     | Fast (shift weights back)   | Higher     |
| A/B testing| Experiment risk     | Medium                        | Rule change                 | Higher (product + infra) |

- **Blue-green:** Implemented in [`blue-green/`](./blue-green/) — dual ASG + ALB weighted forward.
- **Canary / A/B:** Roadmap stubs only.
