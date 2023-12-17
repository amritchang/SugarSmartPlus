import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionApiService {
  BuildContext context;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constructor
  PredictionApiService({
    required this.context,
  });

  Future<String?> savePredictionResult(PredictionModel request) async {
    SVProgressHUD.show();
    try {
      CollectionReference predictionsCollection =
          _firestore.collection(Constant.predictionTable);

      // Add a new document with an automatically generated ID
      DocumentReference documentReference =
          await predictionsCollection.add(request.toJson());

      // Extract the document ID
      String predictionId = documentReference.id;
      SVProgressHUD.dismiss();
      var res = await saveToHistory(predictionId);
      if (res != null) {
        return predictionId;
      } else {
        return null;
      }
    } catch (e) {
      _showErrorAlert('$e');
      SVProgressHUD.dismiss();
      return null;
    }
  }

  Future<bool?> saveToHistory(String id) async {
    SVProgressHUD.show();
    Map<String, dynamic> jsonMap = {
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'predictionId': id,
      'date': DateTime.now(),
    };

    try {
      CollectionReference predictionsCollection =
          _firestore.collection(Constant.historyTable);

      await predictionsCollection.add(jsonMap);

      SVProgressHUD.dismiss();
      return true;
    } catch (e) {
      _showErrorAlert('$e');
      SVProgressHUD.dismiss();
      return null;
    }
  }

  Future<String?> makeApiCall(PredictionModel model) async {
    const String apiUrl = 'http://127.0.0.1:5000/predict_diabetes';
    SVProgressHUD.show();
    // Replace these values with your input parameters
    Map<String, dynamic> inputData = {
      'Pregnancies': model.pregnancies,
      'Glucose': model.glucose,
      'BloodPressure': model.bloodpressure,
      'SkinThickness': model.skinthickness,
      'Insulin': model.insulin,
      'BMI': model.bmi,
      'DiabetesPedigreeFunction': model.diabetesPedigreeFunction,
      'Age': model.age,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        SVProgressHUD.dismiss();
        return '${result['prediction']}';
      } else {
        _showErrorAlert(
            'Failed to make a prediction. Error code: ${response.statusCode}');
        SVProgressHUD.dismiss();
        return null;
      }
    } catch (e) {
      _showErrorAlert('Error making API call: $e');
      SVProgressHUD.dismiss();
      return null;
    }
  }

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
