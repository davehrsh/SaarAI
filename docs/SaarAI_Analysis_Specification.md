# SaarAI Analysis Specification

**Version:** 1.0  
**Status:** Approved  
**Applies to:** SaarAI V1

---

# Purpose

SaarAI analyzes food product images and provides an explainable nutritional assessment based solely on information visible in the uploaded image.

The objective is to help users understand the nutritional quality of food products using transparent, consistent, and evidence-based analysis rather than subjective opinions.

---

# Core Philosophy

SaarAI is built on four fundamental principles:

- Transparency
- Explainability
- Consistency
- Scientific Responsibility

Whenever uncertainty exists, SaarAI should communicate uncertainty instead of making assumptions.

---

# Analysis Principles

## Rule 1 — Never Guess

Never invent or infer information that is not visible in the uploaded image.

If information cannot be determined, return:

- `null` for unknown values
- `[]` for empty arrays

Examples include:

- Product name
- Brand
- Nutrition facts
- Ingredients hidden by the image
- Food category (if unclear)

---

## Rule 2 — Visible Information Only

Use only information that is visible in the uploaded image.

Do not use:

- Hidden packaging
- External websites
- Brand reputation
- Previous knowledge that contradicts the uploaded image

The uploaded image is the only source of truth.

---

## Rule 3 — Ignore Marketing

Do not increase or decrease the health score because of marketing claims.

Examples include:

- Organic
- Natural
- Healthy
- Superfood
- High Protein
- Low Fat
- No Added Sugar

These claims should only be considered if they are supported by the visible ingredient list or nutrition information.

Packaging design, colours, branding and promotional text must not influence the assessment.

---

## Rule 4 — European Evaluation Principles

When evaluating foods, follow:

- European nutrition guidance
- EFSA (European Food Safety Authority) food safety principles where applicable

Do not:

- Diagnose diseases
- Recommend treatments
- Claim foods prevent disease
- Claim foods cause disease without established scientific consensus

---

## Rule 5 — Conservative Health Scoring

Evaluate both positive and negative nutritional characteristics.

Major nutritional concerns should weigh **slightly more** than minor positive characteristics.

Examples of significant negative factors include:

- Excessive added sugar
- Very high sodium
- Trans fats
- Multiple artificial sweeteners
- Highly processed formulations
- Excessive saturated fats

Examples of positive factors include:

- Whole grains
- High fibre
- High protein
- Low sodium
- No artificial colours
- Healthy fats
- Nutrient-rich ingredients

Rules:

- One positive ingredient should not completely offset multiple significant nutritional concerns.
- One minor negative ingredient should not dominate an otherwise nutritious product.
- The final score should represent the overall nutritional profile.

---

## Rule 6 — Confidence

Confidence represents confidence in the analysis.

It does **NOT** represent confidence in the AI.

Allowed values:

- High
- Medium
- Low

Confidence should decrease if:

- Ingredient list is missing
- Nutrition table is missing
- Front packaging is missing
- Image is blurry
- Text is unreadable
- Important information is cropped

---

## Rule 7 — Missing Information

Instead of guessing, explain what information prevented a better analysis.

Examples:

```json
[
    "Nutrition table not visible",
    "Brand could not be identified",
    "Front packaging not visible"
]
```

---

## Rule 8 — Explainability

Every health score must be explainable.

The analysis should clearly communicate why the score was assigned.

The user should never feel the score was generated arbitrarily.

---

## Rule 9 — Benefit of the Doubt

If uncertainty exists:

- Do not assume the better interpretation.
- Do not assume the worse interpretation.
- Lower the confidence.
- Explain the uncertainty.
- Only evaluate confirmed information.

---

## Rule 10 — Consistency

Equivalent products should receive similar health scores.

Minor wording differences are acceptable.

Large score differences for nearly identical products should be avoided.

---

# Ingredient Extraction Rules

Extract ingredients exactly as written.

Do NOT:

- Reorder ingredients
- Rename ingredients
- Merge ingredients
- Remove additives
- Translate ingredient names unnecessarily

Maintain the original order whenever possible.

---

# Allergen Rules

Extract only allergens explicitly declared on the packaging.

Example:

```
Contains Milk and Soy
```

↓

```json
[
    "Milk",
    "Soy"
]
```

---

Example:

```
May contain peanuts
```

↓

```json
[
    "Peanuts (may contain)"
]
```

Do NOT infer allergens from ingredients.

Only report allergens explicitly stated on the packaging.

---

# Health Score

Health Score Range:

```
0 - 100
```

Higher scores indicate healthier overall nutritional profiles.

Lower scores indicate foods that should generally be consumed less frequently.

Gemini should only generate the numeric score.

The backend determines the rating.

---

# Backend Rating Logic

The backend converts the health score into a rating.

| Score | Rating |
|--------|---------|
| 90 - 100 | Excellent |
| 75 - 89 | Good |
| 60 - 74 | Moderate |
| 40 - 59 | Poor |
| 0 - 39 | Avoid Frequent Consumption |

Business logic belongs in the backend, not inside the AI model.

---

# Output Schema

```json
{
    "product_name": null,
    "brand": null,
    "food_category": null,

    "ingredients": [],

    "allergens": [],

    "health_score": 0,

    "positive_factors": [],

    "negative_factors": [],

    "score_factors": [],

    "summary": "",

    "confidence": "High",

    "missing_information": []
}
```

The backend appends:

```json
{
    "rating": "Moderate"
}
```

---

# AI Responsibilities

Gemini is responsible for:

- Reading the uploaded image
- Extracting visible information
- Evaluating the nutritional profile
- Producing an explainable health score
- Returning valid JSON

Gemini must **NOT**:

- Guess missing information
- Make medical claims
- Diagnose diseases
- Recommend treatments
- Be influenced by marketing claims
- Produce Markdown
- Produce explanations outside the JSON response

---

# Backend Responsibilities

The backend is responsible for:

- Image upload
- Image preprocessing
- Calling Gemini
- Validating the AI response
- Determining the rating from the health score
- Returning the final API response

---

# Out of Scope (V1)

The following features are intentionally excluded from Version 1:

- Barcode scanning
- Live regulatory status
- Country-specific bans
- Product recalls
- Ingredient knowledge database
- NOVA classification
- E-number explanations
- Scientific citations
- Personalized recommendations
- User allergies
- Dietary preferences
- Product alternatives

These will be considered in future versions.

---

# Version History

## Version 1.0

Initial SaarAI Analysis Specification.

Features:

- AI-powered food image analysis
- Ingredient extraction
- Allergen extraction
- Explainable health scoring
- Confidence reporting
- Missing information reporting
- Backend-controlled rating
- European evaluation principles
- Conservative health scoring
- Transparency-first design

---

# Final Principle

> **When uncertainty exists, SaarAI should always choose transparency over confidence.**

The goal is not to appear certain.

The goal is to provide the most trustworthy analysis possible using only the information visible in the uploaded image.