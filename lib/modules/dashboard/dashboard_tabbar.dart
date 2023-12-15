import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/modules/dashboard/home/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history.dart';
import 'package:sugar_smart_assist/helper/local_auth_helper.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';

class DashboardTabBar extends StatelessWidget {
  const DashboardTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardTabBarWidget();
  }
}

class DashboardTabBarWidget extends StatefulWidget {
  const DashboardTabBarWidget({Key? key}) : super(key: key);

  @override
  _DashboardTabBarWidgetState createState() => _DashboardTabBarWidgetState();
}

class _DashboardTabBarWidgetState extends State<DashboardTabBarWidget> {
  int _selectedIndex = 0;
  late BiometricService biometricService;
  bool shouldShowMoreMenu = false;

  List<Widget> _children() => [
        const HomeScreen(),
        const PredictionHistoryScreen(),
      ];

  @override
  void initState() {
    super.initState();
    biometricService = BiometricService(context: context);
    if (!isBiometricAlertShown) {
      isBiometricAlertShown = true;
      _checkForBiometricAvailability();
    }
  }

  void _checkForBiometricAvailability() async {
    var isAlreadyEnabledBiometric = Storage().isBiometricLoginEnabled;
    if (!isAlreadyEnabledBiometric) {
      if (await biometricService.isBiometricAvailable()) {
        _showBiometricAlert();
      }
    }
  }

  void _showBiometricAlert() {
    showAlertDialogWithTwoButtons(
        AppLocalizations.of(context)!.enableBiometricLoginAlertTitle,
        AppLocalizations.of(context)!.enableBiometricLoginAlertDescription,
        AppLocalizations.of(context)!.cancelButton,
        AppLocalizations.of(context)!.okButton,
        context,
        onLeftPressed: () {}, onRightPressed: () {
      _authenicateBiometricAndSaveData(
          AppLocalizations.of(context)!.authenticateToSavePasswordText);
    });
  }

  void _authenicateBiometricAndSaveData(String message) async {
    var isAuthenticated = await biometricService.biometricLogin(message);
    if (isAuthenticated) {
      _showSuccessAuthenticationAlert();
      Storage().setIsBiometricLoginEnabled(true);
    }
  }

  void _showSuccessAuthenticationAlert() {
    showAlertDialogWithOk(AppLocalizations.of(context)!.successText,
        AppLocalizations.of(context)!.successAuthenticationText, context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleShouldShowMoreMenu() {
    setState(() {
      shouldShowMoreMenu = !shouldShowMoreMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();
    double iconSize = 26;
    Color selectionColor = AppColors.primaryColor;
    Color unSelectionColor = AppColors.themeBlack;

    final GlobalKey _bottomNavigationKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors
          .transparent, // Set the background color of the Scaffold to transparent
      body: Stack(
        children: [
          children.elementAt(_selectedIndex),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              key: _bottomNavigationKey,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedIconTheme: IconThemeData(color: selectionColor),
              selectedItemColor: AppColors.primaryColor,
              unselectedIconTheme: IconThemeData(color: unSelectionColor),
              unselectedItemColor: AppColors.themeBlack,
              selectedLabelStyle:
                  AppFonts.tabBarTitleTextStyle(color: selectionColor),
              unselectedLabelStyle:
                  AppFonts.tabBarTitleTextStyle(color: unSelectionColor),
              backgroundColor: AppColors.themeWhite,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: getTemplatedIconWithSize(
                      'tab_bar_first.png',
                      _selectedIndex == 0 ? selectionColor : unSelectionColor,
                      iconSize,
                      iconSize),
                  label: AppLocalizations.of(context)!.homeText,
                ),
                BottomNavigationBarItem(
                  icon: getTemplatedIconWithSize(
                      'tab_bar_second.png',
                      _selectedIndex == 1 ? selectionColor : unSelectionColor,
                      iconSize,
                      iconSize),
                  label: AppLocalizations.of(context)!.historyText,
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
