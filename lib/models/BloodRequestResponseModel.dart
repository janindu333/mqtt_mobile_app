// TODO Implement this library.

import 'package:bloodDonate/models/BaseResponseModel.dart';
import 'package:bloodDonate/models/BloodRequestModel.dart';

class BloodRequestResponceModel extends BaseResponseModel {
  List<BloodRequestModel> listOfBloodRequests;

  BloodRequestResponceModel(
      {this.listOfBloodRequests,
      bool success,
      int error,
      int errorCode,
      String message})
      : super(
            success: success,
            error: error,
            errorCode: errorCode,
            message: message);

  factory BloodRequestResponceModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestResponceModel(
        listOfBloodRequests: parseData(json['listOfBloodRequests']),
        success: json['success'],
        message: json['message'],
        error: json['errorMessage'],
        errorCode: json['errorCode']);
  }

  static List<BloodRequestModel> parseData(json) {
    List<BloodRequestModel> li = List<BloodRequestModel>.from(
        json.map((data) => BloodRequestModel.fromJson(data)));
    return li;
  }
}
