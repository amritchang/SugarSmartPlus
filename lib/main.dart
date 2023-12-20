import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/modules/dashboard/dashboard_tabbar.dart';
import 'package:sugar_smart_assist/modules/onboarding/onboarding.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:sugar_smart_assist/modules/signup/signup_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Storage.initContainer();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.remove();
  runApp(MyApp());
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Storage().isUserLoggedIn) {
      return MaterialApp(
        locale: _locale,
        navigatorKey: NavigationService.navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(30.0), // Adjust the value as needed
            ),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20.0), // Customize the bottom sheet shape
            ),
          ),
        ),
        home: const DashboardTabBar(),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: dashboardRoute,
      );
    } else if (Storage().isUserOnBoarded) {
      return MaterialApp(
        locale: _locale,
        navigatorKey: NavigationService.navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SignUpOptionScreen(),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: signUpOption,
      );
    } else {
      return MaterialApp(
        locale: _locale,
        navigatorKey: NavigationService.navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const OnBoardingScreen(),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: onBoardRouteFirst,
      );
    }
  }
}
