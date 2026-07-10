# edible

**AI-powered food safety and personalized nutrition platform.**

> **Status:** Folder scaffold — no application code yet.

---

## Tech Stack *(planned)*

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 15, React 19, TypeScript, Tailwind CSS, shadcn/ui |
| Backend | Next.js Route Handlers (`app/api/`) |
| Auth | Supabase Auth (Email, Google OAuth) |
| Database | Supabase PostgreSQL |
| Storage | Supabase Storage (food images) |
| AI | OpenAI GPT-4o Vision |
| Nutrition | USDA FoodData Central API |
| Validation | Zod |
| State | TanStack Query, React Hook Form |
| Charts | Recharts |
| Deploy | Vercel + Supabase |
| Tooling | ESLint, Prettier, pnpm, Husky *(optional)* |

---

## Repository Structure

```
edible/
├── middleware.ts              # Auth guard, onboarding redirect (planned)
│
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   └── register/
│   ├── (protected)/           # All routes require auth
│   │   ├── onboarding/        # Health profile setup (first login)
│   │   ├── dashboard/
│   │   ├── scan/
│   │   ├── history/
│   │   └── profile/
│   └── api/
│       ├── analyze/           # AI → USDA → rule engine
│       ├── meals/
│       └── profile/
│
├── components/
│   ├── ui/                    # shadcn/ui primitives
│   ├── features/              # ScanForm, MealCard, RecommendationBadge
│   └── layout/                # AppShell, Nav, Providers
│
├── lib/
│   ├── services/              # Orchestration (analyzeMeal, saveMeal…)
│   ├── supabase/              # Browser + server clients
│   ├── openai/                # GPT-4o Vision
│   ├── nutrition/             # USDA API + schemas/
│   ├── health/
│   │   ├── rules/             # diabetes, hypertension, allergies…
│   │   └── schemas/           # Profile & recommendation Zod schemas
│   └── utils/                 # cn(), formatters
│
├── hooks/                     # useProfile, useMeals, useAnalyze
├── config/                    # Env validation (Zod)
├── constants/                 # Conditions list, thresholds
├── supabase/
│   └── migrations/            # SQL schema
├── public/
├── docs/
└── .github/
```

### Design decisions

| Decision | Why |
|----------|-----|
| `onboarding` inside `(protected)` | User must be logged in before profile setup |
| `lib/services/` | Thin API routes, testable orchestration layer |
| Schemas co-located in `lib/*/schemas/` | Zod lives next to the domain that uses it |
| No top-level `types/` | Avoids a dumping ground as the project grows |
| `supabase/migrations/` | DB schema versioned alongside app code |

---

## Getting Started

```bash
git clone https://github.com/nglong14/Food-Logging-Platform.git
cd Food-Logging-Platform
```

Implementation not started yet. See `docs/` for architecture and design.

---

## Documentation

| Document | Purpose |
|----------|---------|
| [docs/PRODUCT.md](./docs/PRODUCT.md) | Product vision & requirements |
| [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) | System components |
| [docs/API.md](./docs/API.md) | API contracts |
| [docs/DATABASE.md](./docs/DATABASE.md) | Data model |
| [docs/AI_PIPELINE.md](./docs/AI_PIPELINE.md) | AI inference flow |
| [docs/USER_FLOW.md](./docs/USER_FLOW.md) | User journeys |
| [docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md) | Contribution guide |
