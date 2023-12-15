class PredictionHistoryRequest {
  String startingDate;
  String endingDate;
  String? identifier;
  String? service;
  String? destination;
  String? serviceReceiver;
  int? page;
  String? transactionStatus;
  String? transactionType;

  // Constructor with default values
  PredictionHistoryRequest({
    this.startingDate = '',
    this.endingDate = '',
    this.identifier = '',
    this.service = '',
    this.destination = '',
    this.serviceReceiver = '',
    this.page = 1,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'startingDate': startingDate,
      'endingDate': endingDate,
      'identifier': identifier,
      'service': service,
      'destination': destination,
      'serviceReceiver': serviceReceiver,
      'page': '$page',
    };

    if (transactionStatus != null || transactionStatus == '') {
      jsonMap['transactionStatus'] = transactionStatus;
    }
    if (transactionType != null || transactionType == '') {
      jsonMap['transactionType'] = transactionType;
    }

    return jsonMap;
  }
}
