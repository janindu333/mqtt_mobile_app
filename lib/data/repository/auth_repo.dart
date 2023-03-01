import 'dart:io';

import 'package:bloodDonate/data/base/api_response.dart';
import 'package:bloodDonate/ui/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio/dio_client.dart';
import 'exception/api_error_handler.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> login(
      {String emailAddress, String password, String token}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOGIN_URI,
        data: {
          'UserName': emailAddress, //'wsanadmin'
          'Password': password, // 'aigrow@213'
          'token': token, // 'A866E5B4F09022AE9C885D520A5DCD1AC66A73AA'
          'loginMode': 'APP'
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> logout(
      {String emailAddress, String password, String token}) async {
    var loginId = getLoginId();
    var token = getUserToken();
    try {
      Response response = await dioClient.post(AppConstants.LOGOUT_URI,
          data: {'loginID': loginId, 'token': token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  // Future<ApiResponse> updateToken() async {
  //   try {
  //     String _deviceToken;
  //     if (!Platform.isAndroid) {
  //       NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
  //         alert: true,
  //         announcement: false,
  //         badge: true,
  //         carPlay: false,
  //         criticalAlert: false,
  //         provisional: false,
  //         sound: true,
  //       );
  //       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //         _deviceToken = await _saveDeviceToken();
  //       }
  //     } else {
  //       _deviceToken = await _saveDeviceToken();
  //     }
  //     Response response = await dioClient.post(
  //       AppConstants.TOKEN_URI,
  //       data: {"_method": "put", "fcm_token": _deviceToken, "token": sharedPreferences.get(AppConstants.TOKEN)},
  //     );
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  // Future<String> _saveDeviceToken() async {
  //   String _deviceToken = await FirebaseMessaging.instance.getToken();
  //   if (_deviceToken != null) {
  //     print('--------Device Token---------- ' + _deviceToken);
  //   }
  //   return _deviceToken;
  // }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  String getLoginId() {
    return sharedPreferences.getString(AppConstants.LOGIN_ID) ?? "";
  }

  String getUserId() {
    return sharedPreferences.getString(AppConstants.USER_ID) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    return sharedPreferences.remove(AppConstants.USER_EMAIL);
    //return sharedPreferences.clear();
  }

  // for  Remember Email
  Future<void> saveUserEmailAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_EMAIL, number);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveUserData(String token, String userID, String loginId) async {
    await sharedPreferences.setString(AppConstants.TOKEN, token);
    await sharedPreferences.setString(AppConstants.USER_ID, userID);
    await sharedPreferences.setString(AppConstants.LOGIN_ID, loginId);
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.USER_EMAIL) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_EMAIL);
  }
}
