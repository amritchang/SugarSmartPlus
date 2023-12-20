import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/models/health_metrics.dart';
import 'package:sugar_smart_assist/models/suggestion.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';

class HomeApiService {
  BuildContext context;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Constructor
  HomeApiService({
    required this.context,
  });

  Future<HealthMetrics?> getUserHealthInformation() async {
    SVProgressHUD.show();
    try {
      DocumentSnapshot userSnapshot = await _firestore
          .collection(Constant.healthMetricTable)
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (userSnapshot.exists) {
        // User found, you can access user data
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        SVProgressHUD.dismiss();
        var data = HealthMetrics.fromJson(userData);
        return data;
      } else {
        SVProgressHUD.dismiss();
        return null;
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      return null;
    }
  }

  Future<SuggestionModel?> getSuggestion(String predictionId) async {
    SVProgressHUD.show();
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection(Constant.suggestionTable)
          .where('predictionId', isEqualTo: predictionId)
          .get();

      if (query.docs.isNotEmpty && query.docs.first.data() != null) {
        Map<String, dynamic>? suggestionJson =
            query.docs.first.data() as Map<String, dynamic>;

        var model = SuggestionModel.fromJson(suggestionJson);

        SVProgressHUD.dismiss();
        return model;
      } else {
        SVProgressHUD.dismiss();
        return null;
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      return null;
    }
  }
}
