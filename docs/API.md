# API.md

> **Status:** Draft  
> **Purpose:** Define the API contract between clients and the backend.

---

## Document Purpose

This document specifies all public API endpoints — routes, request/response schemas, authentication requirements, and error conventions. It serves as the contract between frontend and backend teams and enables independent development.

## Contents *(to be expanded)*

### 1. Conventions
- Base URL: `https://api.edible.app/v1` *(TBD)*
- Authentication: Bearer token (JWT)
- Content-Type: `application/json`
- Error format: `{ "error": { "code": "...", "message": "..." } }`
- Pagination: cursor-based *(TBD)*

### 2. Authentication Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/auth/register` | Create account |
| `POST` | `/auth/login` | Obtain access token |
| `POST` | `/auth/refresh` | Refresh access token |
| `POST` | `/auth/logout` | Invalidate session |

### 3. Health Profile Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/profiles/me` | Get current user's health profile |
| `PUT` | `/profiles/me` | Create or update health profile |
| `GET` | `/profiles/me/conditions` | List supported conditions |

### 4. Food Log Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/food-logs` | Create food log (manual entry) |
| `POST` | `/food-logs/analyze` | Submit image for AI analysis |
| `GET` | `/food-logs` | List user's food logs |
| `GET` | `/food-logs/:id` | Get food log with recommendation |
| `DELETE` | `/food-logs/:id` | Delete a food log |

### 5. Recommendation Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/food-logs/:id/recommendation` | Get recommendation for a log |
| `POST` | `/food-logs/:id/feedback` | User feedback on recommendation |

### 6. Schema Definitions *(planned)*
- `HealthProfile` — age, weight, conditions[], allergies[], goals[]
- `FoodLog` — source, items[], nutrition, timestamp
- `Recommendation` — suitability score, warnings[], suggestions[]
- `NutritionEstimate` — calories, carbs, sugar, sodium, etc.

### 7. Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `UNAUTHORIZED` | 401 | Missing or invalid token |
| `PROFILE_REQUIRED` | 422 | Health profile not set |
| `ANALYSIS_FAILED` | 502 | AI pipeline error |
| `UNSUPPORTED_CONDITION` | 400 | Unknown health condition |

## Related Documents

- [DATABASE.md](./DATABASE.md) — data model behind endpoints
- [USER_FLOW.md](./USER_FLOW.md) — which endpoints each flow uses
