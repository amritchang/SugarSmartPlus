import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool isBiometricAlertShown = false; // Add this flag
bool isHealthMetricsAlertShown = false;

class BiometricService {
  BuildContext context;
  // Constructor
  BiometricService({
    required this.context,
  });

  Future<bool> biometricLogin(String message) async {
    final localAuth = LocalAuthentication();
    try {
      // Check if biometric authentication is available on the device
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        // Check which types of biometrics are available (e.g., fingerprint, face)
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();

        // Check if the device has at least one biometric sensor available
        if (availableBiometrics.isNotEmpty) {
          // Perform biometric authentication
          bool authenticated = await localAuth.authenticate(
              localizedReason: message,
              options: const AuthenticationOptions(
                  biometricOnly: true) // Displayed to the user
              );

          if (authenticated) {
            return true;
          } else {
            _showAuthenticationFailedAlert();
            return false;
          }
        } else {
          // No biometric sensors available on the device
          _showAuthenticationFailedAlert();
          return false;
        }
      } else {
        // Biometric authentication not available on the device
        _showAuthenticationFailedAlert();
        return false;
      }
    } catch (e) {
      // Handle exceptions or errors
      print("Failed Authentication: $e");
      _showAuthenticationFailedAlert();
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    final localAuth = LocalAuthentication();
    List<BiometricType> availableBiometrics = [];

    try {
      availableBiometrics = await localAuth.getAvailableBiometrics();
    } catch (e) {
      // Handle exceptions or errors, such as when biometric authentication is not available.
    }
    return availableBiometrics;
  }

  void _showAuthenticationFailedAlert() {
    showAlertDialogWithOk(AppLocalizations.of(context)!.errorText,
        AppLocalizations.of(context)!.failedAuthenticationText, context);
  }

  Future<bool> isBiometricAvailable() async {
    final localAuth = LocalAuthentication();
    List<BiometricType> availableBiometrics = await getAvailableBiometrics();
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    return canCheckBiometrics && availableBiometrics.isNotEmpty;
  }
}
