import 'package:firebase_auth/firebase_auth.dart';

class HealthMetrics {
  String userId;
  String pregnancies;
  String glucose;
  String bloodpressure;
  String skinthickness;
  String insulin;
  String bmi;
  String age;
  String diabetesPedigreeFunction;
  String outcome;
  String predictionId;

  // Constructor with default values
  HealthMetrics({
    this.pregnancies = '0',
    this.userId = '',
    this.glucose = '0',
    this.bloodpressure = '0',
    this.skinthickness = '0',
    this.insulin = '0',
    this.bmi = '0',
    this.age = '0',
    this.diabetesPedigreeFunction = '0',
    this.outcome = '0',
    this.predictionId = '',
  });

// Create a method to convert the object to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'pregnancies': pregnancies,
      'glucose': glucose,
      'bloodpressure': bloodpressure,
      'skinthickness': skinthickness,
      'insulin': insulin,
      'bmi': bmi,
      'age': age,
      'diabetesPedigreeFunction': diabetesPedigreeFunction,
      'outcome': outcome,
    };

    return jsonMap;
  }

  factory HealthMetrics.fromJson(Map<String, dynamic> json) {
    return HealthMetrics(
      pregnancies: json['pregnancies'],
      glucose: json['glucose'],
      bloodpressure: json['bloodpressure'],
      skinthickness: json['skinthickness'],
      insulin: json['insulin'],
      bmi: json['bmi'],
      age: json['age'],
      diabetesPedigreeFunction: json['diabetesPedigreeFunction'],
      outcome: json['outcome'],
      predictionId: json['predictionId'],
    );
  }
}
