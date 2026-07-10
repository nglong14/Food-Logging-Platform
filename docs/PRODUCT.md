# PRODUCT.md

> **Status:** Draft  
> **Purpose:** Define *what* edible is, *who* it serves, and *why* it exists.

---

## Document Purpose

This document is the single source of truth for product vision and requirements. It guides engineering priorities, design decisions, and success measurement — independent of implementation details.

## Contents *(to be expanded)*

### 1. Vision Statement
Why edible exists and the problem it solves at a human level.

### 2. Problem Definition
- Generic nutrition apps ignore individual health conditions
- Users with diabetes, hypertension, kidney disease, etc. need personalized guidance
- Calorie counting alone does not answer "Is this safe for me?"

### 3. Target Personas
| Persona | Needs |
|---------|-------|
| Chronic condition patient | Daily meal safety checks |
| Health-conscious adult | Proactive, condition-aware nutrition |
| Caregiver | Log meals for dependents with dietary restrictions |

### 4. Core User Stories
- As a user with diabetes, I want to photograph my meal and know if the carbs/sugar are within my limits
- As a user with food allergies, I want immediate warnings when allergens are detected
- As a user, I want to build a health profile once and have all future meals evaluated against it

### 5. Feature Requirements
- Health profile management
- Multi-modal food input (photo, upload, manual)
- AI-powered ingredient and nutrition analysis
- Condition-specific recommendation engine
- Extensible disease/rule support

### 6. Non-Functional Requirements
- Response time targets for AI analysis
- Data privacy and HIPAA-adjacent considerations
- Accessibility standards
- Localization readiness

### 7. Success Metrics
- User retention after profile creation
- Recommendation accuracy (user feedback loop)
- Time-to-insight after food input

### 8. Out of Scope *(initial release)*
- Medical diagnosis
- Prescription or medication management
- Social features / meal sharing

## Related Documents

- [USER_FLOW.md](./USER_FLOW.md) — how users interact with features
- [ARCHITECTURE.md](./ARCHITECTURE.md) — how features are built
