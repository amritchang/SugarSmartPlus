class UserModel {
  String? fullName;
  String? dob;
  String? mobileNumber;
  String? email;
  String? gender;

  UserModel({
    this.fullName,
    this.dob,
    this.mobileNumber,
    this.email,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      dob: json['dob'],
      email: json['email'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'dob': dob,
      'mobileNumber': mobileNumber,
      'email': email,
      'gender': gender,
    };
  }
}
