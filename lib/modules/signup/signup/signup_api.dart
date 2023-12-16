import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/modules/signup/signup/signup_request.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpApiService {
  BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constructor
  SignUpApiService({
    required this.context,
  });

  Future<bool?> registerUser(SignUpRequest request) async {
    SVProgressHUD.show();
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      // Save  user details to Firestore
      await _firestore
          .collection(Constant.userTable)
          .doc(userCredential.user!.uid)
          .set(request.toJson());
      SVProgressHUD.dismiss();
      return true;
    } catch (e) {
      _showErrorAlert('$e');
      SVProgressHUD.dismiss();
      return null;
    }
  }

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
