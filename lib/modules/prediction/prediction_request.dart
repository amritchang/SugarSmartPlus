import 'package:firebase_auth/firebase_auth.dart';

class PredictionRequest {
  String gender;
  String pregnancies;
  String glucose;
  String bloodpressure;
  String skinthickness;
  String insulin;
  String bmi;
  String age;
  String outcome;

  // Constructor with default values
  PredictionRequest({
    this.pregnancies = '0',
    this.gender = '',
    this.glucose = '0',
    this.bloodpressure = '0',
    this.skinthickness = '0',
    this.insulin = '0',
    this.bmi = '0',
    this.age = '0',
    this.outcome = '0',
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
      'outcome': outcome,
    };

    return jsonMap;
  }
}
