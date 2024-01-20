import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/custom_views/key_value_view.dart';
import 'package:sugar_smart_assist/custom_views/shadow.dart';
import 'package:sugar_smart_assist/modules/confirm_view/chat_gpt_api_model.dart';
import 'package:sugar_smart_assist/modules/confirm_view/confirm_screen_api.dart';
import 'package:sugar_smart_assist/modules/confirm_view/confirm_screen_arguments.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({required this.arguments, Key? key}) : super(key: key);

  final ConfirmScreenArguments arguments;

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  String? suggestionText;
  late ConfirmScreenApiService apiService;
  late ChatGPTApiService chatGptApiService;

  @override
  void initState() {
    super.initState();
    apiService = ConfirmScreenApiService(context: context);
    chatGptApiService = ChatGPTApiService(context: context);
    suggestionText = widget.arguments.suggestionText;
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _getQuestion() {
    var model = widget.arguments.predictionModel;
    if (model != null) {
      return 'My health metrices are \n ${model.toJson()}\n with outcome as positive to diabetes. I know you are not a doctor but could you give me list of 5 with some general lifestyle recommendations to prevent diabetes.';
    }
    return '';
  }

  void _getChatGPTSuggestions() async {
    var question = _getQuestion();
    var res = await chatGptApiService.getChatGPTSuggestion(question);
    if (res != null) {
      var savedResponse = await apiService.saveToSuggestion(
          widget.arguments.predictionId, question, res);
      if (savedResponse != null) {
        setState(() {
          suggestionText = res;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: TitleNavBar(
          title: widget.arguments.title.capitalize ?? '',
          bgColor: AppColors.primaryBackgroundColor,
          tintColor: AppColors.themeBlack,
          shouldShowBackButton:
              widget.arguments.type == ConfirmScreenType.none),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildList(),
            const SizedBox(height: 20),
            if (suggestionText != null && (suggestionText ?? '').isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: AppButton(
                  title: AppLocalizations.of(context)!
                      .getMeChatGptSuggestionButtonText,
                  onPressed: () {
                    _getChatGPTSuggestions();
                  },
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            if (suggestionText != null && (suggestionText ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.themeWhite, // Background color
                    borderRadius: BorderRadius.circular(10.0), // Corner radius
                    boxShadow: cardShadow(),
                  ),
                  height: 200,
                  width: MediaQuery.sizeOf(context).width -
                      (16 * 2), // Set the desired height
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.suggestionText,
                            style: AppFonts.titleBoldTextStyle(
                                color: AppColors.textBlackColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            suggestionText ?? '',
                            style: AppFonts.bodyTextStyle(
                                color: AppColors.textBlackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (widget.arguments.type != ConfirmScreenType.none)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: AppButton(
                  title: AppLocalizations.of(context)!.goBackToDashboardText,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, AppRouter().start(dashboardRoute));
                  },
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.themeWhite, // Background color
            borderRadius: BorderRadius.circular(10.0), // Corner radius
            boxShadow: cardShadow(),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
            child: Column(
              children: <Widget>[
                for (KeyValue keyValue in widget.arguments.data) ...[
                  KeyValueView(
                    data: keyValue,
                    alignment: CrossAxisAlignment.start,
                    keyAlignment: TextAlign.left,
                    valueAlignment: TextAlign.right,
                    hideDot: true,
                  ),
                ],
              ],
            ),
          )),
    );
  }
}
