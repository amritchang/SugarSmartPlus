import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/main.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:sugar_smart_assist/network_helper/api_response.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  var client = http.Client();
  Map<String, String> header = {};

  Future<ApiService> getDetail([bool needAuthorization = true]) async {
    var token = await Storage().getAuthToken();
    var headers = {
      'Authorization': needAuthorization ? token ?? '' : '',
      'accept': 'application/json',
      'content-type': 'application/json',
      'tmk-secret': 'threemonks'
    };
    var apiService = ApiService();
    print(headers);
    apiService.header = headers;
    apiService.client = client;
    return apiService;
  }

  Future<Map<String, dynamic>?> apiPostRequest(String endPoint, String? body,
      [bool handleIndicator = false, bool needAuthorization = true]) async {
    var encodedUrl = Uri.encodeFull(endPoint);
    encodedUrl = encodedUrl.replaceAll("+", "%2B").replaceAll("#", "%23");
    print(encodedUrl.toString());
    print(body);
    if (handleIndicator && !kIsWeb) {
      SVProgressHUD.show();
    }
    ApiService apiService = await getDetail(needAuthorization);
    try {
      var response = await apiService.client.post(
        Uri.parse(encodedUrl),
        headers: apiService.header,
        body: body,
      );
      // Check if the response has a valid JSON content type
      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        // Parse the response body as JSON
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (!kIsWeb) {
          SVProgressHUD.dismiss();
        }
        return jsonResponse;
      } else {
        // If the response is not in JSON format, you can handle it accordingly
        if (!kIsWeb) {
          SVProgressHUD.dismiss();
        }
        throw Exception('Response is not in JSON format');
      }
    } finally {
      if (!kIsWeb) {
        SVProgressHUD.dismiss();
      }
      apiService.client.close();
    }
  }

  Future<Map<String, dynamic>?> apiGetRequest<T>(String endPoint,
      [bool handleIndicator = false,
      bool onlyCheck200 = false,
      bool needsAuthorization = false]) async {
    if (handleIndicator) {
      SVProgressHUD.show();
    }
    ApiService apiService = await getDetail(needsAuthorization);
    var encodedUrl = Uri.encodeFull(endPoint);
    encodedUrl = encodedUrl.replaceAll("+", "%2B").replaceAll("#", "%23");
    print(encodedUrl);
    try {
      var response = await apiService.client
          .get(Uri.parse(encodedUrl), headers: apiService.header);
      SVProgressHUD.dismiss();
      if (onlyCheck200 && response.statusCode == 200) {
        //in case of logout user
        return null;
      }
      // Check if the response has a valid JSON content type
      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        // Parse the response body as JSON
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (!kIsWeb) {
          SVProgressHUD.dismiss();
        }
        return jsonResponse;
      } else {
        // If the response is not in JSON format, you can handle it accordingly
        if (!kIsWeb) {
          SVProgressHUD.dismiss();
        }
        throw Exception('Response is not in JSON format');
      }
    } finally {
      if (!kIsWeb) {
        SVProgressHUD.dismiss();
      }
      apiService.client.close();
    }
  }

  Future<Map<String, dynamic>?> apiDeleteRequest(String endPoint, String? body,
      [bool handleIndicator = false, bool needAuthorization = true]) async {
    if (handleIndicator && !kIsWeb) {
      SVProgressHUD.show();
    }
    ApiService apiService = await getDetail(needAuthorization);
    try {
      var response = await apiService.client.delete(
        Uri.parse(endPoint),
        headers: apiService.header,
        body: body,
      );
      // Check if the response has a valid JSON content type
      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        // Parse the response body as JSON
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (!kIsWeb) {
          SVProgressHUD.dismiss();
        }
        return jsonResponse;
      } else {
        // If the response is not in JSON format, you can handle it accordingly
        if (!kIsWeb) {
          SVProgressHUD.dismiss();
        }
        throw Exception('Response is not in JSON format');
      }
    } finally {
      if (!kIsWeb) {
        SVProgressHUD.dismiss();
      }
      apiService.client.close();
    }
  }

  Future<APIResponse?> getRefreshToken([bool handleIndicator = false]) async {
    var refreshToken = await Storage().getRefreshToken();
    print('Amrit Old refresh Token: $refreshToken');
    if (refreshToken != null) {
      var response =
          await ApiService().apiPostRequest('', null, handleIndicator);
      if (response != null) {
        var jsonResponse = APIResponse.fromJson(response);
        if (jsonResponse.accessToken != '' && jsonResponse.refreshToken != '') {
          Storage().setAuthToken(
              '${jsonResponse.tokenType} ${jsonResponse.accessToken}');
          Storage().setRefreshToken(jsonResponse.refreshToken);
          return jsonResponse;
        }
        return jsonResponse;
      } else {
        return null;
      }
    }
    return null;
  }

  void _showReLoginErrorAlert() {
    var context = getTopContext();
    if (context != null) {
      showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText,
        AppLocalizations.of(context)!.pleaseReLoginText,
        context,
        onOkPressed: () {
          Storage().deleteAll();
          Navigator.pushReplacement(context, AppRouter().start(logout));
        },
      );
    }
  }
}

BuildContext? getTopContext() {
  var context = NavigationService.navigatorKey.currentContext;
  if (context != null) {
    return context;
  }
  return null;
}
