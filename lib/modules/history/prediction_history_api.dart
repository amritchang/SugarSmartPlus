import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_request.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_response.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

class PredictionnHistoryApiService {
  BuildContext context;
  List<PredictionHistoryResponse> data = [];
  List<dynamic> pageList = [];
  bool isFetching = false;

  // Constructor
  PredictionnHistoryApiService({
    required this.context,
  });

  Future<List<PredictionHistoryResponse>?> getTransactions(
    PredictionHistoryRequest request, {
    int maxRetries = 3,
  }) async {

  }

  void _showSuccessAlert(String message, Function()? onOkPressed) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.successText, message, context,
        onOkPressed: onOkPressed);
  }

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
