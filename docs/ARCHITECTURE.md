# ARCHITECTURE.md

> **Status:** Draft  
> **Purpose:** Describe system components, their interactions, and data flow.

---

## Document Purpose

This document provides a high-level map of the edible platform — the major components, how they communicate, and where data lives. It is the entry point for engineers onboarding to the project.

## Contents *(to be expanded)*

### 1. System Overview

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Frontend   │────▶│   Backend    │────▶│   Database   │
│  (Web/App)   │◀────│   (API)      │◀────│ (PostgreSQL) │
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │
                            ▼
                     ┌──────────────┐
                     │  AI Service  │
                     │  (Inference) │
                     └──────────────┘
```

### 2. Components

| Component | Responsibility | Location |
|-----------|---------------|----------|
| Frontend | UI, user input, result display | `frontend/` |
| Backend API | Auth, profiles, logs, rule orchestration | `backend/` |
| AI Service | Food recognition, nutrition estimation | `ai/` |
| Database | Persistent storage | `database/` |
| Infrastructure | Cloud resources, CI/CD | `infrastructure/`, `docker/` |

### 3. Communication Patterns
- Frontend ↔ Backend: HTTPS REST API *(GraphQL TBD)*
- Backend ↔ AI: Internal HTTP/gRPC for inference requests
- Backend ↔ Database: ORM / query layer
- Async jobs: image processing queue *(planned)*

### 4. Core Data Flows

**Food Analysis Flow:**
1. User submits food (photo / upload / text)
2. Backend stores raw input, dispatches to AI
3. AI returns ingredients + estimated nutrition
4. Backend runs recommendation rules against user profile
5. Result returned to frontend

**Profile Management Flow:**
1. User creates/updates health profile
2. Backend validates and persists
3. Profile cached for fast rule evaluation

### 5. Deployment Topology *(planned)*
- Containerized services via Docker
- Cloud-hosted with managed PostgreSQL
- AI inference on GPU-enabled instances or managed ML API

### 6. Cross-Cutting Concerns
- Authentication (JWT / session — TBD)
- Logging and observability
- Error handling and retry policies
- Rate limiting on AI endpoints

## Related Documents

- [SYSTEM_DESIGN.md](./SYSTEM_DESIGN.md) — design rationale
- [API.md](./API.md) — endpoint contracts
- [AI_PIPELINE.md](./AI_PIPELINE.md) — inference details
- [DEPLOYMENT.md](./DEPLOYMENT.md) — deployment topology
