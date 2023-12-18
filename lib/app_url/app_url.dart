class Constant {
  //test
  static String clientId = '';
  static String clientSecret = '';

  static String defaultCountryCode = '+1';

  static String defaultPaymentImage = "default.jpg";
  static String defaultProfileImage = "default_profile.jpg";

  static double bottomPadding = 100.0;

  static String userTable = 'users';
  static String predictionTable = 'prediction';
  static String historyTable = 'history';
  static String suggestionTable = 'suggestion';

  static String predictionModelUrl = 'http://127.0.0.1:5000/predict_diabetes';
  static String chatGPTUrl =
      'https://api.openai.com/v1/models/davinci-codex/completions';
  static String chatGPTKey =
      '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';
}
