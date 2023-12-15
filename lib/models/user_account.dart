class UserAccount {
  int? accountId;
  String? accountNo;
  double? balance;
  String? accountType;
  String? accountSubType;
  int? associatedId;
  double? credit;
  double? previousSystemCredit;
  String? balanceStr;
  String? creditExpireDate;
  String? currency;

  UserAccount({
    this.accountId,
    this.accountNo,
    this.balance = 0.0,
    this.accountType,
    this.accountSubType,
    this.associatedId = 0,
    this.credit = 0.0,
    this.previousSystemCredit,
    this.balanceStr,
    this.creditExpireDate,
    this.currency = "USD",
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      accountId: json['accountId'],
      accountNo: json['accountNo'],
      balance: json['balance']?.toDouble(),
      accountType: json['accountType'],
      accountSubType: json['accountSubType'],
      associatedId: json['associatedId'],
      credit: json['credit']?.toDouble(),
      previousSystemCredit: json['previousSystemCredit']?.toDouble(),
      balanceStr: json['balanceStr'],
      creditExpireDate: json['creditExpireDate'],
      currency: json['currency'] ?? "USD",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'accountNo': accountNo,
      'balance': balance,
      'accountType': accountType,
      'accountSubType': accountSubType,
      'associatedId': associatedId,
      'credit': credit,
      'previousSystemCredit': previousSystemCredit,
      'balanceStr': balanceStr,
      'creditExpireDate': creditExpireDate,
      'currency': currency,
    };
  }
}
