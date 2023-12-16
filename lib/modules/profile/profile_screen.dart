import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:sugar_smart_assist/custom_views/border_view.dart';
import 'package:sugar_smart_assist/custom_views/profile/menu_list_item_view.dart';
import 'package:sugar_smart_assist/custom_views/profile/menu_list_title_view.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/models/menu.dart';
import 'package:sugar_smart_assist/models/section_menu.dart';
import 'package:sugar_smart_assist/modules/profile/profile_screen_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugar_smart_assist/custom_views/shadow.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/custom_views/profile/user_profile_view.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileApiService apiService;
  List<SectionMenu> _mainMenus = [];

  int listCount = 0;

  @override
  void initState() {
    super.initState();
    apiService = ProfileApiService(context: context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initMainMenus();
    listCount = _mainMenus.fold(
      0,
      (count, sectionMenu) => count + sectionMenu.menus.length,
    );
  }

  void _initMainMenus() {
    _mainMenus = [
      SectionMenu(
          title: AppLocalizations.of(context)!.profileSettingsText,
          menus: [
            Menu(
                menuName: AppLocalizations.of(context)!.changePasswordText,
                menuType: MenuType.changePassword,
                defaultMenuIcon: 'change_password.png'),
            Menu(
                menuName: AppLocalizations.of(context)!.deleteUserText,
                menuType: MenuType.deleteUser,
                defaultMenuIcon: 'delete_user.png'),
            Menu(
                menuName: AppLocalizations.of(context)!.selectLanguageText,
                menuType: MenuType.changeLanguage,
                defaultMenuIcon: 'change_language.png'),
          ])
    ];
  }

  void _onMenuSelection(Menu menu) {
    switch (menu.menuType) {
      case MenuType.changeLanguage:
        Navigator.push(context, AppRouter().start(changeLanguage));
      case MenuType.changePassword:
        showAlertDialogWithTwoButtons(
            AppLocalizations.of(context)!.changePasswordAlertTitle,
            AppLocalizations.of(context)!.changePasswordAlertDesc,
            AppLocalizations.of(context)!.cancelButton,
            AppLocalizations.of(context)!.confirmButton,
            context,
            onLeftPressed: () {}, onRightPressed: () {
          Navigator.push(context, AppRouter().start(changePassword));
        });
      case MenuType.deleteUser:
        showAlertDialogWithTwoButtons(
            AppLocalizations.of(context)!.deleteAccountAlertTitle,
            AppLocalizations.of(context)!.deleteAccountAlertDesc,
            AppLocalizations.of(context)!.cancelButton,
            AppLocalizations.of(context)!.deleteUserText,
            context,
            onLeftPressed: () {}, onRightPressed: () {
          _deleteUser();
        });
      default:
        break;
    }
  }

  void _deleteUser() async {
    var res = await apiService.deleteUserFromFirestore();
    if (res != null) {
      showAlertDialogWithOk(
          AppLocalizations.of(getContext())!.successText,
          AppLocalizations.of(getContext())!.userDeletedText,
          getContext(), onOkPressed: () {
        Storage().deleteAll();
        _navigateToLoginScreen();
      });
    }
  }

  BuildContext getContext() {
    return context;
  }

  void _logout() async {
    showAlertDialogWithTwoButtons(
        AppLocalizations.of(context)!.logoutAlertTitle,
        AppLocalizations.of(context)!.logoutAlertDesc,
        AppLocalizations.of(context)!.cancelButton,
        AppLocalizations.of(context)!.logoutText,
        context,
        onLeftPressed: () {}, onRightPressed: () {
      _triggerLogOutApi();
    });
  }

  void _triggerLogOutApi() async {
    try {
      await FirebaseAuth.instance.signOut();
      Storage().deleteAll();
      _navigateToLoginScreen();
    } catch (e) {
      showAlertDialogWithOk(
          AppLocalizations.of(getContext())!.errorText, '$e', getContext());
    }
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(context, AppRouter().start(logout));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleNavBar(
          title: AppLocalizations.of(context)!.profileScreenTitleText,
          bgColor: AppColors.primaryBackgroundColor,
          tintColor: AppColors.themeBlack),
      body: _buildBody(),
      backgroundColor: AppColors.primaryBackgroundColor,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                const UserProfileView(),
                getBorderLineView(),
              ].withSpaceBetween(height: 20),
            ),
          ),
          SizedBox(
            height: (92 * listCount).toDouble(),
            child: _buildList(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 60),
            child: AppButton(
              title: AppLocalizations.of(context)!.logoutText,
              onPressed: () {
                _logout();
              },
              backgroundColor: AppColors.primaryColor,
            ),
          )
        ].withSpaceBetween(height: 24),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _mainMenus.length,
      itemBuilder: (context, index) {
        final section = _mainMenus[index];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: getMenuListTitleView(section.title),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.themeWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: cardShadow(),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: (section.menus).asMap().entries.map((entry) {
                    final menu = entry.value;
                    final index = entry.key;
                    return GestureDetector(
                      onTap: () {
                        _onMenuSelection(menu);
                      },
                      child: ListTile(
                        title: getMenuListItemView(
                          menu,
                          index < section.menus.length - 1,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
