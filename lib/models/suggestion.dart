import 'package:firebase_auth/firebase_auth.dart';

class SuggestionModel {
  String predictionId;
  String userId;
  String question;
  String suggestion;

  // Constructor with default values
  SuggestionModel({
    this.predictionId = '',
    this.userId = '',
    this.question = '',
    this.suggestion = '',
  });

// Create a method to convert the object to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'predictionId': predictionId,
      'question': question,
      'suggestion': suggestion,
    };

    return jsonMap;
  }

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      predictionId: json['predictionId'],
      userId: json['userId'],
      question: json['question'],
      suggestion: json['suggestion'],
    );
  }
}
