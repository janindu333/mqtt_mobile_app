// ignore_for_file: non_constant_identifier_names, unused_import, unnecessary_null_in_if_null_operators
// ignore_for_file: file_names

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloodDonate/models/BaseResponseModel.dart';
import 'package:bloodDonate/models/LoginResponseModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/BloodRequestResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class APIProvider {
  var baseURl = "test.quick.unilevertech.com:11000";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? null;
  }

  Future<SharedPreferences> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  String getAccessToken(SharedPreferences preferences) {
    return preferences.getString('accessToken') ?? null;
  }

  String getUserId(SharedPreferences preferences) {
    return preferences.getString('userId') ?? null;
  }

  String getLoginId(SharedPreferences preferences) {
    return preferences.getString('loginId') ?? null;
  }

  Future<LoginResponseModel> loginApi(
      String username, String password, String token) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://portal.aigrow.lk:8090/LoginController.asmx/CheckLoginPOSTJSON'));
    request.bodyFields = {
      'UserName': username, //'wsanadmin'
      'Password': password, // 'aigrow@213'
      'token': token, // 'A866E5B4F09022AE9C885D520A5DCD1AC66A73AA'
      'loginMode': 'APP'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);
      return LoginResponseModel.fromJson(jsonData);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<BaseResponseModel> logoutApi() async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST',
        Uri.parse('https://portal.aigrow.lk:8090/LoginController.asmx/LogOut'));
    var preferences = await getSharedPreferences();
    var loginId = getUserId(preferences);
    var token = getAccessToken(preferences);
    request.bodyFields = {'loginID': loginId, 'token': token};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);
      return LoginResponseModel.fromJson(jsonData);
    } else {
      print(response.reasonPhrase);
      return LoginResponseModel(success: false, message: response.reasonPhrase);
    }
  }

  fetchGreenhouseData() {}
}
