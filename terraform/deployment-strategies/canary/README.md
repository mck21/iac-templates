# Canary deployment (Roadmap)

Shift a small percentage of traffic to a new version (e.g. 5–10%), then ramp up if healthy.

**AWS services:** ALB weighted target groups, CodeDeploy / ECS deployment controllers, CloudWatch alarms for automated rollback.

**Trade-offs:** Lower blast radius than a full cutover; needs good metrics and longer rollout vs blue-green.

**Status:** Roadmap — not implemented.
