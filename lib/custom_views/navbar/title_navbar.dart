import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';

class TitleNavBar extends StatefulWidget implements PreferredSizeWidget {
  const TitleNavBar({
    required this.title,
    this.bgColor,
    this.tintColor,
    this.rightButtonWidget,
    this.rightButtonCompletion,
    this.shouldShowBackButton, // Add a new property for the completion handle
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String title;
  final Color? bgColor;
  final Color? tintColor;
  final Widget? rightButtonWidget;
  final Function()? rightButtonCompletion; // The completion handle property
  final bool? shouldShowBackButton;
  @override
  final Size preferredSize;

  @override
  _TitleNavBarState createState() => _TitleNavBarState();
}

class _TitleNavBarState extends State<TitleNavBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: AppFonts.navTitleTextStyle(
          color: widget.tintColor ?? AppColors.themeBlack,
        ),
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: widget.bgColor ?? AppColors.themeWhite,
      leading: widget.shouldShowBackButton == false
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              color: widget.tintColor ?? AppColors.themeBlack,
              onPressed: () {
                // Navigate back to the previous screen when the back button is pressed.
                Navigator.of(context).pop();
              },
            ),
      actions: <Widget>[
        if (widget.rightButtonCompletion != null &&
            widget.rightButtonWidget != null)
          GestureDetector(
            onTap: widget.rightButtonCompletion,
            child: widget.rightButtonWidget!,
          ),
        if (widget.rightButtonCompletion != null &&
            widget.rightButtonWidget == null)
          IconButton(
            icon: const Icon(Icons.info),
            color: widget.tintColor ?? AppColors.themeBlack,
            onPressed: widget.rightButtonCompletion,
          ),
      ],
    );
  }
}
