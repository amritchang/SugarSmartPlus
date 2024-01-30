import 'package:firebase_auth/firebase_auth.dart';
import 'package:sugar_smart_assist/models/health_metrics.dart';

class PredictionModel {
  String gender;
  String pregnancies;
  String glucose;
  String bloodpressure;
  String skinthickness;
  String insulin;
  String bmi;
  String age;
  String diabetesPedigreeFunction;
  String outcome;
  String timeToDiabetes;
  String suggestion;

  // Constructor with default values
  PredictionModel({
    this.pregnancies = '',
    this.gender = '',
    this.glucose = '',
    this.bloodpressure = '',
    this.skinthickness = '',
    this.insulin = '',
    this.bmi = '',
    this.age = '',
    this.diabetesPedigreeFunction = '',
    this.outcome = '',
    this.timeToDiabetes = '',
    this.suggestion = '',
  });

// Create a method to convert the object to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'gender': gender,
      'pregnancies': pregnancies,
      'glucose': glucose,
      'bloodpressure': bloodpressure,
      'skinthickness': skinthickness,
      'insulin': insulin,
      'bmi': bmi,
      'age': age,
      'diabetesPedigreeFunction': diabetesPedigreeFunction,
      'outcome': outcome,
      'timeToDiabetes': timeToDiabetes,
    };

    return jsonMap;
  }

  // Create a method to convert the object to JSON
  Map<String, dynamic> toPersonalHealthMetricsJson(String id) {
    Map<String, dynamic> jsonMap = {
      'pregnancies': pregnancies,
      'glucose': glucose,
      'bloodpressure': bloodpressure,
      'skinthickness': skinthickness,
      'predictionId': id,
      'insulin': insulin,
      'bmi': bmi,
      'age': age,
      'diabetesPedigreeFunction': diabetesPedigreeFunction,
      'outcome': outcome,
      'timeToDiabetes': timeToDiabetes,
    };

    return jsonMap;
  }

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      pregnancies: json['pregnancies'],
      gender: json['gender'],
      glucose: json['glucose'],
      bloodpressure: json['bloodpressure'],
      skinthickness: json['skinthickness'],
      insulin: json['insulin'],
      bmi: json['bmi'],
      age: json['age'],
      outcome: json['outcome'],
      timeToDiabetes: json['timeToDiabetes'] ?? '0',
    );
  }

  factory PredictionModel.fromHelthMetrics(
      HealthMetrics healthmetrics, String gender) {
    return PredictionModel(
      pregnancies: healthmetrics.pregnancies,
      gender: gender,
      glucose: healthmetrics.glucose,
      bloodpressure: healthmetrics.bloodpressure,
      skinthickness: healthmetrics.skinthickness,
      insulin: healthmetrics.insulin,
      bmi: healthmetrics.bmi,
      age: healthmetrics.age,
      diabetesPedigreeFunction: healthmetrics.diabetesPedigreeFunction,
      outcome: healthmetrics.outcome,
      timeToDiabetes: '0',
    );
  }
}
