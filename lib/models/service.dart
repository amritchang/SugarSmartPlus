import 'package:sugar_smart_assist/models/key_value.dart';

class Service {
  final String? serviceId;
  final String? billerName;
  final int? id;
  final String? name;
  final String? uniqueIdentifier;
  final bool? priceInput;
  final bool? prefixInput;
  final int? minimumValue;
  final int? maximumValue;
  final bool? accRequired;
  final String? accFormat;
  final String? accountNo;
  final String? url;
  final bool? realTimeSettlement;
  final String? bankAccount;
  final String? tokenKey;
  final String? successURL;
  final String? failureURL;
  final String? notificationURL;
  final String? operation;
  final int? serviceCategoryId;
  final int? merchantId;
  final String? label;
  final String? description;
  final List<dynamic>? priceRange;
  final List<dynamic>? priceRangeInServiceCurrency;
  final List<dynamic>? prefixRange;
  final String? numericType;
  final int? labelLength;
  final String? icon;
  final String? image;
  final String? labelType;
  final int? documentId;
  final String? status;
  final String? serviceLocation;
  final bool? favorite;
  final dynamic amount;
  final int? count;
  final dynamic failureAmount;
  final bool? offlineMode;
  final bool? serviceAddedByMerchant;
  final String? serviceType;
  final String? serviceName;
  final bool? billRefType;
  final bool? allowRctRePrint;
  final bool? otpEnabled;
  final String? billerId;
  final String? receiptFooter;
  final String? receiptFooterLang;
  final String? merchantName;
  final List<dynamic>? merchantSolutionMetaDto;
  final List<AdditionalInputParameters>? additionalInputParameters;
  final dynamic extraInfo;
  final dynamic merchantSolutionProductDto;
  final String? paymentType;
  final dynamic feesDtos;
  final String? logo;
  final double? discount;
  final String? serviceCurrency;
  final String? baseCurrency;
  final dynamic currencyConversionsDto;
  final bool? isCustomerPropertyRequired;
  final bool? isQRPaymentAccepted;
  final bool? isBillInquiryRequired;
  final bool? inqRquired;
  final bool? mobileNotify;
  final bool? fracAccepted;
  final bool? prtAccepted;
  final bool? ovrAccepted;
  final bool? advAccepted;
  final bool? acptCartPayment;
  final String? billerIdLabel;
  final double? maximumValueInServiceCur;
  final bool? serviceInquiryRequired;

  Service({
    required this.serviceId,
    required this.billerName,
    required this.id,
    required this.name,
    required this.uniqueIdentifier,
    required this.priceInput,
    required this.prefixInput,
    required this.minimumValue,
    required this.maximumValue,
    required this.accRequired,
    this.accFormat,
    this.accountNo,
    this.url,
    required this.realTimeSettlement,
    this.bankAccount,
    this.tokenKey,
    this.successURL,
    this.failureURL,
    this.notificationURL,
    this.operation,
    required this.serviceCategoryId,
    required this.merchantId,
    required this.label,
    required this.description,
    this.priceRange,
    this.priceRangeInServiceCurrency,
    this.prefixRange,
    this.numericType,
    required this.labelLength,
    this.icon,
    this.image,
    this.labelType,
    required this.documentId,
    required this.status,
    required this.serviceLocation,
    required this.favorite,
    this.amount,
    required this.count,
    this.failureAmount,
    required this.offlineMode,
    required this.serviceAddedByMerchant,
    required this.serviceType,
    required this.serviceName,
    required this.billRefType,
    required this.allowRctRePrint,
    required this.otpEnabled,
    required this.billerId,
    this.receiptFooter,
    this.receiptFooterLang,
    this.merchantName,
    this.merchantSolutionMetaDto,
    this.extraInfo,
    this.merchantSolutionProductDto,
    this.additionalInputParameters,
    required this.paymentType,
    this.feesDtos,
    this.logo,
    required this.discount,
    required this.serviceCurrency,
    required this.baseCurrency,
    this.currencyConversionsDto,
    required this.isCustomerPropertyRequired,
    required this.isQRPaymentAccepted,
    required this.isBillInquiryRequired,
    required this.inqRquired,
    required this.mobileNotify,
    required this.fracAccepted,
    required this.prtAccepted,
    required this.ovrAccepted,
    required this.advAccepted,
    required this.acptCartPayment,
    this.billerIdLabel,
    this.maximumValueInServiceCur,
    this.serviceInquiryRequired,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    List<dynamic>? additionalInputParametersJson =
        json['additionalInputParameters'];
    List<AdditionalInputParameters>? additionalInputParametersList;

    if (additionalInputParametersJson != null) {
      additionalInputParametersList = List<AdditionalInputParameters>.from(
        additionalInputParametersJson
            .map((item) => AdditionalInputParameters.fromJson(item)),
      );
    }
    return Service(
      serviceId: json['serviceId'],
      billerName: json['billerName'],
      id: json['id'],
      name: json['name'],
      uniqueIdentifier: json['uniqueIdentifier'],
      priceInput: json['priceinput'],
      prefixInput: json['prefixInput'],
      minimumValue: json['minimumvalue'],
      maximumValue: json['maximumvalue'],
      accRequired: json['accrequired'],
      accFormat: json['accformat'],
      accountNo: json['accountno'],
      url: json['url'],
      realTimeSettlement: json['realTimeSettlement'],
      bankAccount: json['bankAccount'],
      tokenKey: json['tokenKey'],
      successURL: json['successURL'],
      failureURL: json['failureURL'],
      notificationURL: json['notificationURL'],
      operation: json['operation'],
      serviceCategoryId: json['serviceCategoryId'],
      merchantId: json['merchantId'],
      label: json['label'],
      description: json['description'],
      priceRange: json['priceRange'],
      priceRangeInServiceCurrency: json['priceRangeInServiceCurrency'],
      prefixRange: json['prefixRange'],
      numericType: json['numericType'],
      labelLength: json['labelLength'],
      icon: json['icon'],
      image: json['image'],
      labelType: json['labelType'],
      documentId: json['documentId'],
      status: json['status'],
      serviceLocation: json['serviceLocation'],
      favorite: json['favorite'],
      amount: json['amount'],
      count: json['count'],
      failureAmount: json['failureAmount'],
      offlineMode: json['offlineMode'],
      serviceAddedByMerchant: json['serviceAddedByMerchant'],
      serviceType: json['serviceType'],
      serviceName: json['serviceName'],
      billRefType: json['billRefType'],
      allowRctRePrint: json['allowRctRePrint'],
      otpEnabled: json['otpEnabled'],
      billerId: json['billerId'],
      receiptFooter: json['receiptFooter'],
      receiptFooterLang: json['receiptFooterLang'],
      merchantName: json['merchantName'],
      merchantSolutionMetaDto: json['merchantSolutionMetaDto'],
      additionalInputParameters: additionalInputParametersList,
      extraInfo: json['extraInfo'],
      merchantSolutionProductDto: json['merchantSolutionProductDto'],
      paymentType: json['paymentType'],
      feesDtos: json['feesDtos'],
      logo: json['logo'],
      discount: json['discount'],
      serviceCurrency: json['serviceCurrency'],
      baseCurrency: json['baseCurrency'],
      currencyConversionsDto: json['currencyConversionsDto'],
      isCustomerPropertyRequired: json['isCustomerPropertyRequired'],
      isQRPaymentAccepted: json['isQRPaymentAccepted'],
      isBillInquiryRequired: json['isBillInquiryRequired'],
      inqRquired: json['inqRquired'],
      mobileNotify: json['mobileNotify'],
      fracAccepted: json['fracAccepted'],
      prtAccepted: json['prtAccepted'],
      ovrAccepted: json['ovrAccepted'],
      advAccepted: json['advAccepted'],
      acptCartPayment: json['acptCartPayment'],
      billerIdLabel: json['billingAccountLabel'],
      maximumValueInServiceCur: json['maximumValueInServiceCur'],
      serviceInquiryRequired: json['serviceInquiryRequired'],
    );
  }
}

class AdditionalInputParameters {
  String? inputMethod;
  bool? isBaKeyPart;
  bool? isPrintKeyPart;
  String? label;
  String? merchantKey;
  String?
      merchantKey2; // in case we need key for dropdown selected item and its code
  bool? requireMultipleMerchantKey;
  bool? isRequired;
  String? answer;
  List<KeyValue>? dropdownItems;

  AdditionalInputParameters.fromJson(Map<String, dynamic> json)
      : inputMethod = json['inputMethod'],
        isBaKeyPart = json['isBaKeyPart'],
        isPrintKeyPart = json['isPrintKeyPart'],
        label = json['label'],
        merchantKey = json['merchantKey'],
        isRequired = json['isRequired'],
        answer = '';

  Map<String, dynamic> toJson() {
    return {
      'inputMethod': inputMethod,
      'isBaKeyPart': isBaKeyPart,
      'isPrintKeyPart': isPrintKeyPart,
      'label': label,
      'merchantKey': merchantKey,
      'isRequired': isRequired,
    };
  }
}
