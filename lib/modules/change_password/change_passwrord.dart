import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/custom_views/textfield/app_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/modules/change_password/change_password_api.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String oldValue = '';
  String newValue = '';
  String confirmValue = '';
  late ChangePasswordApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ChangePasswordApiService(context: context);
  }

  void _setOldValue(String text) {
    oldValue = text;
  }

  void _setNewValue(String text) {
    setState(() {
      newValue = text;
    });
  }

  void _setConfirmValue(String text) {
    confirmValue = text;
  }

  Future _triggerAPI() async {
    if (_formKey.currentState!.validate()) {
      var res =
          await apiService.changePassword(oldValue, newValue, confirmValue);
      if (res != null) {
        _navigateToSuccess();
      }
    }
  }

  void _navigateToSuccess() {
    showAlertDialogWithOk(
        AppLocalizations.of(context)!.successText,
        AppLocalizations.of(context)!.passwordChangedSuccess,
        context, onOkPressed: () {
      Navigator.pop(context);
    });
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
        backgroundColor: AppColors.themeWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: TitleNavBar(
                      title: AppLocalizations.of(context)!.changePasswordText,
                      bgColor: Colors.transparent,
                      tintColor: AppColors.themeBlack,
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
                            AppLocalizations.of(context)!.changePasswordText,
                            style: AppFonts.screenTitleBoldTextStyle(
                                color: AppColors.themeBlack)),
                      ),
                    ]),
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
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0, 16.0, 40.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .changePasswordScreenSubtitle,
                                  style: AppFonts.screenSubTitleTextStyle(
                                      color: AppColors.textGreyColor),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    AppTextField(
                                      placeholder: AppLocalizations.of(context)!
                                          .currentPasswordText,
                                      type: TextFieldType.password,
                                      isSecure: true,
                                      onTextChanged: (text) {
                                        _setOldValue(text);
                                      },
                                    ),
                                    AppTextField(
                                      placeholder: AppLocalizations.of(context)!
                                          .newPasswordText,
                                      type: TextFieldType.password,
                                      isSecure: true,
                                      onTextChanged: (text) {
                                        _setNewValue(text);
                                      },
                                    ),
                                    AppTextField(
                                      placeholder: AppLocalizations.of(context)!
                                          .confirmNewPasswordText,
                                      type: TextFieldType.confirmPassword,
                                      isSecure: true,
                                      defaultCheckValue: newValue,
                                      onTextChanged: (text) {
                                        _setConfirmValue(text);
                                      },
                                    ),
                                  ].withSpaceBetween(height: 20),
                                ),
                              ),
                              const SizedBox(height: 20),
                              AppButton(
                                title:
                                    AppLocalizations.of(context)!.submitButton,
                                onPressed: () {
                                  _triggerAPI();
                                },
                                backgroundColor: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
