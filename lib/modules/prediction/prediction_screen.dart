import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/custom_views/textfield/app_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:sugar_smart_assist/modules/dropdown/dropdown_screen_arguments.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_screen_api.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({Key? key}) : super(key: key);
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedGender = '';
  PredictionRequest request = PredictionRequest();

  late PredictionApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = PredictionApiService(context: context);
  }

  Future _triggerAPI() async {
    if (_formKey.currentState!.validate()) {}
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
                      title:
                          AppLocalizations.of(context)!.predictionScreenTitle,
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
                            AppLocalizations.of(context)!.predictionScreenTitle,
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
                                      .predictionScreenDesc,
                                  style: AppFonts.screenSubTitleTextStyle(
                                      color: AppColors.textGreyColor),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Form(
                                key: _formKey,
                                child: Column(children: [
                                  AppTextField(
                                    placeholder:
                                        AppLocalizations.of(context)!.ageText,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.age = text;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .genderText,
                                    type: TextFieldType.dropdown,
                                    isSecure: false,
                                    dropdownItems: [
                                      KeyValue(
                                          key: AppLocalizations.of(context)!
                                              .maleText,
                                          value: AppLocalizations.of(context)!
                                              .maleText),
                                      KeyValue(
                                          key: AppLocalizations.of(context)!
                                              .femaleText,
                                          value: AppLocalizations.of(context)!
                                              .femaleText),
                                      KeyValue(
                                          key: AppLocalizations.of(context)!
                                              .othersText,
                                          value: AppLocalizations.of(context)!
                                              .othersText)
                                    ],
                                    dropdownType: DropDownType.none,
                                    onTextChanged: (text) {
                                      setState(() {
                                        selectedGender = text;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Visibility(
                                    visible: selectedGender ==
                                        AppLocalizations.of(context)!
                                            .femaleText,
                                    child: Column(
                                      children: [
                                        AppTextField(
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .pregnanciesText,
                                          type: TextFieldType.numberpad,
                                          onTextChanged: (text) {
                                            request.pregnancies = text;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .glucoseText,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.glucose = text;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .bloodPressureText,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.bloodpressure = text;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .skinnThicknessText,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.skinthickness = text;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .insulinText,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.insulin = text;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder:
                                        AppLocalizations.of(context)!.bmiText,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.bmi = text;
                                    },
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 20),
                              AppButton(
                                title: AppLocalizations.of(context)!
                                    .predictButtonText,
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
