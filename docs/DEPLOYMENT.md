# DEPLOYMENT.md

> **Status:** Draft  
> **Purpose:** Define environments, CI/CD pipeline, release process, and operational runbooks.

---

## Document Purpose

This document covers how edible is built, tested, deployed, and operated across environments. It is the reference for DevOps practices and release management.

## Contents *(to be expanded)*

### 1. Environments

| Environment | Purpose | URL *(TBD)* |
|-------------|---------|-------------|
| **Local** | Developer machines via Docker Compose | `localhost` |
| **Development** | Shared dev environment for integration | `dev.edible.app` |
| **Staging** | Pre-production validation | `staging.edible.app` |
| **Production** | Live user-facing system | `app.edible.app` |

### 2. Local Development *(planned)*

```bash
# Start full stack
docker compose -f docker/docker-compose.yml up

# Services
# - frontend:  http://localhost:3000
# - backend:   http://localhost:8000
# - ai:        http://localhost:8001
# - postgres:  localhost:5432
```

### 3. CI/CD Pipeline *(planned)*

```
Push / PR → Lint & Test → Build Images → Deploy to Staging → Manual Approval → Deploy to Production
```

| Stage | Tool | Scope |
|-------|------|-------|
| Lint & format | GitHub Actions | All packages |
| Unit tests | GitHub Actions | Backend, frontend, AI |
| Integration tests | GitHub Actions | API + database |
| Build | Docker | All services |
| Deploy | GitHub Actions + cloud provider | Staging → Production |

### 4. Release Process
1. Feature branches merged to `main` via PR
2. `main` auto-deploys to staging
3. Tagged releases (`vX.Y.Z`) trigger production deployment
4. Changelog generated from conventional commits

### 5. Infrastructure
- Container orchestration: Docker / Kubernetes *(TBD)*
- Database: Managed PostgreSQL
- Object storage: Food images in cloud bucket
- AI inference: GPU instances or managed ML API
- CDN: Static assets and cached images

### 6. Monitoring & Observability *(planned)*
- Application logs: structured JSON, centralized
- Metrics: request latency, AI inference time, error rates
- Alerts: API downtime, AI pipeline failures, database connection issues
- Health checks: `/health` endpoint on all services

### 7. Secrets Management
- Environment variables via cloud secret manager
- No secrets in repository or Docker images
- Rotation policy for API keys and database credentials

### 8. Rollback Strategy
- Blue-green or rolling deployments
- Database migrations must be backward-compatible
- One-command rollback to previous image tag

## Related Documents

- [ARCHITECTURE.md](./ARCHITECTURE.md) — deployment topology
- [infrastructure/README.md](../infrastructure/README.md) — IaC details
- [docker/README.md](../docker/README.md) — container definitions
