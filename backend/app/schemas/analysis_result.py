from typing import Literal
from pydantic import BaseModel, Field


class AnalysisResult(BaseModel):

    is_food_product: bool

    product_name: str | None = None
    brand: str | None = None
    food_category: str | None = None

    ingredients: list[str] = Field(default_factory=list)

    allergens: list[str] = Field(default_factory=list)

    health_score: int | None = None

    positive_factors: list[str] = Field(default_factory=list)

    negative_factors: list[str] = Field(default_factory=list)

    score_factors: list[str] = Field(default_factory=list)

    summary: str

    confidence: Literal["High", "Medium", "Low"]

    missing_information: list[str] = Field(default_factory=list)