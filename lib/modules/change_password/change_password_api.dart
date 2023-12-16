import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sugar_smart_assist/modules/login/login_api.dart';

import 'dart:async';

import 'package:sugar_smart_assist/storage/storage.dart';

class ChangePasswordApiService {
  BuildContext context;
  Completer<bool?> changePasswordCompleter = Completer<bool?>();

  // Constructor
  ChangePasswordApiService({
    required this.context,
  });

  Future<bool?> changePassword(
      String oldPass, String newPass, String confirmPass) async {
    var user = await Storage().getUser();
    if (user != null) {
      var login = await LoginApiService(context: getContext())
          .login(user.email ?? '', oldPass, true);
      if (login != null) {
        SVProgressHUD.show();
        try {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            await user.updatePassword(newPass);
            SVProgressHUD.dismiss();
            return true;
          }
        } on FirebaseException catch (e) {
          _showErrorAlert(e.code);
          SVProgressHUD.dismiss();
          return null;
        }
      } else {
        _showErrorAlert(
            AppLocalizations.of(getContext())!.oldPasswordMismatched);
        return null;
      }
    }
  }

  BuildContext getContext() {
    return context;
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
