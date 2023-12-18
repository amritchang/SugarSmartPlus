import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'dart:async';

class ChatGPTApiService {
  BuildContext context;
  final List<Map<String, String>> messages = [];

  final List<String> recommendations = [
    'Focus on a balanced diet rich in whole foods, such as fruits, vegetables, whole grains, lean proteins, and healthy fats.',
    'Limit the intake of processed foods, sugary beverages, and foods high in saturated and trans fats.',
    'Engage in regular exercise, such as brisk walking, jogging, cycling, or other aerobic activities. Exercise helps improve insulin sensitivity and can contribute to better blood sugar control.',
    'Maintain a healthy weight through a combination of a balanced diet and regular exercise. Losing excess weight, if applicable, can have a positive impact on insulin sensitivity.',
    'Regularly monitor your blood sugar levels as recommended by your healthcare provider. Keep track of your levels to better understand how different foods, activities, and medications affect your blood sugar.',
    'Practice stress-reducing techniques such as meditation, deep breathing exercises, yoga, or hobbies to manage stress levels. Chronic stress can affect blood sugar levels, so finding healthy ways to cope is important.',
  ];

  // Constructor
  ChatGPTApiService({
    required this.context,
  });

  Future<String?> getChatGPTSuggestion(String question) async {
    SVProgressHUD.show();

    if (question.isEmpty) {
      return null;
    }

    messages.add({
      'role': 'user',
      'content': 'question',
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Constant.chatGPTKey}',
    };

    final body = {'model': 'gpt-3.5-turbo-16k', 'messages': messages};

    final response = await http.post(
      Uri.parse(Constant.chatGPTUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      SVProgressHUD.dismiss();
      final Map<String, dynamic> data = json.decode(response.body);
      return data['choices']['message'][0]['content'];
    } else {
      SVProgressHUD.dismiss();
      int randomIndex = Random().nextInt(recommendations.length - 1);
      return recommendations[randomIndex];
    }
  }
}
