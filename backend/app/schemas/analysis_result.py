from typing import Literal

from pydantic import BaseModel


class AnalysisResult(BaseModel):
    product_name: str | None
    brand: str | None
    food_category: str | None

    ingredients: list[str]

    allergens: list[str]

    health_score: int

    positive_factors: list[str]

    negative_factors: list[str]

    score_factors: list[str]

    summary: str

    confidence: Literal["High", "Medium", "Low"]

    missing_information: list[str]