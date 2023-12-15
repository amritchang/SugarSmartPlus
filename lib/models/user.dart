class User {
  int? id;
  String? fullName;
  String? accountNumber;
  String? mobileNumber;
  String? countryCode;
  String? parent;
  int? parentId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? username;
  bool? verified;
  String? created;
  String? createdBy;
  double? balance;
  String? mPin;
  String? status;
  bool? profileVerification;
  bool? profileVerificationRequest;
  String? verificationStage;
  String? verificationStages;
  bool? onlineRegistered;
  double? rewardPoint;
  String? registeredChannel;
  String? type;
  String? promoCode;
  String? referCode;
  String? vCode;
  String? kycVerificationStatus;
  String? mpin;

  User({
    this.id,
    this.fullName,
    this.accountNumber,
    this.mobileNumber,
    this.countryCode,
    this.parent,
    this.parentId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.username,
    this.verified,
    this.created,
    this.createdBy,
    this.balance = 0.0,
    this.mPin,
    this.status,
    this.profileVerification,
    this.profileVerificationRequest,
    this.verificationStage,
    this.verificationStages,
    this.onlineRegistered,
    this.rewardPoint = 0.0,
    this.registeredChannel,
    this.type,
    this.promoCode,
    this.referCode,
    this.vCode,
    this.kycVerificationStatus,
    this.mpin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      accountNumber: json['accountNumber'],
      mobileNumber: json['mobileNumber'],
      countryCode: json['countryCode'],
      parent: json['parent'],
      parentId: json['parentId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
      verified: json['verified'],
      created: json['created'],
      createdBy: json['createdBy'],
      balance: json['balance']?.toDouble() ?? 0.0,
      mPin: json['mPin'],
      status: json['status'],
      profileVerification: json['profileVerification'],
      profileVerificationRequest: json['profileVerificationRequest'],
      verificationStage: json['verificationStage'],
      verificationStages: json['verificationStages'],
      onlineRegistered: json['onlineRegistered'],
      rewardPoint: json['rewardPoint']?.toDouble() ?? 0.0,
      registeredChannel: json['registeredChannel'],
      type: json['type'],
      promoCode: json['promoCode'],
      referCode: json['referCode'],
      vCode: json['vCode'],
      kycVerificationStatus: json['kycVerificationStatus'],
      mpin: json['mpin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'accountNumber': accountNumber,
      'mobileNumber': mobileNumber,
      'countryCode': countryCode,
      'parent': parent,
      'parentId': parentId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'verified': verified,
      'created': created,
      'createdBy': createdBy,
      'balance': balance,
      'mPin': mPin,
      'status': status,
      'profileVerification': profileVerification,
      'profileVerificationRequest': profileVerificationRequest,
      'verificationStage': verificationStage,
      'verificationStages': verificationStages,
      'onlineRegistered': onlineRegistered,
      'rewardPoint': rewardPoint,
      'registeredChannel': registeredChannel,
      'type': type,
      'promoCode': promoCode,
      'referCode': referCode,
      'vCode': vCode,
      'kycVerificationStatus': kycVerificationStatus,
      'mpin': mpin,
    };
  }
}
