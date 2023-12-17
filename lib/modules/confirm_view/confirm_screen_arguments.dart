import 'package:sugar_smart_assist/models/key_value.dart';

enum ConfirmScreenType { detail, none }

class ConfirmScreenButtonSelectionArguments {
  ConfirmScreenButtonSelectionArguments();
}

class ConfirmScreenArguments {
  final String title;
  final List<KeyValue> data;
  final String predictionId;
  final String predictionOutcome;
  ConfirmScreenType type;

  ConfirmScreenArguments(this.title, this.data, this.predictionId,
      this.predictionOutcome, this.type);
}
