import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
