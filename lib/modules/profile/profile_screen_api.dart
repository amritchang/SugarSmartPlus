import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
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

      QuerySnapshot querySnapshotSuggestion = await FirebaseFirestore.instance
          .collection(Constant.suggestionTable)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      for (QueryDocumentSnapshot documentSnapshot
          in querySnapshotSuggestion.docs) {
        // Delete each document
        await documentSnapshot.reference.delete();
      }

      QuerySnapshot querySnapshotHistory = await FirebaseFirestore.instance
          .collection(Constant.historyTable)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      for (QueryDocumentSnapshot documentSnapshot
          in querySnapshotHistory.docs) {
        // Delete each document
        await documentSnapshot.reference.delete();
      }

      QuerySnapshot querySnapshotPrediction = await FirebaseFirestore.instance
          .collection(Constant.predictionTable)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      for (QueryDocumentSnapshot documentSnapshot
          in querySnapshotPrediction.docs) {
        // Delete each document
        await documentSnapshot.reference.delete();
      }

      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection(Constant.userTable);
      CollectionReference usersHealthCollection =
          FirebaseFirestore.instance.collection(Constant.healthMetricTable);
      await usersHealthCollection.doc(uid).delete();
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
