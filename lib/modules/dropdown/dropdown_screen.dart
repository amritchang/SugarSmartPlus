import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/modules/dropdown/dropdown_screen_arguments.dart';

class DropDownScreen extends StatelessWidget {
  final DropdownScreenArguments arguments;

  DropDownScreen({required this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleNavBar(
        title: arguments.title ?? '',
        bgColor: AppColors.themeWhite,
        tintColor: AppColors.themeBlack,
      ),
      backgroundColor: AppColors.themeWhite,
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        itemCount: arguments.list.length,
        separatorBuilder: (BuildContext context, int index) {
          // Add a divider between ListTiles
          return const Divider(
            color: AppColors.seperatorColor,
            height: 1.0,
          );
        },
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              arguments.list[index].value,
              style: AppFonts.bodyTextStyle(
                  color: AppColors.themeBlack, size: 18.0),
            ),
            onTap: () {
              arguments.onItemSelected(arguments.list[index], arguments.type);
              arguments.textEditingController.text =
                  arguments.list[index].value;
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
