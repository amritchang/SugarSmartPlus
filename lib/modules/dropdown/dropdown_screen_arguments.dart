import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DropDownType { none }

class DropdownScreenArguments {
  final String? title;
  final List<KeyValue> list;
  final DropDownType type;
  final TextEditingController textEditingController;
  final Function(KeyValue, DropDownType) onItemSelected;

  DropdownScreenArguments(
    this.title,
    this.list,
    this.type,
    this.textEditingController,
    this.onItemSelected,
  );
}
