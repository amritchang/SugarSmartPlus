import 'package:sugar_smart_assist/storage/storage.dart';

class SignUpRequest {
  String fullname;
  String gender;
  String email;
  String mobileNumber;
  String dob;
  String password;
  String repassword;

  // Constructor with default values
  SignUpRequest({
    this.fullname = '',
    this.gender = '',
    this.email = '',
    this.mobileNumber = '',
    this.dob = '',
    this.password = '',
    this.repassword = '',
  });

// Create a method to convert the object to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'fullName': fullname,
      'gender': gender,
      'email': email,
      'mobileNumber': Storage().selectedCountryCode + mobileNumber,
      'dob': dob,
    };

    return jsonMap;
  }
}
