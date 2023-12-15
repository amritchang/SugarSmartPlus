class PredictionHistoryResponse {
  String? date;
  String? transactionIdentifier;
  String? transactionType;
  double? amount;
  String? destinationOwnerName;
  String? destinationAccount;
  String? transactionStatus;
  String? serviceName;
  List<dynamic>? purchaseOrderDtos = const [];

  // Constructor with default values
  PredictionHistoryResponse({
    this.date = '',
    this.transactionIdentifier = '',
    this.transactionType = '',
    this.amount = 0,
    this.destinationOwnerName = '',
    this.destinationAccount = '',
    this.transactionStatus = '',
    this.serviceName = '',
    this.purchaseOrderDtos,
  });

  factory PredictionHistoryResponse.fromJson(Map<String, dynamic> json) {
    String? apiServiceName;
    if (json.containsKey("requestDetail")) {
      Map<String, dynamic> requestDetail = json["requestDetail"];
      if (requestDetail.containsKey("serviceName") &&
          requestDetail["serviceName"] is String) {
        apiServiceName = requestDetail["serviceName"];
      }
    }
    return PredictionHistoryResponse(
      date: json['date'],
      transactionIdentifier: json['transactionIdentifier'],
      transactionType: json['transactionType'],
      amount: json['amount'],
      destinationOwnerName: json['destinationOwnerName'],
      destinationAccount: json['destinationAccount'],
      transactionStatus: json['transactionStatus'],
      serviceName: apiServiceName,
      purchaseOrderDtos: json['purchaseOrderDtos'],
    );
  }
}
