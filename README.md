# SaarAI Backend

AI-powered packaged food analysis API built with **FastAPI** and **Google Gemini**.

The API analyzes one or more images of a packaged food product and returns a structured nutritional assessment, including ingredients, allergens, health score, confidence level, and summary.

---

## Features

- Analyze packaged food products using AI
- Supports **1–3 images** per request
- Combines information across multiple images
- Ingredient extraction
- Nutrition facts extraction
- Allergen detection
- Health score (0–100)
- Health rating
- Confidence estimation
- Structured JSON responses
- Request validation
- Production-ready logging
- Error handling

---

## Tech Stack

- Python 3.13
- FastAPI
- Google Gemini API
- Pydantic
- Uvicorn

---

## Project Structure

```text
app/
├── core/
├── prompts/
├── routers/
├── schemas/
├── services/
├── utils/
└── main.py
```

---

## Installation

Clone the repository:

```bash
git clone <repository-url>
cd backend
```

Create a virtual environment:

```bash
python -m venv .venv
```

Activate the environment:

### Windows

```bash
.venv\Scripts\activate
```

### macOS / Linux

```bash
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

---

## Configuration

Create a `.env` file in the project root.

```env
GEMINI_API_KEY=your_api_key_here
```

---

## Running the API

```bash
uvicorn app.main:app --reload
```

The API will be available at:

```
http://127.0.0.1:8000
```

Swagger UI:

```
http://127.0.0.1:8000/docs
```

ReDoc:

```
http://127.0.0.1:8000/redoc
```

---

## API Endpoints

### GET /

Returns basic API information.

---

### GET /health

Returns API health status.

Example:

```json
{
    "status": "ok"
}
```

---

### POST /api/v1/analyze

Analyze a packaged food product.

### Supported image formats

- JPG
- JPEG
- PNG
- WEBP

### Maximum images

- 3 images

### Success Response

```json
{
    "is_food_product": true,
    "product_name": "Pure Milk Cheese Slices",
    "brand": "Amul",
    "food_category": "Processed Cheese",
    "ingredients": [],
    "allergens": [],
    "health_score": 72,
    "rating": "Moderate",
    "positive_factors": [],
    "negative_factors": [],
    "score_factors": [],
    "summary": "",
    "confidence": "High",
    "missing_information": []
}
```

---

## Error Responses

### Invalid image format

```json
{
    "detail": "Unsupported image format. Please upload a JPG, JPEG or PNG image."
}
```

### More than 3 images

```json
{
    "detail": "You can upload a maximum of 3 images."
}
```

### No packaged food detected

```json
{
    "detail": "No packaged food product detected. Please upload a clear image of a packaged food product."
}
```

### Service unavailable

```json
{
    "detail": "The analysis service is temporarily unavailable. Please try again later."
}
```

---

## Notes

- Images should belong to the **same packaged food product**.
- The AI combines information across all uploaded images.
- Health scores are intended for informational purposes only and should not be considered medical advice.

---

## License

MIT.301