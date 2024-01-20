class PredictionModelResponse {
  String estimatedTimeToDiabetes;
  String prediction;
  String suggestions;

  // Constructor with default values
  PredictionModelResponse({
    this.estimatedTimeToDiabetes = '',
    this.prediction = '',
    this.suggestions = '',
  });

  factory PredictionModelResponse.fromJson(Map<String, dynamic> json) {
    return PredictionModelResponse(
      estimatedTimeToDiabetes: json['estimatedTimeToDiabetes'],
      prediction: json['prediction'],
      suggestions: json['suggestions'],
    );
  }
}
