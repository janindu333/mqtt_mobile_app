import 'dart:async';
import 'dart:io';

import 'package:bloodDonate/data/base/api_response.dart';
import 'package:bloodDonate/data/base/error_response.dart';
import 'package:bloodDonate/data/repository/bloodrequest_repo.dart';
import 'package:bloodDonate/data/repository/response_model.dart';
import 'package:bloodDonate/models/BloodRequestModel.dart';
import 'package:bloodDonate/models/BloodRequestResponseModel.dart';
import 'package:bloodDonate/models/EventRequestModel.dart';
import 'package:bloodDonate/models/EventRequestResponseModel.dart';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloodRequestProvider with ChangeNotifier {
  final BloodRequestRepo bloodRequestRepo;
  BloodRequestProvider({@required this.bloodRequestRepo});

  bool _isLoading = false;
  bool _isLoadingGetEvents = false;

  bool _isMqttConnected = false;
  bool _mqttConnectivityBtnVisible = true;
  bool _mqttDisconnectivityBtnVisible = false;

  bool _mqttOnButton1 = true;
  bool _mqttOnButton2 = true;
  bool _mqttOnButton3 = true;
  bool _mqttOnButton4 = true;

  String _delayTime = "2";

  String _mqttMessage;
  String _mqttPublishTopic;
  String _pubMsg1;
  String _pubMsg2;
  String _pubMsg3;
  String _pubMsg4;

  String _mqttHost = "";
  String _mqttPort = "";
  String _mqttSUbscribeTopic = "";

  String _sowingDate;
  String _transplantingDate;
  String _floweringDate;
  String _fruitingDate;
  String _startHarvesting;
  String _endHarvesting;

  BloodRequestResponceModel _responseModel;
  EventRequestResponceModel _eventResponseModel;

  bool get isLoading => _isLoading;
  bool get isMqttConnected => _isMqttConnected;
  bool get mqttConnectivityBtnVisible => _mqttConnectivityBtnVisible;
  bool get mqttDisconnectivityBtnVisible => _mqttDisconnectivityBtnVisible;

  bool get mqttOnButton1 => _mqttOnButton1;
  bool get mqttOnButton2 => _mqttOnButton2;
  bool get mqttOnButton3 => _mqttOnButton3;
  bool get mqttOnButton4 => _mqttOnButton4;

  String get delayTime => _delayTime;

  bool get isLoadingGetEvents => _isLoadingGetEvents;
  String get sowingActualDate => _sowingDate;
  String get mqttMessage => _mqttMessage;
  String get mqttPublishTopic => _mqttPublishTopic;
  String get pubMsg1 => _pubMsg1;
  String get pubMsg2 => _pubMsg2;
  String get pubMsg3 => _pubMsg3;
  String get pubMsg4 => _pubMsg4;
  String get mqttHost => _mqttHost;
  String get mqttPort => _mqttPort;
  String get mqttSUbscribeTopic => _mqttSUbscribeTopic;
  BloodRequestResponceModel get responseModel => _responseModel;
  EventRequestResponceModel get eventResponseModel => _eventResponseModel;

  List<BloodRequestModel> _listOfBloodRequests;
  List<BloodRequestModel> get listOfBloodRequests => _listOfBloodRequests;

  List<EventRequestModel> _listOfEventRequests;
  List<EventRequestModel> get listOfEventRequests => _listOfEventRequests;

  String _bloodRequestErrorMessage;

  var client;

  String get bloodRequestErrorMessage => _bloodRequestErrorMessage;

  SharedPreferences prefs;

  Future<ResponseModel> connectToBroker({String ip, String port}) async {
    ResponseModel responseModel;
    client = MqttServerClient(ip.trim(), port.trim());
    _mqttHost = ip;
    _mqttPort = port;

    print("TTTTTTTT , $_mqttHost");

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setString('_mqttHost', _mqttHost);
    prefs.setString('_mqttPort', _mqttPort);

    notifyListeners();

    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;

    try {
      await client.connect();
      print('Client connected: ${client.connectionStatus}');
      _isMqttConnected = true;
      _mqttConnectivityBtnVisible = false;
      _mqttDisconnectivityBtnVisible = true;
      prefs.setBool('_isMqttConnected', _isMqttConnected);
      prefs.setBool('_mqttConnectivityBtnVisible', _mqttConnectivityBtnVisible);
      prefs.setBool(
          '_mqttDisconnectivityBtnVisible', _mqttDisconnectivityBtnVisible);
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      _isMqttConnected = false;
      _mqttConnectivityBtnVisible = true;
      _mqttDisconnectivityBtnVisible = false;
      prefs.setBool('_isMqttConnected', _isMqttConnected);
      prefs.setBool('_mqttConnectivityBtnVisible', _mqttConnectivityBtnVisible);
      prefs.setBool(
          '_mqttDisconnectivityBtnVisible', _mqttDisconnectivityBtnVisible);
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      print('Failed to connect: $e');
      _isMqttConnected = false;
      _mqttConnectivityBtnVisible = true;
      _mqttDisconnectivityBtnVisible = false;
      prefs.setBool('_isMqttConnected', _isMqttConnected);
      prefs.setBool('_mqttConnectivityBtnVisible', _mqttConnectivityBtnVisible);
      prefs.setBool(
          '_mqttDisconnectivityBtnVisible', _mqttDisconnectivityBtnVisible);
      client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      responseModel = ResponseModel('Succesfully Connected', true);
    } else {
      responseModel = ResponseModel('Failed to Connect', false);
    }

    // _responseModel = response;
    _isLoading = false;

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> disConnectFromBroker({String ip, String port}) async {
    ResponseModel responseModel;
    client.disconnect();

    // Store a value
    prefs = await SharedPreferences.getInstance();

    responseModel = ResponseModel('Succesfully Disconnected', true);
    _isMqttConnected = false;
    _mqttConnectivityBtnVisible = true;
    _mqttDisconnectivityBtnVisible = false;

    prefs.setBool('_isMqttConnected', _isMqttConnected);
    prefs.setBool('_mqttConnectivityBtnVisible', _mqttConnectivityBtnVisible);
    prefs.setBool(
        '_mqttDisconnectivityBtnVisible', _mqttDisconnectivityBtnVisible);

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> subscribeToTopic({String topic}) async {
    ResponseModel responseModel;
    client.subscribe(topic, MqttQos.exactlyOnce);
    client.updates.listen(handleMessage);
    _mqttSUbscribeTopic = topic;

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setString('_mqttSUbscribeTopic', _mqttSUbscribeTopic);

    responseModel = ResponseModel('Succesfully Subscribed to ' + topic, true);
    _isMqttConnected = true;
    prefs.setBool('_isMqttConnected', _isMqttConnected);
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> storePublishData(
      {String topic,
      String msg1,
      String msg2,
      String msg3,
      String msg4}) async {
    ResponseModel responseModel;

    _mqttPublishTopic = topic;
    _pubMsg1 = msg1;
    _pubMsg2 = msg2;
    _pubMsg3 = msg3;
    _pubMsg4 = msg4;

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setString('_mqttPublishTopic', _mqttPublishTopic);
    prefs.setString('_pubMsg1', _pubMsg1);
    prefs.setString('_pubMsg2', _pubMsg2);
    prefs.setString('_pubMsg3', _pubMsg3);
    prefs.setString('_pubMsg4', _pubMsg4);

    responseModel =
        ResponseModel('Succesfully Store Published Data ' + topic, true);
    _isMqttConnected = true;
    prefs.setBool('_isMqttConnected', _isMqttConnected);
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> publishMsg1({String topic, String msg}) async {
    ResponseModel responseModel;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);

    responseModel =
        ResponseModel('Published Message ' + msg + " to " + topic, true);
    _isMqttConnected = true;

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('_isMqttConnected', _isMqttConnected);

    _mqttOnButton1 = true;
    _mqttOnButton2 = false;
    _mqttOnButton3 = false;
    _mqttOnButton4 = false;

    print("_delayTime : $_delayTime");

    // Disable the button for seconds
    Timer(Duration(seconds: int.parse(_delayTime)), () {
      _mqttOnButton1 = true;
      _mqttOnButton2 = true;
      _mqttOnButton3 = true;
      _mqttOnButton4 = true;
      notifyListeners();
    });

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> publishMsg2({String topic, String msg}) async {
    print("DDDDDDDDDDDDDDDDDDDDDDDD , $topic , $msg");
    ResponseModel responseModel;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);

    responseModel =
        ResponseModel('Published Message ' + msg + " to " + topic, true);
    _isMqttConnected = true;

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('_isMqttConnected', _isMqttConnected);

    _mqttOnButton1 = false;
    _mqttOnButton2 = true;
    _mqttOnButton3 = false;
    _mqttOnButton4 = false;

    // Disable the button for seconds
    Timer(Duration(seconds: int.parse(_delayTime)), () {
      _mqttOnButton1 = true;
      _mqttOnButton2 = true;
      _mqttOnButton3 = true;
      _mqttOnButton4 = true;
      notifyListeners();
    });

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> publishMsg3({String topic, String msg}) async {
    ResponseModel responseModel;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);

    responseModel =
        ResponseModel('Published Message ' + msg + " to " + topic, true);
    _isMqttConnected = true;

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('_isMqttConnected', _isMqttConnected);

    _mqttOnButton1 = false;
    _mqttOnButton2 = false;
    _mqttOnButton3 = true;
    _mqttOnButton4 = false;

    // Disable the button for seconds
    Timer(Duration(seconds: int.parse(_delayTime)), () {
      _mqttOnButton1 = true;
      _mqttOnButton2 = true;
      _mqttOnButton3 = true;
      _mqttOnButton4 = true;
      notifyListeners();
    });

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> publishMsg4({String topic, String msg}) async {
    ResponseModel responseModel;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);

    responseModel =
        ResponseModel('Published Message ' + msg + " to " + topic, true);
    _isMqttConnected = true;

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('_isMqttConnected', _isMqttConnected);

    _mqttOnButton1 = false;
    _mqttOnButton2 = false;
    _mqttOnButton3 = false;
    _mqttOnButton4 = true;

    // Disable the button for seconds
    Timer(Duration(seconds: int.parse(_delayTime)), () {
      _mqttOnButton1 = true;
      _mqttOnButton2 = true;
      _mqttOnButton3 = true;
      _mqttOnButton4 = true;
      notifyListeners();
    });

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> saveDelayTime({String time}) async {
    ResponseModel responseModel;

    responseModel = ResponseModel('Saved delay time ', true);

    _delayTime = time;

    prefs = await SharedPreferences.getInstance();
    prefs.setString('_delayTime', _delayTime);

    notifyListeners();
    return responseModel;
  }

  void handleMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    final MqttPublishMessage receivedMessage =
        messages[0].payload as MqttPublishMessage;

    if (receivedMessage != null) {
      final String message = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      _mqttMessage = message;
      notifyListeners();
      print("Received message: $message");
    }
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe to $topic');
  }

  Future<BloodRequestProvider> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    BloodRequestProvider myData = BloodRequestProvider();

    _mqttHost = prefs.getString('_mqttHost') ?? "";
    _mqttPort = prefs.getString('_mqttPort') ?? "";

    _mqttSUbscribeTopic = prefs.getString('_mqttSUbscribeTopic') ?? "";
    _mqttPublishTopic = prefs.getString('_mqttPublishTopic') ?? "";

    _pubMsg1 = prefs.getString('_pubMsg1') ?? "";
    _pubMsg2 = prefs.getString('_pubMsg2') ?? "";
    _pubMsg3 = prefs.getString('_pubMsg3') ?? "";
    _pubMsg4 = prefs.getString('_pubMsg4') ?? "";
    _delayTime = prefs.getString('_delayTime') ?? "";

    print("intial shared preferences values , $_mqttHost");

    return myData;
  }

  handleError(ApiResponse apiResponse) {
    String errorMessage;
    if (apiResponse.error is String) {
      print(apiResponse.error.toString());
      errorMessage = apiResponse.error.toString();
    } else {
      ErrorResponse errorResponse = apiResponse.error;
      print(errorResponse.errors[0].message);
      errorMessage = errorResponse.errors[0].message;
    }
    _bloodRequestErrorMessage = errorMessage;
  }
}
