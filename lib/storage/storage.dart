import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:sugar_smart_assist/helper/local_auth_helper.dart';
import 'package:sugar_smart_assist/models/user.dart';

class StorageKey {
  static const String isUserOnBoarded = "isUserOnBoarded";
  static const String isUserLoggedIn = "isUserLoggedIn";
  static const String countryCode = "countryCode";
  static const String authToken = "authToken";
  static const String refreshToken = "refreshToken";
  static const String userProfileDetail = "userProfileDetail";
  static const String userLoginMobileNumber = "userLoginMobileNumber";
  static const String userLoginPassword = "userLoginPassword";
  static const String isBiometricLoginEnabled = "isBiometricLoginEnabled";
}

class Storage extends GetxController {
  /// Start the storage drive. It's important to use await before calling this API, or side effects will occur.
  static Future initContainer() async {
    await GetStorage.init();
    await GetStorage.init(StorageKey.isUserOnBoarded);
    await GetStorage.init(StorageKey.isUserLoggedIn);
    await GetStorage.init(StorageKey.countryCode);
    await GetStorage.init(StorageKey.authToken);
    await GetStorage.init(StorageKey.refreshToken);
    await GetStorage.init(StorageKey.userProfileDetail);
    await GetStorage.init(StorageKey.userLoginMobileNumber);
    await GetStorage.init(StorageKey.userLoginPassword);
    await GetStorage.init(StorageKey.isBiometricLoginEnabled);
  }

  bool get isUserOnBoarded =>
      GetStorage(StorageKey.isUserOnBoarded).read(StorageKey.isUserOnBoarded) ??
      false;

  void setUserOnBoarded(bool value) {
    GetStorage(StorageKey.isUserOnBoarded)
        .write(StorageKey.isUserOnBoarded, value);
  }

  bool get isUserLoggedIn =>
      GetStorage(StorageKey.isUserLoggedIn).read(StorageKey.isUserLoggedIn) ??
      false;

  void setIsUserLoggedIn(bool value) {
    GetStorage(StorageKey.isUserLoggedIn)
        .write(StorageKey.isUserLoggedIn, value);
  }

  bool get isBiometricLoginEnabled =>
      GetStorage(StorageKey.isBiometricLoginEnabled)
          .read(StorageKey.isBiometricLoginEnabled) ??
      false;

  void setIsBiometricLoginEnabled(bool value) {
    GetStorage(StorageKey.isBiometricLoginEnabled)
        .write(StorageKey.isBiometricLoginEnabled, value);
  }

  String get userLoginPassword =>
      GetStorage(StorageKey.userLoginPassword)
          .read(StorageKey.userLoginPassword) ??
      '';

  set userLoginPassword(String value) {
    GetStorage(StorageKey.userLoginPassword)
        .write(StorageKey.userLoginPassword, value);
  }

  String get userLoginMobileNumber =>
      GetStorage(StorageKey.userLoginMobileNumber)
          .read(StorageKey.userLoginMobileNumber) ??
      '';

  set userLoginMobileNumber(String value) {
    GetStorage(StorageKey.userLoginMobileNumber)
        .write(StorageKey.userLoginMobileNumber, value);
  }

  String get selectedCountryCode =>
      GetStorage(StorageKey.countryCode).read(StorageKey.countryCode) ?? '';

  set selectedCountryCode(String value) {
    GetStorage(StorageKey.countryCode).write(StorageKey.countryCode, value);
  }

  void setAuthToken(String token) {
    GetStorage(StorageKey.authToken).write(StorageKey.authToken, token);
  }

  Future<String?> getAuthToken() async {
    return GetStorage(StorageKey.authToken).read(StorageKey.authToken);
  }

  void setRefreshToken(String token) async {
    GetStorage(StorageKey.refreshToken).write(StorageKey.refreshToken, token);
  }

  Future<String?> getRefreshToken() async {
    return GetStorage(StorageKey.refreshToken).read(StorageKey.refreshToken);
  }

  void saveUser(UserModel user) {
    final json = user.toJson();
    GetStorage(StorageKey.userProfileDetail)
        .write(StorageKey.userProfileDetail, json);
  }

  Future<UserModel?> getUser() async {
    var res = await GetStorage(StorageKey.userProfileDetail)
        .read(StorageKey.userProfileDetail);
    if (res != null) {
      return UserModel.fromJson(res);
    }
    return null;
  }

  void deleteAll() async {
    GetStorage(StorageKey.isUserLoggedIn).erase();
    GetStorage(StorageKey.authToken).erase();
    GetStorage(StorageKey.refreshToken).erase();
    GetStorage(StorageKey.userProfileDetail).erase();
    isBiometricAlertShown = false;
    isHealthMetricsAlertShown = false;
  }

  void removeBiometricLoginDetail() async {
    GetStorage(StorageKey.userLoginMobileNumber).erase();
    GetStorage(StorageKey.userLoginPassword).erase();
    GetStorage(StorageKey.isBiometricLoginEnabled).erase();
  }
}
