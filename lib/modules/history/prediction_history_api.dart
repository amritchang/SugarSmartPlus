import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_request.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_response.dart';
import 'package:sugar_smart_assist/network_helper/api_response.dart';
import 'package:sugar_smart_assist/network_helper/api_service.dart';
import 'package:sugar_smart_assist/constants/response_message_constant.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
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
    Completer<List<PredictionHistoryResponse>?> completer =
        Completer<List<PredictionHistoryResponse>?>();

    if (request.page == 1) {
      data = [];
    } else if ((request.page ?? -1) >= (pageList.length) &&
        pageList.isNotEmpty) {
      completer.complete(data);
      return null;
    }

    Future<void> makeRequest(int retryCount) async {
      try {
        var response = await ApiService().apiPostRequest(
          '',
          json.encode(request.toJson()),
          false,
          true,
        );

        if (response != null) {
          var jsonResponse = APIResponse.fromJson(response);

          if (jsonResponse.error == ResponseStatusConstant.invalidToken) {
            if (retryCount < maxRetries) {
              APIResponse? refreshTokenResponse =
                  await ApiService().getRefreshToken(false);
              if (refreshTokenResponse != null &&
                  refreshTokenResponse.error.isEmpty) {
                await makeRequest(retryCount + 1); // Retry the API request
                return;
              }
            }
            _showErrorAlert(jsonResponse.message);
            completer.complete(null);
          } else if (jsonResponse.responseStatus ==
                  ResponseStatusConstant.success ||
              jsonResponse.responseStatus == ResponseStatusConstant.S00) {
            pageList = jsonResponse.pageList;
            for (var item in jsonResponse.detailArray) {
              if (item is Map<String, dynamic>) {
                var history = PredictionHistoryResponse.fromJson(item);
                data.add(history);
              }
            }
            completer.complete(data);
          } else {
            _showErrorAlert(jsonResponse.message);
            completer.complete(null);
          }
        } else {
          completer.complete(null);
        }
      } catch (e) {
        print("Error: $e");
        completer.complete(null);
      }
    }

    await makeRequest(0); // Start the request with 0 retries
    return completer.future;
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
