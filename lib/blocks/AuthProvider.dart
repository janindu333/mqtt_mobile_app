import 'dart:convert';

import 'package:bloodDonate/data/base/api_response.dart';
import 'package:bloodDonate/data/base/error_response.dart';
import 'package:bloodDonate/data/repository/auth_repo.dart';
import 'package:bloodDonate/data/repository/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({@required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // for login section
  String _loginErrorMessage = '';

  String get loginErrorMessage => _loginErrorMessage;

  Future<ResponseModel> login(
      {String emailAddress, String password, String token}) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.login(
        emailAddress: emailAddress, password: password, token: token);
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(apiResponse.response.data);
      String token = json["token"];
      String userID = json["userID"];
      String loginID = json["loginID"];
      authRepo.saveUserToken(token);
      authRepo.saveUserData(token, userID, loginID);
      responseModel = ResponseModel('', true);
      // await authRepo.updateToken();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(errorMessage, false);
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> loginWithEmailAndPassword(
      {String email, String password}) async {
    ResponseModel responseModel;
    try {
      _isLoading = true;
      _loginErrorMessage = '';
      notifyListeners();
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();

      responseModel = ResponseModel('', true);
      return responseModel;
    } on auth.FirebaseAuthException catch (exception, s) {
      _isLoading = false;
      notifyListeners();
      switch ((exception).code) {
        case 'invalid-email':
          responseModel = ResponseModel('Email address is malformed', false);
          return responseModel;
        case 'wrong-password':
          responseModel = ResponseModel('Wrong password', false);
          return responseModel;
        case 'user-not-found':
          responseModel = ResponseModel(
              'No user corresponding to the given email address', false);
          return responseModel;
        case 'user-disabled':
          responseModel = ResponseModel('This user has been disabled', false);
          return responseModel;
        case 'too-many-requests':
          responseModel =
              ResponseModel('Too many attempts to sign in as this user', false);
          return responseModel;
      }
    } catch (e, s) {
      _isLoading = false;
      notifyListeners();
      responseModel = ResponseModel(e.toString(), false);
      return responseModel;
      // return 'Login failed, Please try again.';
    }
  }

  Future<ResponseModel> signUpWithEmailAndPassword(
      {String bloodType, String email, String password}) async {
    ResponseModel responseModel;
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      debugPrint("SDDDD");
      final users = FirebaseFirestore.instance.collection('users');
      await users.doc(userCredential.user.uid).set({
        'bloodType': bloodType,
        'isAdmin': false,
      }, SetOptions(merge: true));
      responseModel = ResponseModel('', true);
      return responseModel;
    } on auth.FirebaseAuthException catch (exception, s) {
      debugPrint(exception.toString() + '$s');
      if (exception.code == 'weak-password') {
        responseModel =
            ResponseModel("The password provided is too weak.", false);
        return responseModel;
      } else if (exception.code == 'email-already-in-use') {
        responseModel =
            ResponseModel("The account already exists for that email.", false);
        return responseModel;
      }
    } catch (e, s) {
      debugPrint(e.toString() + '$s');
      responseModel = ResponseModel(e.toString(), false);
      return responseModel;
      // return 'Login failed, Please try again.';
    }
  }

  Future<ResponseModel> logout() async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    authRepo.clearSharedData();
    ApiResponse apiResponse = await authRepo.logout();
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(apiResponse.response.data);
      authRepo.clearSharedData();
      responseModel = ResponseModel(json["message"], true);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(errorMessage, false);
    }
    notifyListeners();
    return responseModel;
  }

  // for verification Code
  String _verificationCode = '';

  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  // for Remember Me Section

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  void saveUserEmailAndPassword(String email, String password) {
    authRepo.saveUserEmailAndPassword(email, password);
  }

  void saveUseridAndToken(String userId, String token, String loginId) {
    authRepo.saveUserData(token, userId, loginId);
  }

  String getUserEmail() {
    return authRepo.getUserEmail() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }
}
