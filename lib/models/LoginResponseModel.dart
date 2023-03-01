// ignore_for_file: file_names

import 'package:bloodDonate/models/BaseResponseModel.dart';

class LoginResponseModel extends BaseResponseModel {
  final String token;
  final String credentials;
  final String loginID;
  final String userName;
  final String userID;
  final String email;
  final String userRole;
  final String buyerRating;
  final String sellerRating;
  final String noOfGreenhouses;

  LoginResponseModel(
      {this.token,
      this.credentials,
      this.loginID,
      this.userID,
      this.userName,
      this.email,
      this.userRole,
      this.buyerRating,
      this.sellerRating,
      this.noOfGreenhouses,
      bool success,
      int error,
      int errorCode,
      String message})
      : super(
            success: success,
            error: error,
            errorCode: errorCode,
            message: message);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json['token'],
        credentials: json['credentials'],
        loginID: json['loginID'],
        userName: json['userName'],
        userID: json['userID'],
        email: json['email'],
        userRole: json['userRole'],
        buyerRating: json['buyerRating'],
        sellerRating: json['sellerRating'],
        noOfGreenhouses: json['noOfGreenhouses'],
        success: json['success'],
        error: json['error'],
        errorCode: json['errorCode'],
        message: json['message']);
  }
}
