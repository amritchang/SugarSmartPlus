import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugar_smart_assist/models/user.dart';

class LoginApiService {
  BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constructor
  LoginApiService({
    required this.context,
  });

  // Login function
  Future<bool?> login(String username, String password,
      [bool doOnlyLogin = false]) async {
    SVProgressHUD.show();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      if (userCredential.user != null) {
        if (doOnlyLogin) {
          Storage().setIsUserLoggedIn(true);
          return true;
        } else {
          var userInfo = await getUserInformation(userCredential.user!.uid);
          SVProgressHUD.dismiss();
          if (userInfo != null) {
            Storage().setIsUserLoggedIn(true);
            return true;
          }
        }
      }
      return null;
    } on FirebaseException catch (e) {
      if (doOnlyLogin) {
        SVProgressHUD.dismiss();
        return null;
      } else {
        _showErrorAlert(e.code);
        SVProgressHUD.dismiss();
        return null;
      }
    }
  }

  Future<bool?> getUserInformation(String uid) async {
    SVProgressHUD.show();
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection(Constant.userTable).doc(uid).get();
      if (userSnapshot.exists) {
        // User found, you can access user data
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        Storage().saveUser(UserModel.fromJson(userData));
        SVProgressHUD.dismiss();
        return true;
      } else {
        SVProgressHUD.dismiss();
        return null;
      }
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
