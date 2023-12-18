import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:async';

class ChatGPTApiService {
  BuildContext context;
  final List<Map<String, String>> messages = [];

  // Constructor
  ChatGPTApiService({
    required this.context,
  });

  Future<String?> getChatGPTSuggestion(String question) async {
    SVProgressHUD.show();

    print(question);

    if (question.isEmpty) {
      return null;
    }

    messages.add({
      'role': 'user',
      'content': question,
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Constant.chatGPTKey}',
    };

    final body = {'model': 'gpt-3.5-turbo', 'messages': messages};

    final response = await http.post(
      Uri.parse(Constant.chatGPTUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      SVProgressHUD.dismiss();
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      // return data['choices'][0]['text'];
    } else {
      SVProgressHUD.dismiss();
      print(response.body);
      _showErrorAlert(
          'Failed to get suggestion. Status code: ${response.body}');
      return null;
    }
  }

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
