# SaarAI API

## Endpoint

POST /api/v1/analyze

## Request

Content-Type: multipart/form-data

Body:
- image (required)

## Response

- product_name
- health_score
- overall_rating
- summary
- positives
- negatives
- warnings
- nutrition
- ingredients
- ingredient_insights
- confidence

## Error Responses

- IMAGE_UNREADABLE
- NO_LABEL_DETECTED
- AI_TIMEOUT
- INVALID_IMAGE
- FILE_TOO_LARGE