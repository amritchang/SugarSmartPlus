import 'package:sugar_smart_assist/models/key_value.dart';

enum ConfirmScreenType { receipt, none, paymentConfirm }

class ConfirmScreenButtonSelectionArguments {
  ConfirmScreenButtonSelectionArguments();
}

class ConfirmScreenArguments {
  final String title;
  final List<KeyValue> data;
  final void Function(ConfirmScreenButtonSelectionArguments?) onConfirmAction;
  ConfirmScreenType type;

  ConfirmScreenArguments(
      this.title, this.data, this.type, this.onConfirmAction);
}
