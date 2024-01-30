import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/modules/change_password/change_passwrord.dart';
import 'package:sugar_smart_assist/modules/confirm_view/confirm_screen.dart';
import 'package:sugar_smart_assist/modules/confirm_view/confirm_screen_arguments.dart';
import 'package:sugar_smart_assist/modules/dropdown/dropdown_screen.dart';
import 'package:sugar_smart_assist/modules/dropdown/dropdown_screen_arguments.dart';
import 'package:sugar_smart_assist/modules/language_selection/language_change.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_screen.dart';
import 'package:sugar_smart_assist/modules/text_detail/text_detail_screen.dart';
import 'package:sugar_smart_assist/modules/text_detail/text_detail_screen_arguments.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history.dart';
import 'package:sugar_smart_assist/modules/login/login.dart';
import 'package:sugar_smart_assist/modules/signup/signup/signup.dart';
import 'package:sugar_smart_assist/modules/signup/signup_option.dart';
import 'package:sugar_smart_assist/modules/onboarding/onboarding.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/modules/dashboard/dashboard_tabbar.dart';
import 'package:sugar_smart_assist/modules/profile/profile_screen.dart';

const String onBoardRouteFirst = '/onBoard1';
const String onBoardRouteSecond = '/onBoard2';
const String onBoardRouteThird = '/onBoard3';
const String signUpOption = '/choose/signup';
const String dashboard = '/dashboard';
const String login = '/login';
const String logout = '/logout';
const String signUp = '/signup';
const String dashboardRoute = '/dashboard';
const String profile = '/profile';
const String confirmScreen = '/confirm';
const String detailScreen = '/detail';
const String dropdown = '/dropdown';
const String history = '/history';
const String changeLanguage = '/changeLanguage';
const String changePassword = '/change/password';
const String prediction = '/prediction';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onBoardRouteFirst:
        return MaterialPageRoute(
            builder: (context) => OnBoardingScreen(
                screen: 1,
                titleText:
                    AppLocalizations.of(context)!.onBoardFirstScreenTitle,
                subTitleText:
                    AppLocalizations.of(context)!.onBoardFirstScreenSubTitle));
      case signUpOption:
        return MaterialPageRoute(builder: (_) => const SignUpOptionScreen());
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => const DashboardTabBar());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

  Widget getWidget(String routeName, BuildContext context, Object? arguments) {
    switch (routeName) {
      case onBoardRouteFirst:
        return OnBoardingScreen(
            screen: 1,
            titleText: AppLocalizations.of(context)!.onBoardFirstScreenTitle,
            subTitleText:
                AppLocalizations.of(context)!.onBoardFirstScreenSubTitle);
      case onBoardRouteSecond:
        return OnBoardingScreen(
            screen: 2,
            titleText: AppLocalizations.of(context)!.onBoardSecondScreenTitle,
            subTitleText:
                AppLocalizations.of(context)!.onBoardSecondScreenSubTitle);
      case onBoardRouteThird:
        return OnBoardingScreen(
            screen: 3,
            titleText: AppLocalizations.of(context)!.onBoardThirdScreenTitle,
            subTitleText:
                AppLocalizations.of(context)!.onBoardThirdScreenSubTitle);
      case signUpOption:
        return const SignUpOptionScreen();
      case signUp:
        return const SignUpcreen();

      case login:
        return LoginScreen(
          shouldShowBackButton: true,
        );
      case logout:
        return LoginScreen(
          shouldShowBackButton: false,
        );
      case dashboardRoute:
        return const DashboardTabBar();
      case profile:
        return const ProfileScreen();
      case confirmScreen:
        return ConfirmScreen(
          arguments: arguments as ConfirmScreenArguments,
        );
      case changeLanguage:
        return const LanguageChangeScreen();
      case detailScreen:
        return TextDetailScreen(args: arguments as TextDetailScreenArguments);
      case dropdown:
        return DropDownScreen(arguments: arguments as DropdownScreenArguments);
      case history:
        return const PredictionHistoryScreen();
      case changePassword:
        return const ChangePasswordScreen();
      case prediction:
        if (arguments == null) {
          return PredictionScreen();
        }
        return PredictionScreen(healthReq: arguments as PredictionModel);
      default:
        break;
    }
    return const OnBoardingScreen();
  }

  Route start(String name, [Object? arguments]) {
    switch (name) {
      case dashboard:
      case logout:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              getWidget(name, context, arguments),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final rotateAnim = Tween(begin: -pi, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: rotateAnim,
              child: child,
              builder: (context, widget) {
                final value = min(rotateAnim.value, pi / 2);
                return Transform(
                  transform: Matrix4.rotationY(value.toDouble()),
                  alignment: Alignment.center,
                  child: widget,
                );
              },
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) => getWidget(name, context, arguments),
        );
    }
  }
}
