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
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloodRequestProvider with ChangeNotifier {
  final BloodRequestRepo bloodRequestRepo;
  BloodRequestProvider({@required this.bloodRequestRepo});

  bool _isLoading = false;
  bool _isLoadingGetEvents = false;

  bool _isMqttConnected = false;
  bool _mqttConnectivityBtnVisible = true;
  bool _mqttDisconnectivityBtnVisible = false;
  bool _isActivated = false;

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

  String _cmd;
  String _unit;
  String _pwr;
  String _alm;
  String _i;
  String _b;
  String _s;

  String _activationCode;

  String _topMsg1;
  String _topMsg2;
  String _topMsg3;
  String _topMsg4;

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

  bool get isActivated => _isActivated;

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
  String get activationCode => _activationCode;

  String get cmd => _cmd;
  String get unit => _unit;
  String get pwr => _pwr;
  String get alm => _alm;
  String get i => _i;
  String get b => _b;
  String get s => _s;

  String get topMsg1 => _topMsg1;
  String get topMsg2 => _topMsg2;
  String get topMsg3 => _topMsg3;
  String get topMsg4 => _topMsg4;

  String get mqttHost => _mqttHost;
  String get mqttPort => _mqttPort;
  String get mqttSUbscribeTopic => _mqttSUbscribeTopic;
  BloodRequestResponceModel get responseModel => _responseModel;
  EventRequestResponceModel get eventResponseModel => _eventResponseModel;

  List<BloodRequestModel> _listOfBloodRequests;
  List<BloodRequestModel> get listOfBloodRequests => _listOfBloodRequests;

  List<List<String>> _listOfPairRequests;
  List<List<String>> get listOfPairRequests => _listOfPairRequests;

  List<EventRequestModel> _listOfEventRequests;
  List<EventRequestModel> get listOfEventRequests => _listOfEventRequests;

  String _bloodRequestErrorMessage;

  var client;

  String get bloodRequestErrorMessage => _bloodRequestErrorMessage;

  SharedPreferences prefs;

  String getUniqueDeviceId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  Future<ResponseModel> connectToBroker({String ip, String port}) async {
    ResponseModel responseModel;

    _mqttHost = ip;
    _mqttPort = port;

    print("NNNNNNNNNNNNNNNNNNNN , $ip - > $port");
    print("ZZZZZZZZZZZZZZZZZZZZ , $_mqttHost - > $_mqttPort");

    client = MqttServerClient(ip.trim(), port.trim());

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setString('_mqttHost', _mqttHost);
    prefs.setString('_mqttPort', _mqttPort);

    notifyListeners();

    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.onDisconnected = onDisconnected;
    client.logging(on: true);

    final connMess = MqttConnectMessage()
        .withClientIdentifier(getUniqueDeviceId())
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

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
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates.listen(handleMessage);
    _mqttSUbscribeTopic = topic;
    print("BBBBBBBBBBBBB , $topic");
    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setString('_mqttSUbscribeTopic', _mqttSUbscribeTopic);

    responseModel = ResponseModel('Succesfully Subscribed to ' + topic, true);
    _isMqttConnected = true;
    prefs.setBool('_isMqttConnected', _isMqttConnected);
    _listOfPairRequests = [];
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> storePublishData(
      {String topic,
      String msg1,
      String msg2,
      String msg3,
      String msg4,
      String top1,
      String top2,
      String top3,
      String top4,
      String subTop,
      String host,
      String port}) async {
    ResponseModel responseModel;

    _mqttPublishTopic = topic;
    _pubMsg1 = msg1;
    _pubMsg2 = msg2;
    _pubMsg3 = msg3;
    _pubMsg4 = msg4;

    _topMsg1 = top1;
    _topMsg2 = top2;
    _topMsg3 = top3;
    _topMsg4 = top4;

    _mqttHost = host;
    _mqttPort = port;
    _mqttSUbscribeTopic = subTop;

    if (_isMqttConnected) {
      disConnectFromBroker();
    }

    _isMqttConnected = false;

    // Store a value
    prefs = await SharedPreferences.getInstance();
    prefs.setString('_mqttPublishTopic', _mqttPublishTopic);
    prefs.setString('_pubMsg1', _pubMsg1);
    prefs.setString('_pubMsg2', _pubMsg2);
    prefs.setString('_pubMsg3', _pubMsg3);
    prefs.setString('_pubMsg4', _pubMsg4);

    prefs.setString('_topMsg1', _topMsg1);
    prefs.setString('_topMsg2', _topMsg2);
    prefs.setString('_topMsg3', _topMsg3);
    prefs.setString('_topMsg4', _topMsg4);

    prefs.setString('_mqttHost', _mqttHost);
    prefs.setString('_mqttPort', _mqttPort);
    prefs.setBool('_isMqttConnected', _isMqttConnected);
    prefs.setString('_mqttSUbscribeTopic', _mqttSUbscribeTopic);

    print("_mqttHost -> $_mqttHost , _mqttPort -> $_mqttPort");

    responseModel = ResponseModel('Succesfully Store Published Data ', true);

    prefs.setBool('_isMqttConnected', _isMqttConnected);
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> publishMsg1({String topic, String msg}) async {
    ResponseModel responseModel;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);

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

    print("_delayTime 1 : $_delayTime");

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
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);

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

    print("_delayTime 2 : $_delayTime");

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
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);

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

    print("_delayTime 3 : $_delayTime");

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
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);

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

    print("_delayTime 4 : $_delayTime");

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
    for (final message in messages) {
      final MqttPublishMessage receivedMessage =
          message.payload as MqttPublishMessage;

      if (receivedMessage != null) {
        final String messagePayload = MqttPublishPayload.bytesToStringAsString(
            receivedMessage.payload.message);
        _mqttMessage = messagePayload;
        notifyListeners();

        _listOfPairRequests = [];

        RegExp regex = RegExp('cmd');

        List<String> lines = messagePayload.split('\n');

        for (String line in lines) {
          List<String> pairValue = line.split(':');
          print("8888888888888 , $line -> $pairValue");
          if (pairValue.length == 2) {
            String key = pairValue[0];

            _listOfPairRequests.add(pairValue);
            print("5555555555555555555 , $pairValue");
            switch (key) {
              case 'cmd':
                _cmd = pairValue[1];
                break;
              case 'unit':
                _unit = pairValue[1];
                break;
              case 'pwr':
                _pwr = pairValue[1];
                break;
              case 'Alm':
                _alm = pairValue[1];
                break;
              case 'I':
                _i = pairValue[1];
                break;
              case 'B':
                _b = pairValue[1];
                break;
              case 'S':
                _s = pairValue[1];
                break;
            }
          }
        }

        //  print("Received message: $messagePayload");
      }
    }
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe to $topic');
  }

  void onDisconnected() {
    print('Disconnected from the broker.');
  }

  Future<BloodRequestProvider> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    BloodRequestProvider myData = BloodRequestProvider();

    // _mqttHost = prefs.getString('_mqttHost') ?? "";
    // _mqttPort = prefs.getString('_mqttPort') ?? "";

    _mqttHost = prefs.getString('_mqttHost') ?? "thingsworld.cloud";
    _mqttPort = prefs.getString('_mqttPort') ?? "1883";

    _mqttSUbscribeTopic =
        prefs.getString('_mqttSUbscribeTopic') ?? "8866188126P";
    _mqttPublishTopic = prefs.getString('_mqttPublishTopic') ?? "8866188126S";

    _pubMsg1 = prefs.getString('_pubMsg1') ?? "*ON1#";
    _pubMsg2 = prefs.getString('_pubMsg2') ?? "*OFF1#";
    _pubMsg3 = prefs.getString('_pubMsg3') ?? "*GET1#";
    _pubMsg4 = prefs.getString('_pubMsg4') ?? "*GSC1#";

    _topMsg1 = prefs.getString('_topMsg1') ?? "ON";
    _topMsg2 = prefs.getString('_topMsg2') ?? "OFF";
    _topMsg3 = prefs.getString('_topMsg3') ?? "GET";
    _topMsg4 = prefs.getString('_topMsg4') ?? "GSC";

    _delayTime = prefs.getString('_delayTime') ?? "15";

    _activationCode = prefs.getString('_activationCode') ?? "8866188126";

    print("intial shared preferences values , $_mqttHost / $_pubMsg1");

    return myData;
  }

  Future<ResponseModel> activateCode({String code}) async {
    ResponseModel responseModel;

    _activationCode = code.trim();
    _mqttPublishTopic = _activationCode + "S";
    _mqttSUbscribeTopic = _activationCode + "P";
    _isActivated = true;

    prefs = await SharedPreferences.getInstance();
    prefs.setString('_activationCode', _activationCode);
    prefs.setString('_mqttPublishTopic', _mqttPublishTopic);
    prefs.setString('_mqttSUbscribeTopic', _mqttSUbscribeTopic);
    prefs.setBool('_isActivated', _isActivated);

    notifyListeners();
    responseModel = ResponseModel('Code activation success ', true);
    return responseModel;
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
