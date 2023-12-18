import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';

enum ConfirmScreenType { detail, none }

class ConfirmScreenButtonSelectionArguments {
  ConfirmScreenButtonSelectionArguments();
}

class ConfirmScreenArguments {
  final String title;
  final List<KeyValue> data;
  final String predictionId;
  final String predictionOutcome;
  final PredictionModel? predictionModel;
  final String? suggestionText;

  ConfirmScreenType type;

  ConfirmScreenArguments(
      this.title,
      this.data,
      this.predictionId,
      this.predictionOutcome,
      this.predictionModel,
      this.suggestionText,
      this.type);
}
