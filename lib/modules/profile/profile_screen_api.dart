import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/models/service.dart';
import 'package:sugar_smart_assist/network_helper/api_response.dart';
import 'package:sugar_smart_assist/network_helper/api_service.dart';
import 'package:sugar_smart_assist/constants/response_message_constant.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'dart:async';

class ProfileApiService {
  BuildContext context;
  List<Service> services = [];
  Completer<bool?> completer = Completer<bool?>();

  // Constructor
  ProfileApiService({
    required this.context,
  });
}
