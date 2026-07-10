# DATABASE.md

> **Status:** Draft  
> **Purpose:** Define the data model, entity relationships, and migration strategy.

---

## Document Purpose

This document describes how edible stores data — entities, relationships, indexing strategy, and migration conventions. It is the reference for backend engineers and anyone writing queries or migrations.

## Contents *(to be expanded)*

### 1. Database Choice
- **PostgreSQL** — relational, ACID-compliant, JSON support for flexible rule configs
- Managed instance in production; Docker container for local dev

### 2. Entity Relationship Overview

```
users ────────── health_profiles
  │                    │
  │                    ├── conditions (M:N)
  │                    └── allergies (M:N)
  │
  └── food_logs ──── food_items
         │
         └── recommendations
```

### 3. Core Tables *(planned)*

| Table | Description |
|-------|-------------|
| `users` | Auth identity, email, password hash |
| `health_profiles` | User biometrics, goals, linked to `users` |
| `conditions` | Reference table: diabetes, hypertension, etc. |
| `user_conditions` | Junction: user profile ↔ conditions |
| `allergens` | Reference table: peanuts, gluten, etc. |
| `user_allergies` | Junction: user profile ↔ allergens |
| `food_logs` | Logged meal with source type and timestamp |
| `food_items` | Individual recognized ingredients per log |
| `nutrition_estimates` | Nutritional values per food item |
| `recommendation_rules` | Configurable rules per condition |
| `recommendations` | Generated output per food log |

### 4. Key Design Decisions
- **Reference tables for conditions/allergens** — extensible without schema changes
- **JSONB for rule parameters** — flexible thresholds (e.g., max carbs for diabetes)
- **Soft deletes on food logs** — audit trail and user recovery
- **Separate nutrition_estimates** — allows re-evaluation when rules change

### 5. Indexing Strategy
- `food_logs(user_id, created_at DESC)` — meal history queries
- `user_conditions(profile_id)` — fast rule lookup
- `recommendation_rules(condition_id)` — rule engine reads

### 6. Migration Conventions
- Versioned migrations in `database/migrations/`
- Naming: `YYYYMMDDHHMMSS_description.sql`
- All migrations reversible where possible
- Seed data in `database/seeds/` for dev/test

### 7. Data Privacy
- Health profiles contain PHI-adjacent data
- Encryption at rest (database-level)
- Row-level access tied to authenticated user
- Data export and deletion endpoints *(planned)*

## Related Documents

- [SYSTEM_DESIGN.md](./SYSTEM_DESIGN.md) — why these entities exist
- [API.md](./API.md) — how data is exposed
