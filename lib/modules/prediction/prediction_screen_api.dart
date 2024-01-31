import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/models/suggestion.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sugar_smart_assist/modules/prediction/prediction_response.dart';

class PredictionApiService {
  BuildContext context;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constructor
  PredictionApiService({
    required this.context,
  });

  Future<String?> savePredictionResult(
      PredictionModel request, bool shouldUpdatePersonalHealthMetric) async {
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
      if (shouldUpdatePersonalHealthMetric) {
        await savePersonalHealthMetrics(request, predictionId);
      }
      var suggestion = await saveToSuggestion(predictionId, request.suggestion);
      var history = await saveToHistory(predictionId);
      if (suggestion != null && history != null) {
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

  Future<String?> getSuggestion(String predictionId) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection(Constant.suggestionTable)
          .where('predictionId', isEqualTo: predictionId)
          .get();

      if (query.docs.isNotEmpty && query.docs.first.data() != null) {
        Map<String, dynamic>? suggestionJson =
            query.docs.first.data() as Map<String, dynamic>;

        var model = SuggestionModel.fromJson(suggestionJson);

        return model.suggestion;
      } else {
        return '';
      }
    } catch (e) {
      _showErrorAlert('$e');
      return '';
    }
  }

  Future<void> savePersonalHealthMetrics(
      PredictionModel request, String id) async {
    SVProgressHUD.show();
    try {
      // Save  user details to Firestore
      await _firestore
          .collection(Constant.healthMetricTable)
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(request.toPersonalHealthMetricsJson(id));
      SVProgressHUD.dismiss();
    } catch (e) {
      _showErrorAlert('$e');
      SVProgressHUD.dismiss();
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

  Future<PredictionModelResponse?> makeApiCall(PredictionModel model) async {
    SVProgressHUD.show();
    // Replace these values with your input parameters
    Map<String, dynamic> inputData = {
      'Pregnancies': int.parse(model.pregnancies),
      'Glucose': double.parse(model.glucose),
      'BloodPressure': double.parse(model.bloodpressure),
      'SkinThickness': double.parse(model.skinthickness),
      'Insulin': double.parse(model.insulin),
      'BMI': double.parse(model.bmi),
      'DiabetesPedigreeFunction': double.parse(model.diabetesPedigreeFunction),
      'Age': int.parse(model.age),
    };

    print(inputData);

    try {
      final response = await http.post(
        Uri.parse(Constant.predictionModelUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(inputData),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        SVProgressHUD.dismiss();
        return PredictionModelResponse.fromJson(result);
      } else {
        _showErrorAlert(
            'Failed to make a prediction. Error code: ${response.statusCode} ${response.body}');
        SVProgressHUD.dismiss();
        return null;
      }
    } catch (e) {
      _showErrorAlert('Error making API call: $e');
      SVProgressHUD.dismiss();
      return null;
    }
  }

  Future<bool?> saveToSuggestion(String predictionId, String suggestion) async {
    SVProgressHUD.show();
    Map<String, dynamic> jsonMap = {
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'predictionId': predictionId,
      'question': '',
      'suggestion': suggestion
    };

    try {
      CollectionReference predictionsCollection =
          _firestore.collection(Constant.suggestionTable);

      await predictionsCollection.add(jsonMap);

      SVProgressHUD.dismiss();
      return true;
    } catch (e) {
      _showErrorAlert('$e');
      SVProgressHUD.dismiss();
      return null;
    }
  }

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
