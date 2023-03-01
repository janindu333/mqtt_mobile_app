// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bloodDonate/events/authentication/AuthenticationEvent.dart';
import 'package:bloodDonate/states/AuthenticationState.dart';
import 'package:bloodDonate/models/BaseResponseModel.dart';
import '../resources/Repository.dart';
import '../resources/authenticate.dart';
import '../models/LoginResponseModel.dart';
import 'BlocEventStateBase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends BlocEventStateBase<AuthenticationEvent, AuthenticationState> {
  final repository = Repository();

  AuthenticationBloc()
      : super(
          initialState: AuthenticationState.notAuthenticated(),
        );

  @override
  Stream<AuthenticationState> eventHandler(
      AuthenticationEvent event, AuthenticationState currentState) async* {
    if (event is AuthenticationEventLogin) {
      yield AuthenticationState.authenticating();
      // LoginResponseModel responseModel = await repository.login(event.username,
      //     event.password, event.token);
      String responseModel = await FireStoreUtils.loginWithEmailAndPassword(
          event.username.trim(), event.password.trim());
      if (responseModel != null) {
        if (responseModel.compareTo("Success") == 0) {
          yield AuthenticationState.authenticated(
              event.username.trim(),
              event.username.trim(),
              event.username.trim(),
              event.username,
              event.username.trim(),
              event.username.trim(),
              event.username.trim(),
              event.username.trim(),
              event.username.trim());
          showtoast(responseModel);
        } else {
          showtoast(responseModel);
          yield AuthenticationState.failure();
        }
      }
    }

    if (event is AuthenticationEventSignUp) {
      yield AuthenticationState.signing();
      String responseModel = await FireStoreUtils.signUpWithEmailAndPassword(
          event.username, event.password, event.bloodType);
      if (responseModel != null) {
        if (responseModel == "sucess") {
          // yield AuthenticationState.failure();
          showtoast("sucess");
          yield AuthenticationState.endOfSigning();
        } else {
          showtoast("fail");
          yield AuthenticationState.endOfSigning();
        }
      }
    }

    if (event is AuthenticationEventLogout) {
      BaseResponseModel responseModel = await repository.logout();
      if (responseModel.success) {
        await clearSavedData();
        yield AuthenticationState.notAuthenticated();
      }
    }
  }

  Future<void> clearSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void showtoast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
