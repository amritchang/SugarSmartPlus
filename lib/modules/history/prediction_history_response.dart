import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';

class PredictionHistoryResponse {
  Timestamp? date;
  String? predictionId;
  PredictionModel? prediction;

  // Constructor with default values
  PredictionHistoryResponse({
    this.date,
    this.predictionId,
    this.prediction,
  });

  factory PredictionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PredictionHistoryResponse(
        date: json['date'], predictionId: json['predictionId']);
  }
}
