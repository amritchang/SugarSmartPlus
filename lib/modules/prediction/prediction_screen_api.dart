import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';

class PredictionApiService {
  BuildContext context;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constructor
  PredictionApiService({
    required this.context,
  });

  Future<String?> savePredictionResult(PredictionRequest request) async {
    SVProgressHUD.show();
    try {
      CollectionReference predictionsCollection =
          _firestore.collection('predictions');

      // Add a new document with an automatically generated ID
      DocumentReference documentReference =
          await predictionsCollection.add(request.toJson());

      // Extract the document ID
      String predictionId = documentReference.id;
      SVProgressHUD.dismiss();
      return predictionId;
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
