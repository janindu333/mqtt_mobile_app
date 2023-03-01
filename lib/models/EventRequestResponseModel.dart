// TODO Implement this library.

import 'package:bloodDonate/models/BaseResponseModel.dart';
import 'package:bloodDonate/models/EventRequestModel.dart';

class EventRequestResponceModel extends BaseResponseModel {
  List<EventRequestModel> listOfEventRequests;

  EventRequestResponceModel(
      {this.listOfEventRequests,
      bool success,
      int error,
      int errorCode,
      String message})
      : super(
            success: success,
            error: error,
            errorCode: errorCode,
            message: message);

  factory EventRequestResponceModel.fromJson(Map<String, dynamic> json) {
    return EventRequestResponceModel(
        listOfEventRequests: parseData(json['listOfEventRequests']),
        success: json['success'],
        message: json['message'],
        error: json['errorMessage'],
        errorCode: json['errorCode']);
  }

  static List<EventRequestModel> parseData(json) {
    List<EventRequestModel> li = List<EventRequestModel>.from(
        json.map((data) => EventRequestModel.fromJson(data)));
    return li;
  }
}
