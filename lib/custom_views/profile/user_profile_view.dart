import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/models/user.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  UserModel user = UserModel();

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getCircularIconWithSize('', Constant.defaultProfileImage, 100.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${user.fullName}',
              style: AppFonts.titleTextStyle(
                color: AppColors.textBlackColor,
              ),
            ),
            Text(
              '${user.email}',
              style: AppFonts.bodyTextStyle(
                color: AppColors.textBlackColor,
              ),
            ),
          ],
        )
      ].withSpaceBetween(width: 10.0),
    );
  }
}
