import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingScreen extends StatefulWidget {
  final int screen;
  final String titleText;
  final String subTitleText;
  final String backgroundImage;

  const OnBoardingScreen(
      {Key? key,
      this.screen = 1,
      this.titleText = '',
      this.subTitleText = '',
      this.backgroundImage = 'onBoardingBackground1.jpg'})
      : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
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
            Image(
              image: AssetImage('assets/images/${widget.backgroundImage}'),
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
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sugar Smart\nAssist',
                            style: AppFonts.titleBoldTextStyle(
                                color: AppColors.primaryColor, size: 24.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 220,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.titleText,
                              style: AppFonts.screenTitleBoldTextStyle()),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.subTitleText,
                            style: AppFonts.bodyTextStyle(
                                color: AppColors.textGreyColor),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 100.0,
                            child: AppButton(
                              title: AppLocalizations.of(context)!.nextBotton,
                              onPressed: () {
                                switch (widget.screen) {
                                  case 1:
                                    Navigator.pushReplacement(context,
                                        AppRouter().start(onBoardRouteSecond));
                                    break;
                                  case 2:
                                    Navigator.pushReplacement(context,
                                        AppRouter().start(onBoardRouteThird));
                                    // Handle actions for screen2
                                    break;
                                  default:
                                    Storage().setUserOnBoarded(true);
                                    Navigator.pushReplacement(context,
                                        AppRouter().start(signUpOption));
                                  // Handle the default case (if needed)
                                }
                              },
                              backgroundColor: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 100.0,
                            child: AppButton(
                              title: AppLocalizations.of(context)!.skipButton,
                              onPressed: () {
                                Storage().setUserOnBoarded(true);
                                Navigator.pushReplacement(
                                    context, AppRouter().start(signUpOption));
                              },
                              backgroundColor: Colors.transparent,
                            ),
                          ),
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
