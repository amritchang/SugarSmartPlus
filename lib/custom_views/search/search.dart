import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget getSearchTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String labelText,
  Function(String)? onTextChanged,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppColors.textGreyColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onTextChanged,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                labelText: labelText,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryColor, // Set the icon's tint color
                ),
                border: InputBorder.none,
                labelStyle: AppFonts.bodyTextStyle(
                  color: AppColors.textGreyColor,
                ), // Apply the custom text font style
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.clear();
              FocusScope.of(context).unfocus();
            },
            child: Text(
              AppLocalizations.of(context)!.cancelButton,
              style: AppFonts.buttonTitleStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
