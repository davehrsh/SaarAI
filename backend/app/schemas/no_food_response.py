from typing import Literal

from pydantic import BaseModel


class NoFoodResponse(BaseModel):
    is_food_product: Literal[False]

    summary: str

    confidence: Literal["High", "Medium", "Low"]