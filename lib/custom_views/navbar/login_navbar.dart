import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';

class LoginScreenAppNavBar extends StatefulWidget
    implements PreferredSizeWidget {
  LoginScreenAppNavBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _LoginScreenAppNavBarState createState() => _LoginScreenAppNavBarState();
}

class _LoginScreenAppNavBarState extends State<LoginScreenAppNavBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Sugar Smart\nAssist',
          style: AppFonts.titleBoldTextStyle(
              color: AppColors.primaryColor, size: 24.0)),
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, AppRouter().start(changeLanguage));
              },
              child: getIconWithSize('language.png', 24.0, 24.0),
            )),
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: getIconWithSize('message.png', 24.0, 24.0),
            )),
      ],
      actionsIconTheme: const IconThemeData(
          size: 24.0, color: AppColors.themeWhite, opacity: 10.0),
    );
  }
}
