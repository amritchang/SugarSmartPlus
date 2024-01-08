import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';

class SignUpOptionScreen extends StatefulWidget {
  const SignUpOptionScreen({Key? key}) : super(key: key);

  @override
  _SignUpOptionScreenState createState() => _SignUpOptionScreenState();
}

class _SignUpOptionScreenState extends State<SignUpOptionScreen> {
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
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background Image
            const Image(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sugar Smart\nAssist',
                            style: AppFonts.titleBoldTextStyle(
                                color: AppColors.primaryColor, size: 24.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                              AppLocalizations.of(context)!
                                  .welcomeToSugarSmartAssistText,
                              style: AppFonts.titleBoldTextStyle()),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        AppButton(
                          title: AppLocalizations.of(context)!
                              .signUpWithEmailButton,
                          onPressed: () {
                            Navigator.push(context, AppRouter().start(signUp));
                          },
                          backgroundColor: AppColors.primaryColor,
                          iconName: 'profile.png',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.backgroundGrayColor,
                                ),
                              ),
                              Text(
                                'OR',
                                style: AppFonts.buttonTitleStyle(),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.backgroundGrayColor,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ].withSpaceBetween(width: 10.0),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppButton(
                          title:
                              '${AppLocalizations.of(context)!.alreadyHaveAccountText} ${AppLocalizations.of(context)!.loginButton}',
                          onPressed: () {
                            Navigator.push(context, AppRouter().start(login));
                          },
                          titleColor: AppColors.textBlackColor,
                          backgroundColor: AppColors.themeWhite,
                          iconName: 'profile.png',
                        ),
                      ],
                    ),
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
