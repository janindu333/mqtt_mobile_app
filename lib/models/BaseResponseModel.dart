// ignore_for_file: file_names

class BaseResponseModel {
  bool success;
  String message;
  int errorCode;
  int error;

  BaseResponseModel({this.success, this.message, this.errorCode, this.error});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
        success: json['success'],
        message: json['message'],
        errorCode: json['errorCode'],
        error: json['error']);
  }
}
