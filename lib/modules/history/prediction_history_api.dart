import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/models/suggestion.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_response.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';

class PredictionnHistoryApiService {
  BuildContext context;
  List<PredictionHistoryResponse> data = [];

  // Constructor
  PredictionnHistoryApiService({
    required this.context,
  });

  Future<List<PredictionHistoryResponse>?> getHistory() async {
    List<PredictionHistoryResponse> data = [];
    try {
      // Fetch data from the 'history' collection based on userId
      QuerySnapshot historyQuery = await FirebaseFirestore.instance
          .collection(Constant.historyTable)
          .orderBy('date', descending: true)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (historyQuery.docs.isEmpty) {
        // Handle the case where no matching history record is found
        return data;
      } else {
        for (QueryDocumentSnapshot historyDoc in historyQuery.docs) {
          Map<String, dynamic> historyJson =
              historyDoc.data() as Map<String, dynamic>;
          var history = PredictionHistoryResponse.fromJson(historyJson);

          DocumentSnapshot predictionDoc = await FirebaseFirestore.instance
              .collection(Constant.predictionTable)
              .doc(history.predictionId)
              .get();

          Map<String, dynamic> predictionJson =
              predictionDoc.data() as Map<String, dynamic>;

          var predictionModel = PredictionModel.fromJson(predictionJson);

          history.prediction = predictionModel;
          data.add(history);
        }
      }

      return data;
    } catch (e) {
      print(e);
      _showErrorAlert('$e');
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

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
