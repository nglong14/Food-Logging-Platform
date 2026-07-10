# GitHub Configuration

CI/CD workflows, issue templates, pull request templates, and repository policies.

## Planned Structure

```
.github/
├── workflows/              # GitHub Actions CI/CD pipelines
│   ├── ci.yml              # Lint, test on PR
│   ├── deploy-staging.yml  # Auto-deploy main to staging
│   └── deploy-prod.yml     # Tagged release to production
├── ISSUE_TEMPLATE/
│   ├── bug_report.md
│   └── feature_request.md
├── PULL_REQUEST_TEMPLATE.md
└── dependabot.yml          # Automated dependency updates
```

## Planned Workflows

| Workflow | Trigger | Actions |
|----------|---------|---------|
| **CI** | Pull request | Lint, unit tests, build check |
| **Deploy Staging** | Push to `main` | Build images, deploy to staging |
| **Deploy Production** | Tag `v*` | Build images, deploy to production |

## Status

Not yet configured. Workflows will be added when the application stack is finalized.

See [docs/DEPLOYMENT.md](../docs/DEPLOYMENT.md) for the full deployment strategy.
