# USER_FLOW.md

> **Status:** Draft  
> **Purpose:** Map end-to-end user journeys and interaction patterns.

---

## Document Purpose

This document describes how users move through edible — from first visit to receiving personalized food recommendations. It bridges product requirements and UI/API design, ensuring all teams share the same understanding of user experience.

## Contents *(to be expanded)*

### 1. Primary User Journeys

#### Journey 1: Onboarding & Profile Setup
```
Sign Up → Create Health Profile → Select Conditions → Set Allergies → Set Goals → Dashboard
```
- First-time users must complete profile before food analysis
- Conditions selected from supported list (extensible)
- Profile editable at any time; changes apply to future analyses

#### Journey 2: Photo-Based Food Analysis
```
Dashboard → Take Photo → AI Processing → View Ingredients → View Recommendation → Save Log
```
- Camera opens in-app
- Loading state during AI inference
- Results show: recognized items, nutrition breakdown, suitability verdict
- Warnings highlighted for condition-specific concerns (e.g., high sugar for diabetes)

#### Journey 3: Image Upload Analysis
```
Dashboard → Upload Image → AI Processing → View Results → Save Log
```
- Same result flow as photo; different input method

#### Journey 4: Manual Food Entry
```
Dashboard → Manual Entry → Type Description → Parse Ingredients → View Recommendation → Save Log
```
- Free-text input (e.g., "grilled chicken with steamed broccoli and white rice")
- NLP extracts ingredients; user can edit before analysis
- No AI vision required — works offline *(planned)*

#### Journey 5: Review Meal History *(planned)*
```
Dashboard → History → Select Past Meal → View Recommendation → Compare Trends
```

### 2. Recommendation Display

Users see:
- **Suitability verdict** — Suitable / Caution / Not Recommended
- **Condition-specific warnings** — e.g., "High carbohydrates — may affect blood sugar"
- **Actionable suggestions** — e.g., "Consider reducing portion or pairing with protein"
- **Confidence indicator** — when AI is uncertain

### 3. Edge Cases & Error Flows

| Scenario | User Experience |
|----------|----------------|
| No profile set | Redirect to profile setup before analysis |
| AI low confidence | Prompt to confirm/edit ingredients manually |
| AI failure | Graceful fallback to manual entry |
| Unsupported condition | Inform user; generic nutrition shown |
| Allergen detected | Prominent warning before user proceeds |

### 4. Accessibility Considerations
- Screen reader support for recommendation results
- High-contrast warnings for allergen alerts
- Keyboard navigation for all input modes

### 5. Future Flows *(planned)*
- Caregiver mode — manage profiles for dependents
- Meal planning — suggest meals based on profile
- Clinician view — aggregated patient food logs

## Related Documents

- [PRODUCT.md](./PRODUCT.md) — personas and requirements driving these flows
- [API.md](./API.md) — endpoints powering each journey
- [AI_PIPELINE.md](./AI_PIPELINE.md) — what happens during "AI Processing"
