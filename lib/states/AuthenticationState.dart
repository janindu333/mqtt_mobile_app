// ignore_for_file: file_names

import 'package:bloodDonate/blocks/BlocEventStateBase.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationState extends BlocState {
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

  AuthenticationState(
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

  factory AuthenticationState.notAuthenticated() {
    return AuthenticationState(
      isAuthenticated: false,
    );
  }

  factory AuthenticationState.authenticated(
      String token,
      String credentials,
      String loginID,
      String userName,
      String userID,
      String email,
      String userRole,
      String buyerRating,
      String sellerRating) {
    return AuthenticationState(
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

  factory AuthenticationState.authenticating() {
    return AuthenticationState(
      isAuthenticated: false,
      isAuthenticating: true,
    );
  }

  factory AuthenticationState.failure() {
    return AuthenticationState(
      isAuthenticated: false,
      hasFailed: true,
    );
  }

  factory AuthenticationState.signing() {
    return AuthenticationState(
      isAuthenticated: false,
      isAuthenticating: true,
    );
  }

  factory AuthenticationState.endOfSigning() {
    return AuthenticationState(
      isAuthenticated: false,
      isAuthenticating: false,
    );
  }
}
