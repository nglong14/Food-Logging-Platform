# SYSTEM_DESIGN.md

> **Status:** Draft  
> **Purpose:** Capture detailed design decisions, trade-offs, and component boundaries.

---

## Document Purpose

While [ARCHITECTURE.md](./ARCHITECTURE.md) describes *what* the system looks like, this document explains *why* it is designed that way. It records decisions, alternatives considered, and constraints — so future contributors understand the reasoning behind the codebase.

## Contents *(to be expanded)*

### 1. Design Goals
- Personalization over generic nutrition data
- Extensible rule engine for health conditions
- Separation of AI inference from business logic
- Independent deployability of frontend, backend, and AI services

### 2. Key Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Recommendation logic | Rule-based engine | Easy to add diseases without ML retraining |
| AI role | Ingredient + nutrition estimation | AI informs; rules decide suitability |
| Food input | Multi-modal with fallback | Manual entry when AI confidence is low |
| Data storage | Relational (PostgreSQL) | Structured health profiles and audit trails |

### 3. Component Boundaries
- **Frontend** — presentation and user input only
- **Backend** — auth, profiles, orchestration, rule evaluation
- **AI service** — stateless inference; no business rules
- **Database** — single source of truth for user and log data

### 4. Data Flow Overview
```
User Input → Backend → AI Pipeline → Nutrition Data → Rule Engine → Recommendation → User
```

### 5. Extensibility Model
How new health conditions and recommendation rules are added:
1. Define condition schema in health profile
2. Add rule definitions in backend `rules/`
3. Register rule in evaluation pipeline
4. No changes required in AI or frontend (beyond UI display)

### 6. Security & Privacy
- Health data classification and encryption strategy
- Authentication and authorization model
- Data retention and deletion policies

### 7. Scalability Considerations
- AI inference as async job for heavy workloads
- Caching strategy for repeated food items
- Horizontal scaling of stateless API and AI services

### 8. Open Questions
- Real-time vs. async analysis for photo input
- Offline support for mobile
- Third-party nutrition database integration

## Related Documents

- [ARCHITECTURE.md](./ARCHITECTURE.md)
- [AI_PIPELINE.md](./AI_PIPELINE.md)
- [DATABASE.md](./DATABASE.md)
