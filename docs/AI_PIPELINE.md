# AI_PIPELINE.md

> **Status:** Draft  
> **Purpose:** Describe the AI/ML pipeline for food recognition and nutritional estimation.

---

## Document Purpose

This document details how edible uses AI to analyze food — from image input to structured ingredient and nutrition data. It covers model selection, pipeline stages, confidence handling, and integration with the recommendation engine.

## Contents *(to be expanded)*

### 1. Pipeline Overview

```
Input (Image / Text)
        │
        ▼
┌───────────────────┐
│  Preprocessing    │  Resize, normalize, EXIF strip
└────────┬──────────┘
         ▼
┌───────────────────┐
│  Food Recognition │  Identify dish and individual ingredients
└────────┬──────────┘
         ▼
┌───────────────────┐
│ Nutrition Est.    │  Calories, macros, micros per ingredient
└────────┬──────────┘
         ▼
┌───────────────────┐
│ Confidence Filter │  Flag low-confidence results
└────────┬──────────┘
         ▼
   Structured Output → Backend Rule Engine
```

### 2. Input Modes

| Mode | Pipeline Entry | Notes |
|------|---------------|-------|
| Photo (camera) | Image → Vision model | Real-time or async TBD |
| Image upload | Image → Vision model | Same pipeline as photo |
| Manual entry | Text → NLP parser | Extract ingredients from free text |

### 3. Pipeline Stages

**Stage 1 — Preprocessing**
- Image resizing and normalization
- Metadata stripping for privacy

**Stage 2 — Food Recognition**
- Detect dish type and individual food items
- Output: list of ingredients with bounding regions *(optional)*

**Stage 3 — Nutritional Estimation**
- Estimate portion sizes
- Look up or predict nutritional values per ingredient
- Aggregate into meal-level totals

**Stage 4 — Confidence & Fallback**
- Each prediction includes a confidence score
- Below threshold → prompt user to confirm or edit manually
- Manual entry always available as fallback

### 4. Model Strategy *(TBD)*

| Task | Approach Options |
|------|-----------------|
| Food recognition | Fine-tuned vision model / multimodal LLM |
| Portion estimation | Reference object scaling / model regression |
| Nutrition lookup | USDA database + model estimation for gaps |
| Text parsing | LLM-based ingredient extraction |

### 5. Output Schema

```json
{
  "items": [
    {
      "name": "white rice",
      "confidence": 0.92,
      "portion_g": 150,
      "nutrition": {
        "calories": 195,
        "carbohydrates_g": 42,
        "sugar_g": 0.1,
        "sodium_mg": 1
      }
    }
  ],
  "aggregate": { "..." },
  "overall_confidence": 0.88
}
```

### 6. Integration with Rule Engine
- AI output is **input** to the recommendation engine, not the final answer
- Backend receives structured nutrition data and applies condition-specific rules
- AI service is stateless — no user profile access

### 7. Evaluation & Monitoring
- Benchmark dataset for food recognition accuracy
- Nutrition estimation error metrics (MAE vs. labeled data)
- Production monitoring: latency, confidence distribution, fallback rate

### 8. Open Questions
- On-device vs. cloud inference for mobile
- Multi-dish / buffet scene handling
- Regional cuisine coverage

## Related Documents

- [ARCHITECTURE.md](./ARCHITECTURE.md) — where AI fits in the system
- [SYSTEM_DESIGN.md](./SYSTEM_DESIGN.md) — AI vs. rule engine boundary
- [API.md](./API.md) — `/food-logs/analyze` endpoint
