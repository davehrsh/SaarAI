def get_rating(score: int) -> str:
    """
    Convert a health score (0-100) into a rating.
    """

    if score >= 90:
        return "Excellent"

    if score >= 75:
        return "Good"

    if score >= 60:
        return "Moderate"

    if score >= 40:
        return "Poor"

    return "Avoid Consumption"