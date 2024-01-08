import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sugar_smart_assist/custom_views/navbar/login_navbar.dart';
import 'package:sugar_smart_assist/custom_views/textfield/date_textfield.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/custom_views/textfield/app_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/helper/string_extension.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:sugar_smart_assist/modules/dropdown/dropdown_screen_arguments.dart';
import 'package:sugar_smart_assist/modules/signup/signup/signup_request.dart';
import 'package:sugar_smart_assist/modules/signup/signup/signup_api.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';

class SignUpcreen extends StatefulWidget {
  const SignUpcreen({Key? key}) : super(key: key);

  @override
  _SignUpcreenState createState() => _SignUpcreenState();
}

class _SignUpcreenState extends State<SignUpcreen> {
  final _formKey = GlobalKey<FormState>();
  bool isAgreed = false;
  bool usePromoCode = false;
  String confirmPasswordCheck = '';
  SignUpRequest request = SignUpRequest();
  TextEditingController dobController = TextEditingController();

  late SignUpApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = SignUpApiService(context: context);
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      if (isAgreed == false) {
        showAlertDialogWithOk(
            AppLocalizations.of(context)!.errorText,
            AppLocalizations.of(context)!.pleaseAgreeTermsandConditionText,
            context);
        return;
      }
      _signUp();
    }
  }

  Future _signUp() async {
    var res = await apiService.registerUser(request);
    if (res != null) {
      showAlertDialogWithOk(
          AppLocalizations.of(getContext())!.successfulRegistrationAlertTitle,
          AppLocalizations.of(getContext())!.successfulRegistrationAlertMessage,
          getContext(), onOkPressed: () {
        Navigator.of(getContext()).pop();
      });
    }
  }

  BuildContext getContext() {
    return context;
  }

  void _setConfirmPasswordCheckvalue(text) {
    setState(() {
      confirmPasswordCheck = text;
    });
  }

  void _updatePromoCodeView(value) {
    setState(() {
      usePromoCode = value;
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
        backgroundColor: AppColors.primaryColor,
        body: Stack(
          children: [
            // Background Image
            SafeArea(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                        child: LoginScreenAppNavBar(
                          shouldShowBackButton: true,
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
                                AppLocalizations.of(context)!.signUpScreenTitle,
                                style: AppFonts.titleBoldTextStyle()),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .signUpScreenSubTitle,
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
                              child: Column(
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        AppTextField(
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .fullNameText,
                                          type: TextFieldType.none,
                                          isSecure: false,
                                          onTextChanged: (text) {
                                            request.fullname = text;
                                          },
                                        ),
                                        AppTextField(
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .genderText,
                                          type: TextFieldType.dropdown,
                                          isSecure: false,
                                          dropdownItems: [
                                            KeyValue(
                                                key: AppLocalizations.of(
                                                        context)!
                                                    .maleText,
                                                value: AppLocalizations.of(
                                                        context)!
                                                    .maleText),
                                            KeyValue(
                                                key: AppLocalizations.of(
                                                        context)!
                                                    .femaleText,
                                                value: AppLocalizations.of(
                                                        context)!
                                                    .femaleText),
                                            KeyValue(
                                                key: AppLocalizations.of(
                                                        context)!
                                                    .othersText,
                                                value: AppLocalizations.of(
                                                        context)!
                                                    .othersText)
                                          ],
                                          dropdownType: DropDownType.none,
                                          onTextChanged: (text) {
                                            request.gender = text;
                                          },
                                        ),
                                        AppTextField(
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .emailText,
                                          type: TextFieldType.email,
                                          isSecure: false,
                                          onTextChanged: (text) {
                                            request.email = text;
                                          },
                                        ),
                                        AppTextField(
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .mobileNumberText,
                                          type: TextFieldType.mobileNumber,
                                          isSecure: false,
                                          onTextChanged: (text) {
                                            request.mobileNumber = text;
                                          },
                                        ),
                                        DatePickerTextField(
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .dobText,
                                          initialDate: '',
                                          lastDate: DateFormat(DateFormatType
                                                  .yearMonthDayDashed.pattern)
                                              .format(DateTime.now().subtract(
                                                  const Duration(days: 1000))),
                                          onTextChanged: (value) {
                                            request.dob = value;
                                          },
                                          controller: dobController,
                                        ),
                                        AppTextField(
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .passwordText,
                                          type: TextFieldType.password,
                                          isSecure: true,
                                          onTextChanged: (text) {
                                            request.password = text;
                                            _setConfirmPasswordCheckvalue(text);
                                          },
                                        ),
                                        AppTextField(
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .confirmPasswordText,
                                          type: TextFieldType.confirmPassword,
                                          isSecure: true,
                                          defaultCheckValue:
                                              confirmPasswordCheck,
                                          onTextChanged: (text) {
                                            request.repassword = text;
                                          },
                                        ),
                                      ].withSpaceBetween(height: 20.0),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: isAgreed,
                                        onChanged: (newValue) {
                                          setState(() {
                                            isAgreed = newValue ?? false;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .agreeTermsandConditionText,
                                                style: AppFonts.bodyTextStyle(
                                                    color: AppColors
                                                        .textGreyColor),
                                              ),
                                              const TextSpan(
                                                text: ' ', // Add a space here
                                              ),
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .termsOfServiceText,
                                                style: AppFonts.bodyTextStyle(
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                              const TextSpan(
                                                text: ' ', // Add a space here
                                              ),
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .andText,
                                                style: AppFonts.bodyTextStyle(
                                                    color: AppColors
                                                        .textGreyColor),
                                              ),
                                              const TextSpan(
                                                text: ' ', // Add a space here
                                              ),
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .privacyPolictText,
                                                style: AppFonts.bodyTextStyle(
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  AppButton(
                                    title: AppLocalizations.of(context)!
                                        .nextBotton,
                                    onPressed: () {
                                      _validate();
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
          ],
        ),
      ),
    );
  }
}
