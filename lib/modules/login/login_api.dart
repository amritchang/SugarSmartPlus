import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/models/user.dart';
import 'package:sugar_smart_assist/network_helper/api_response.dart';
import 'package:sugar_smart_assist/network_helper/api_service.dart';
import 'package:sugar_smart_assist/constants/response_message_constant.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginApiService {
  BuildContext context;

  // Constructor
  LoginApiService({
    required this.context,
  });

  Future<bool?> login(String username, String password) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var usernameWithCountryCode = !isMobileNumber(username)
        ? username
        : (Storage().selectedCountryCode + username);
    ;

    var response = await ApiService().apiPostRequest('', null, true);
    if (response != null) {
      var jsonResponse = APIResponse.fromJson(response);
      if (jsonResponse.accessToken != '' && jsonResponse.refreshToken != '') {
        Storage().setAuthToken(
            '${jsonResponse.tokenType} ${jsonResponse.accessToken}');
        Storage().setRefreshToken(jsonResponse.refreshToken);
        if (Storage().userLoginMobileNumber != username) {
          Storage().removeBiometricLoginDetail();
        }
        Storage().userLoginMobileNumber = username;
        Storage().userLoginPassword = password;
        Storage().setIsUserLoggedIn(true);
        return true;
      } else {
        _showErrorAlert(jsonResponse.errorDescription);
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

  bool isMobileNumber(String username) {
    // Adjust the regular expression as needed based on your specific requirements
    RegExp mobileNumberRegex = RegExp(
      r"^[0-9]{9,15}$",
    );

    return mobileNumberRegex.hasMatch(username);
  }
}
