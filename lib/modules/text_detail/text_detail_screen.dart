import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/navbar/title_navbar.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/modules/text_detail/text_detail_screen_arguments.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/shadow.dart';

class TextDetailScreen extends StatefulWidget {
  final TextDetailScreenArguments args;
  const TextDetailScreen({Key? key, required this.args}) : super(key: key);
  @override
  _TextDetailScreenState createState() => _TextDetailScreenState();
}

class _TextDetailScreenState extends State<TextDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleNavBar(
        title: widget.args.title,
        bgColor: AppColors.primaryBackgroundColor,
        tintColor: AppColors.themeBlack,
      ),
      body: _buildBody(),
      backgroundColor: AppColors.primaryBackgroundColor,
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.args.iconUrl != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: getCircularIconWithSize(widget.args.iconUrl ?? '',
                    Constant.defaultPaymentImage, 80),
              ),
            _buildDetail(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.themeWhite, // Background color
          borderRadius: BorderRadius.circular(10.0), // Corner radius
          boxShadow: cardShadow(),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.args.desc,
              style: AppFonts.screenSubTitleTextStyle(
                  color: AppColors.textGreyColor),
            ),
          ),
        ),
      ),
    );
  }
}
