import 'dart:io';

import 'package:bloodDonate/data/base/api_response.dart';
import 'package:bloodDonate/ui/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio/dio_client.dart';
import 'exception/api_error_handler.dart';

class BloodRequestRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  BloodRequestRepo(
      {@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> fetchDevicesByGreenhouseId(
      {String greenhouseId, String token}) async {
    try {
      final response = await dioClient.get(
          'https://portal.aigrow.lk:12000/DeviceTypeController.asmx/GetAllDeviceOfGreenhouse?greenhouseId=' +
              greenhouseId +
              '&token=' +
              token);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }
}
