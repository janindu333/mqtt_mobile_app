// ignore_for_file: file_names

import 'package:bloodDonate/blocks/BlocEventStateBase.dart';
import 'package:flutter/cupertino.dart';

class BloodRequestState extends BlocState {
  final bool isAuthenticated;
  final bool isAuthenticating;
  final bool hasFailed;

  final String token;
  final String credentials;
  final String loginID;
  final String userName;
  final String userID;
  final String email;
  final String userRole;
  final String buyerRating;
  final String sellerRating;

  BloodRequestState(
      {@required this.isAuthenticated,
      this.isAuthenticating: false,
      this.hasFailed: false,
      this.userName: '',
      this.token: '',
      this.credentials: '',
      this.loginID: '',
      this.userRole: '',
      this.userID: '',
      this.email: '',
      this.buyerRating: '',
      this.sellerRating: ''});

  factory BloodRequestState.notAuthenticated() {
    return BloodRequestState(
      isAuthenticated: false,
    );
  }

  factory BloodRequestState.authenticated(
      String token,
      String credentials,
      String loginID,
      String userName,
      String userID,
      String email,
      String userRole,
      String buyerRating,
      String sellerRating) {
    return BloodRequestState(
        isAuthenticated: true,
        userName: userName,
        token: token,
        credentials: credentials,
        loginID: loginID,
        userID: userID,
        email: email,
        userRole: userRole,
        buyerRating: buyerRating,
        sellerRating: sellerRating);
  }

  factory BloodRequestState.authenticating() {
    return BloodRequestState(
      isAuthenticated: false,
      isAuthenticating: true,
    );
  }

  factory BloodRequestState.failure() {
    return BloodRequestState(
      isAuthenticated: false,
      hasFailed: true,
    );
  }

  factory BloodRequestState.signing() {
    return BloodRequestState(
      isAuthenticated: false,
      isAuthenticating: true,
    );
  }

  factory BloodRequestState.endOfSigning() {
    return BloodRequestState(
      isAuthenticated: false,
      isAuthenticating: false,
    );
  }
}
