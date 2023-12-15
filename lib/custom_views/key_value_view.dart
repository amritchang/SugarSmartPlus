import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/models/key_value.dart';

class KeyValueView extends StatelessWidget {
  final KeyValue data;
  final CrossAxisAlignment alignment;
  final TextAlign keyAlignment;
  final TextAlign valueAlignment;
  final bool hideDot;

  KeyValueView({
    required this.data,
    this.alignment = CrossAxisAlignment.start,
    this.keyAlignment = TextAlign.left,
    this.valueAlignment = TextAlign.left,
    this.hideDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                data.key,
                style: AppFonts.bodyTextStyle(color: AppColors.textGreyColor),
                textAlign: keyAlignment,
              ),
              if (!hideDot)
                Text(
                  ':',
                  style: AppFonts.bodyTextStyle(color: AppColors.textGreyColor),
                ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Text(
                  data.value,
                  style: AppFonts.bodyTextStyle(color: AppColors.textGreyColor),
                  textAlign: valueAlignment,
                ),
              ),
            ],
          ),
          if (data.childs.isNotEmpty) const SizedBox(height: 5),
          for (KeyValue keyValue in data.childs) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: KeyValueView(
                data: keyValue,
                alignment: CrossAxisAlignment.start,
                keyAlignment: keyAlignment,
                valueAlignment: valueAlignment,
                hideDot: true,
              ),
            )
          ],
        ],
      ),
    );
  }
}
