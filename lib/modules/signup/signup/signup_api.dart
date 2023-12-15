import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/modules/signup/signup/signup_request.dart';
import 'package:sugar_smart_assist/network_helper/api_response.dart';
import 'package:sugar_smart_assist/network_helper/api_service.dart';
import 'package:sugar_smart_assist/constants/response_message_constant.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpApiService {
  BuildContext context;

  // Constructor
  SignUpApiService({
    required this.context,
  });

  Future<bool?> signUp(SignUpRequest request) async {
    var response = await ApiService()
        .apiPostRequest('', json.encode(request.toJson()), true);

    if (response != null) {
      var jsonResponse = APIResponse.fromJson(response);
      if (jsonResponse.responseStatus == ResponseStatusConstant.success) {
        return true;
      } else {
        _showErrorAlert(jsonResponse.message);
      }
      return null;
    } else {
      return null;
    }
  }

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
