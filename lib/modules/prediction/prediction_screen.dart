import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/custom_views/textfield/app_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:sugar_smart_assist/modules/confirm_view/confirm_screen_arguments.dart';
import 'package:sugar_smart_assist/modules/dropdown/dropdown_screen_arguments.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_screen_api.dart';

class PredictionScreen extends StatefulWidget {
  PredictionScreen({Key? key, this.healthReq}) : super(key: key);

  PredictionModel? healthReq;

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedGender = '';
  PredictionModel request = PredictionModel();
  bool isUpdatePersonal = true;

  late PredictionApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = PredictionApiService(context: context);
    if (widget.healthReq != null) {
      setState(() {
        request = widget.healthReq!;
        selectedGender = request.gender;
      });
    }
  }

  Future _predictDiabetes() async {
    if (_formKey.currentState!.validate()) {
      if (request.gender == AppLocalizations.of(_getContext())!.maleText) {
        request.pregnancies = '0';
      }
      var res = await apiService.makeApiCall(request);
      if (res != null) {
        request.outcome = res.prediction;
        request.timeToDiabetes = res.estimatedTimeToDiabetes;
        request.suggestion = res.suggestions;
        _savePrediction();
      }
    }
  }

  void _savePrediction() async {
    var res = await apiService.savePredictionResult(request, isUpdatePersonal);
    if (res != null) {
      _navigateToDetailScreen(res, request.outcome);
    }
  }

  void _navigateToDetailScreen(String id, String outcome) async {
    List<KeyValue> data = [
      KeyValue(key: AppLocalizations.of(context)!.ageText, value: request.age),
      KeyValue(
          key: AppLocalizations.of(context)!.genderText, value: request.gender),
      KeyValue(
          key: AppLocalizations.of(context)!.pregnanciesText,
          value: request.pregnancies),
      KeyValue(
          key: '${AppLocalizations.of(context)!.glucoseText} (mg/dL)',
          value: request.glucose),
      KeyValue(
          key: '${AppLocalizations.of(context)!.bloodPressureText} (mmHg)',
          value: request.bloodpressure),
      KeyValue(
          key: AppLocalizations.of(context)!.skinnThicknessText,
          value: request.skinthickness),
      KeyValue(
          key: '${AppLocalizations.of(context)!.insulinText} (IU/mL)',
          value: request.insulin),
      KeyValue(
          key: AppLocalizations.of(context)!.diabetesPedigreeFunctionText,
          value: request.diabetesPedigreeFunction),
      KeyValue(
          key: '${AppLocalizations.of(context)!.bmiText} (kg/m^2)',
          value: request.bmi),
      KeyValue(
          key: AppLocalizations.of(context)!.outcomeText,
          value: (request.outcome == '1.0' || request.outcome == '1')
              ? 'Positive'
              : 'Negative'),
      KeyValue(
          key: AppLocalizations.of(context)!.chanceToDiabetesText,
          value: (request.outcome == '1.0' || request.outcome == '1')
              ? ''
              : '${(double.parse(request.timeToDiabetes) * 100).toStringAsFixed(0)} %'),
    ];

    final args = ConfirmScreenArguments(
      AppLocalizations.of(_getContext())!.predictionScreenTitle,
      data
          .where((item) => (item.value.isNotEmpty || item.childs.isNotEmpty))
          .toList(),
      id,
      outcome,
      request,
      await apiService.getSuggestion(id),
      ConfirmScreenType.detail,
    );
    Navigator.push(context, AppRouter().start(confirmScreen, args));
  }

  BuildContext _getContext() {
    return context;
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
                                    preText: request.age,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.age = text;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    preText: request.gender,
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
                                        request.gender = text;
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
                                          preText: request.pregnancies,
                                          onTextChanged: (text) {
                                            request.pregnancies = text;
                                          },
                                          minValue: 0,
                                          maxValue: 17,
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .glucoseText,
                                    type: TextFieldType.numberpad,
                                    preText: request.glucose,
                                    onTextChanged: (text) {
                                      request.glucose = text;
                                    },
                                    minValue: 0,
                                    maxValue: 199,
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .bloodPressureText,
                                    preText: request.bloodpressure,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.bloodpressure = text;
                                    },
                                    minValue: 0,
                                    maxValue: 122,
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .skinnThicknessText,
                                    preText: request.skinthickness,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.skinthickness = text;
                                    },
                                    minValue: 0,
                                    maxValue: 99,
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder: AppLocalizations.of(context)!
                                        .insulinText,
                                    preText: request.insulin,
                                    type: TextFieldType.numberpad,
                                    onTextChanged: (text) {
                                      request.insulin = text;
                                    },
                                    minValue: 0,
                                    maxValue: 846,
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    preText: request.diabetesPedigreeFunction,
                                    placeholder: AppLocalizations.of(context)!
                                        .diabetesPedigreeFunctionText,
                                    type: TextFieldType.numberpadWithDecimal,
                                    onTextChanged: (text) {
                                      request.diabetesPedigreeFunction = text;
                                    },
                                    minValue: 0,
                                    maxValue: 2.42,
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    placeholder:
                                        AppLocalizations.of(context)!.bmiText,
                                    preText: request.bmi,
                                    type: TextFieldType.numberpadWithDecimal,
                                    onTextChanged: (text) {
                                      request.bmi = text;
                                    },
                                    minValue: 0,
                                    maxValue: 67.1,
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isUpdatePersonal,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isUpdatePersonal = newValue ?? false;
                                      });
                                    },
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .updatePersonalHealthMetrices,
                                          style: AppFonts.bodyTextStyle(
                                              color: AppColors.textGreyColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              AppButton(
                                title: AppLocalizations.of(context)!
                                    .predictButtonText,
                                onPressed: () {
                                  _predictDiabetes();
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
