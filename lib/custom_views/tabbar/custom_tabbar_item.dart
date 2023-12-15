import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  final String iconImage;
  final String label;
  final bool selected;
  final double iconSize;
  final Color selectionColor;
  final Color unSelectionColor;
  final VoidCallback? onTap; // Callback to be called when tapped

  const CustomBottomNavigationBarItem({
    required this.iconImage,
    required this.label,
    required this.selected,
    required this.iconSize,
    required this.selectionColor,
    required this.unSelectionColor,
    this.onTap, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the onTap callback when tapped
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getTemplatedIconWithSize(iconImage,
              selected ? selectionColor : unSelectionColor, iconSize, iconSize),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                label.replaceAll(" ", "\n"),
                style: AppFonts.bodyTextStyle(
                    color: selected ? selectionColor : unSelectionColor),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ].withSpaceBetween(height: 8),
      ),
    );
  }
}
