import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/custom_views/key_value_view.dart';
import 'package:sugar_smart_assist/custom_views/shadow.dart';
import 'package:sugar_smart_assist/modules/confirm_view/confirm_screen_arguments.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({required this.arguments, Key? key}) : super(key: key);

  final ConfirmScreenArguments arguments;

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _getButtonTitle() {
    return AppLocalizations.of(context)!.confirmButton;
  }

  void _handleButtonAction() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: TitleNavBar(
          title: widget.arguments.title.capitalize ?? '',
          bgColor: AppColors.primaryBackgroundColor,
          tintColor: AppColors.themeBlack,
          shouldShowBackButton:
              widget.arguments.type != ConfirmScreenType.receipt),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (widget.arguments.type != ConfirmScreenType.receipt)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context)!.confirmScreenSubTitle,
                    style: AppFonts.screenSubTitleTextStyle(
                        color: AppColors.textGreyColor),
                  ),
                ),
              ),
            _buildList(),
            SizedBox(
                height:
                    (widget.arguments.type == ConfirmScreenType.paymentConfirm)
                        ? 10
                        : 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: AppButton(
                title: widget.arguments.type == ConfirmScreenType.receipt
                    ? AppLocalizations.of(context)!.goBackToDashboardText
                    : _getButtonTitle(),
                onPressed: () {},
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
                    valueAlignment:
                        widget.arguments.type == ConfirmScreenType.receipt
                            ? TextAlign.right
                            : TextAlign.left,
                    hideDot: widget.arguments.type == ConfirmScreenType.receipt,
                  ),
                ],
              ],
            ),
          )),
    );
  }
}
