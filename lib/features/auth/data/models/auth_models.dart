import 'user_model.dart';

class LoginRequestModel {
  final String email;
  final String password;
  final String firebaseId;

  const LoginRequestModel({
    required this.email,
    required this.password,
    required this.firebaseId,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'firebaseId': firebaseId};
  }
}

class LoginResponseModel {
  final bool success;
  final String? message;
  final String? token;
  final UserModel? user;
  final bool isOtpVerified;
  final bool profileCompleted;

  const LoginResponseModel({
    required this.success,
    this.message,
    this.token,
    this.user,
    required this.isOtpVerified,
    required this.profileCompleted,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['status'] ?? false,
      message: json['message'],
      token: json['token'],
      user: json['userDetails'] != null
          ? UserModel.fromJson(json['userDetails'])
          : null,
      isOtpVerified: json['isOtpVerified'] ?? false,
      profileCompleted: json['profileCompleted'] ?? false,
    );
  }
}

class RegisterRequestModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String dialCode;
  final String gender;
  final String dateOfBirth;
  final String profession;
  final String country;
  final String state;
  final String stateCode;
  final String? district;
  final String verificationMethod;
  final String? profileImage;
  final String? referralCode;
  final String firebaseId;

  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.dialCode,
    required this.gender,
    required this.dateOfBirth,
    required this.profession,
    required this.country,
    required this.state,
    this.district,
    required this.verificationMethod,
    this.profileImage,
    this.referralCode,
    required this.firebaseId,
    required this.stateCode,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'dialCode': dialCode,
      'gender': gender,
      'dob': dateOfBirth,
      'occupation': profession,
      'country': country,
      'state': state,
      'stateCode': stateCode,
      'method': verificationMethod,
      'tier': 'Moon',
      'isHandicaped': false,
      'firebaseId': firebaseId,
    };

    if (district != null) data['district'] = district!;
    if (profileImage != null) data['profileImage'] = profileImage!;
    if (referralCode != null) data['referelCode'] = referralCode!;

    return data;
  }
}

class OtpRequestModel {
  final String otp;
  final String email;
  final String? phone;
  final String? dialCode;
  final String method;
  final String firebaseId;

  const OtpRequestModel({
    required this.otp,
    required this.email,
    this.phone,
    this.dialCode,
    required this.method,
    required this.firebaseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'email': email,
      'phone': phone,
      'dialCode': dialCode,
      'method': method,
      'firebaseId': firebaseId,
    };
  }
}
