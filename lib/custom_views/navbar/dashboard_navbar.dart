import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:sugar_smart_assist/models/user.dart';

class DashboardAppNavBar extends StatefulWidget implements PreferredSizeWidget {
  DashboardAppNavBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _DashboardAppNavBarState createState() => _DashboardAppNavBarState();
}

class _DashboardAppNavBarState extends State<DashboardAppNavBar> {
  late UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    var res = await Storage().getUser();
    if (res != null) {
      user = res;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.push(context, AppRouter().start(profile));
        },
        child: Row(
          children: [
            getCircularIconWithSize('', Constant.defaultProfileImage, 40.0),
            Text(
              user.fullName ?? '',
              style: AppFonts.titleBoldTextStyle(color: AppColors.themeBlack),
            ),
          ].withSpaceBetween(width: 10.0),
        ),
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: getIconWithSize('notification.png', 24.0, 24.0),
            )),
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: getIconWithSize('search.png', 24.0, 24.0),
            )),
      ],
      actionsIconTheme: const IconThemeData(
          size: 24.0, color: AppColors.themeBlack, opacity: 10.0),
    );
  }
}
