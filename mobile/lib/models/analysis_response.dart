class AnalysisResponse {
  final bool isFoodProduct;
  final String? productName;
  final String? brand;
  final String? foodCategory;

  final List<String> ingredients;
  final List<String> allergens;

  final int? healthScore;

  final List<String> positiveFactors;
  final List<String> negativeFactors;
  final List<String> scoreFactors;

  final String summary;
  final String confidence;

  final List<String> missingInformation;

  final String rating;

  const AnalysisResponse({
    required this.isFoodProduct,
    this.productName,
    this.brand,
    this.foodCategory,
    required this.ingredients,
    required this.allergens,
    this.healthScore,
    required this.positiveFactors,
    required this.negativeFactors,
    required this.scoreFactors,
    required this.summary,
    required this.confidence,
    required this.missingInformation,
    required this.rating,
  });

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      isFoodProduct: json['is_food_product'] as bool,
      productName: json['product_name'] as String?,
      brand: json['brand'] as String?,
      foodCategory: json['food_category'] as String?,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      allergens: List<String>.from(json['allergens'] ?? []),
      healthScore: json['health_score'] as int?,
      positiveFactors: List<String>.from(json['positive_factors'] ?? []),
      negativeFactors: List<String>.from(json['negative_factors'] ?? []),
      scoreFactors: List<String>.from(json['score_factors'] ?? []),
      summary: json['summary'] as String,
      confidence: json['confidence'] as String,
      missingInformation:
          List<String>.from(json['missing_information'] ?? []),
      rating: json['rating'] as String,
    );
  }
}