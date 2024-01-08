import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sugar_smart_assist/custom_views/navbar/login_navbar.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/custom_views/textfield/app_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/helper/local_auth_helper.dart';
import 'package:sugar_smart_assist/modules/login/login_api.dart';
import 'package:sugar_smart_assist/storage/storage.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, this.shouldShowBackButton}) : super(key: key);
  bool? shouldShowBackButton = false;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  late LoginApiService apiService;
  late BiometricService biometricService;
  bool isBiometricEnabled = false;
  BiometricType? biobiometricType;

  @override
  void initState() {
    super.initState();
    apiService = LoginApiService(context: context);
    biometricService = BiometricService(context: context);
    _checkForBiometricAvailability();
  }

  void _checkForBiometricAvailability() async {
    var isAlreadyEnabledBiometric = Storage().isBiometricLoginEnabled;
    var list = await biometricService.getAvailableBiometrics();
    if (isAlreadyEnabledBiometric) {
      if (await biometricService.isBiometricAvailable()) {
        setState(() {
          isBiometricEnabled = true;
          if (list.isNotEmpty) {
            biobiometricType = list[0];
          }
        });
      }
    }
  }

  void _biometricLogin(String message) async {
    var isAuthenticated = await biometricService.biometricLogin(message);
    if (isAuthenticated) {
      _setUsername(Storage().userLoginMobileNumber);
      _setPassword(Storage().userLoginPassword);
      _login();
    }
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future _login() async {
    var res = await apiService.login(username, password);
    if (res != null) {
      _navigateToSuccess();
    }
  }

  void _navigateToSuccess() {
    Navigator.pushReplacement(context, AppRouter().start(dashboardRoute));
  }

  void _setUsername(text) {
    username = text;
  }

  void _setPassword(text) {
    password = text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                        child: LoginScreenAppNavBar(
                          shouldShowBackButton: widget.shouldShowBackButton,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30.0, 0),
                        child: Column(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                AppLocalizations.of(context)!
                                    .loginInScreenTitle,
                                style: AppFonts.screenTitleBoldTextStyle()),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context)!.loginScreenSubTitle,
                              style: AppFonts.screenSubTitleTextStyle(
                                  color: AppColors.textWhiteColor),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.themeWhite, // Background color
                              borderRadius:
                                  BorderRadius.circular(10.0), // Corner radius
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 50.0, 16.0, 40.0),
                              child: Column(children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      AppTextField(
                                        placeholder:
                                            AppLocalizations.of(context)!
                                                .usernameText,
                                        type: TextFieldType.username,
                                        isSecure: false,
                                        onTextChanged: (text) {
                                          _setUsername(text);
                                        },
                                      ),
                                      AppTextField(
                                        placeholder:
                                            AppLocalizations.of(context)!
                                                .passwordText,
                                        type: TextFieldType.password,
                                        isSecure: true,
                                        onTextChanged: (text) {
                                          _setPassword(text);
                                        },
                                      ),
                                    ].withSpaceBetween(height: 20),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                AppButton(
                                  title:
                                      AppLocalizations.of(context)!.loginButton,
                                  onPressed: () {
                                    _validate();
                                  },
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)!
                                            .notRegisteredYetText,
                                        style: AppFonts.buttonTitleStyle(
                                            color: AppColors.textBlackColor),
                                      ),
                                      AppButton(
                                        title: AppLocalizations.of(context)!
                                            .registerNowText,
                                        onPressed: () {
                                          Navigator.push(context,
                                              AppRouter().start(signUp));
                                        },
                                        titleColor: AppColors.primaryColor,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isBiometricEnabled,
                                  child: GestureDetector(
                                    onTap: () {
                                      _biometricLogin(
                                          AppLocalizations.of(context)!
                                              .authenticateToLoginText);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (biobiometricType != null)
                                          getTemplatedIconWithSize(
                                              biobiometricType ==
                                                      BiometricType.fingerprint
                                                  ? 'finger_print.png'
                                                  : 'face_id.png',
                                              AppColors.primaryColor,
                                              40,
                                              40),
                                        if (biobiometricType != null)
                                          Text(
                                            AppLocalizations.of(context)!
                                                .useBiometrictext,
                                            style: AppFonts.bodyTextStyle(
                                                color: AppColors.textGreyColor),
                                          )
                                      ].withSpaceBetween(width: 4.0),
                                    ),
                                  ),
                                ),
                              ]),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
