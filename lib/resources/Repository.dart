// ignore_for_file: file_names

import 'dart:async';
import 'package:bloodDonate/events/authentication/AuthenticationEvent.dart';
import 'package:bloodDonate/models/BaseResponseModel.dart';
import 'package:bloodDonate/models/LoginResponseModel.dart';
import 'APIProvider.dart';
import '../models/BloodRequestResponseModel.dart';

enum AuthenticationStatus { Unknown, Authenticated, Unauthenticated }

class Repository {
  final dataAPIProvider = APIProvider();

  Future<LoginResponseModel> login(
          String username, String password, String token) =>
      dataAPIProvider.loginApi(username, password, token);

  Future<BaseResponseModel> logout() => dataAPIProvider.logoutApi();
}
