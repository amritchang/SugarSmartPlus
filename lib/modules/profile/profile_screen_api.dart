import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileApiService {
  BuildContext context;
  Completer<bool?> completer = Completer<bool?>();

  // Constructor
  ProfileApiService({
    required this.context,
  });

  // Function to delete a user from Firestore
  Future<bool?> deleteUserFromFirestore() async {
    SVProgressHUD.show();
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      // Reference to the 'users' collection in Firestore
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Delete the document with the specified UID
      await usersCollection.doc(uid).delete();
      await FirebaseAuth.instance.currentUser?.delete();
      SVProgressHUD.dismiss();
      return true;
    } catch (e) {
      _showErrorAlert('$e');
      SVProgressHUD.dismiss();
      return null;
      // Handle the error
    }
  }

  void _showErrorAlert(String message) {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.errorText, message, context);
  }
}
