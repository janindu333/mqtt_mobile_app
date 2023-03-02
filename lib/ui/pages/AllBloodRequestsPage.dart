// ignore_for_file: file_names, prefer_const_constructors

import 'dart:math';

import 'package:bloodDonate/blocks/AuthProvider.dart';
import 'package:bloodDonate/blocks/blood_request_block_provider.dart';
import 'package:bloodDonate/common/colors.dart';
import 'package:bloodDonate/models/BloodRequestModel.dart';
import 'package:bloodDonate/ui/Animation/FadeAnimation.dart';
import 'package:bloodDonate/ui/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bloodDonate/ui/utils/tools.dart';
import 'package:bloodDonate/ui/utils/validators.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_place/google_place.dart';
import 'package:geocoder/geocoder.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:intl/intl.dart';

import '../../utill/color_constant.dart';
import '../../utill/image_constant.dart';
import '../../utill/math_utils.dart';
import '../theme/app_style.dart';
import 'BloodRequestDetail.dart';
import 'MyDialogBox.dart';

class AllBloodRequestsPage extends StatefulWidget {
  static const String routeName = '/allbloodrequests';

  const AllBloodRequestsPage();

  @override
  _AllBloodRequestsPageState createState() => _AllBloodRequestsPageState();
}

class _AllBloodRequestsPageState extends State<AllBloodRequestsPage> {
  bool _isLoading = false;
  bool _isSelected = false;
  TextEditingController editingController = TextEditingController();

  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _publishTopicController = TextEditingController();
  final _subscribeTopicController = TextEditingController();
  final _pubMsg1Controller = TextEditingController();
  final _pubMsg2Controller = TextEditingController();
  final _pubMsg3Controller = TextEditingController();
  final _pubMsg4Controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadData();
  }

  // Asynchronous function to load the data
  Future<void> _loadData() async {
    BloodRequestProvider myData =
        Provider.of<BloodRequestProvider>(context, listen: false);
    myData.getData();

    Future.delayed(Duration(seconds: 1), () {
      _hostController.text = myData.mqttHost;
      _portController.text = myData.mqttPort;
      _subscribeTopicController.text = myData.mqttSUbscribeTopic;
      _publishTopicController.text = myData.mqttPublishTopic;
      _pubMsg1Controller.text = myData.pubMsg1;
      _pubMsg2Controller.text = myData.pubMsg2;
      _pubMsg3Controller.text = myData.pubMsg3;
      _pubMsg4Controller.text = myData.pubMsg4;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  void showSuccesstoast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showFailedtoast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _publishTopicController.dispose();
    _subscribeTopicController.dispose();
    _pubMsg1Controller.dispose();
    _pubMsg2Controller.dispose();
    _pubMsg3Controller.dispose();
    _pubMsg4Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    const elementsSpacer = SizedBox(height: 16);

    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MQTT Connection settings', style: TextStyle(fontSize: 20))
              ],
            ),
          ),
        ),
        body: Container(
          // Add your desired background color here
          child: SingleChildScrollView(
            child: Consumer<BloodRequestProvider>(
                builder: (context, bloodRequestProvider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 50,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Host : ',
                                contentPadding: EdgeInsets.all(10),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: _hostController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      bloodRequestProvider.mqttHost?.isNotEmpty
                                          ? bloodRequestProvider.mqttHost
                                          : '',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 50,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Tcp Port : ',
                                contentPadding: EdgeInsets.all(10),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: _portController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      bloodRequestProvider.mqttPort?.isNotEmpty
                                          ? bloodRequestProvider.mqttPort
                                          : '',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: bloodRequestProvider.mqttConnectivityBtnVisible,
                    child: Container(
                      width: 140,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: !bloodRequestProvider.isMqttConnected
                            ? () {
                                if (_hostController.text.trim() == "") {
                                  showtoast("Please enter IP address");
                                } else if (_portController.text.trim() == "") {
                                  showtoast("Please eneter port");
                                } else {
                                  bloodRequestProvider
                                      .connectToBroker(
                                          ip: _hostController.text.trim(),
                                          port: _portController.text.trim())
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      // _resetFields();
                                      showSuccesstoast(status.message);
                                    } else {
                                      showFailedtoast(status.message +
                                          " " +
                                          _hostController.text.trim());
                                    }
                                  });
                                }
                              }
                            : null,
                        child: Text('Connect'),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: bloodRequestProvider.mqttDisconnectivityBtnVisible,
                    child: Container(
                      width: 140,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: bloodRequestProvider.isMqttConnected
                            ? () {
                                bloodRequestProvider
                                    .disConnectFromBroker()
                                    .then((status) async {
                                  if (status.isSuccess) {
                                    showSuccesstoast(status.message);
                                  } else {
                                    showFailedtoast(status.message);
                                  }
                                });
                              }
                            : null,
                        child: Text('DisConnect'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 170,
                            height: 50,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Subscribe Topic : ',
                                contentPadding: EdgeInsets.all(10),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: _subscribeTopicController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: bloodRequestProvider
                                          .mqttSUbscribeTopic?.isNotEmpty
                                      ? bloodRequestProvider.mqttSUbscribeTopic
                                      : '',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: bloodRequestProvider.isMqttConnected
                          ? () {
                              if (_subscribeTopicController.text.trim() == "") {
                                showtoast("Please enter subscribe topic");
                              } else {
                                bloodRequestProvider
                                    .subscribeToTopic(
                                        topic: _subscribeTopicController.text
                                            .trim())
                                    .then((status) async {
                                  if (status.isSuccess) {
                                    // _resetFields();
                                    showSuccesstoast(status.message);
                                  } else {
                                    showFailedtoast(status.message);
                                  }
                                });
                              }
                            }
                          : null,
                      child: Text('Subscribe'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 23),
                    child: TextField(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Publish Topic',
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextField(
                                  controller: _publishTopicController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Name Of Topic',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 170,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextField(
                                      controller: _pubMsg1Controller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'MSG Button 1',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.0),
                                Container(
                                  width: 170,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextField(
                                      controller: _pubMsg2Controller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'MSG Button 2',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 170,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextField(
                                      controller: _pubMsg3Controller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'MSG Button 3',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.0),
                                Container(
                                  width: 170,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextField(
                                      controller: _pubMsg4Controller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'MSG Button 4',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  bloodRequestProvider
                                      .storePublishData(
                                    topic: _publishTopicController.text.trim(),
                                    msg1: _pubMsg1Controller.text.trim(),
                                    msg2: _pubMsg2Controller.text.trim(),
                                    msg3: _pubMsg3Controller.text.trim(),
                                    msg4: _pubMsg4Controller.text.trim(),
                                  )
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      // _resetFields();
                                      showSuccesstoast(status.message);
                                    } else {
                                      showFailedtoast(status.message);
                                    }
                                  });
                                },
                                child: Text('Save'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _showDialogBox(context);
                      },
                      child: Text('Delay'),
                    ),
                  ),
                ],
              );
            }),
          ),
        ));
  }

  void _showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialogBox();
      },
    );
  }

  Widget BloodRequestItem(BloodRequestModel responseModel) {
    return item(responseModel);
  }

  Widget item(BloodRequestModel bloodRequestModel) {
    List<Widget> errorWidgetList = [];
    int errorCount = 0;

    return Container(
        margin: const EdgeInsets.all(10),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BloodRequestDetail(
                        bloodGroup: bloodRequestModel.bloodGroup,
                        requesterName: bloodRequestModel.requesterName,
                        addedTime: bloodRequestModel.addedTime,
                        numberOfUnits: bloodRequestModel.numberOfUnits,
                        address: bloodRequestModel.cityName,
                        medicalCenterName: bloodRequestModel.medicalCenterName,
                        contactNumber: bloodRequestModel.contactNumber)),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                top: getVerticalSize(
                  12.50,
                ),
                bottom: getVerticalSize(
                  12.50,
                ),
              ),
              decoration: BoxDecoration(
                color: ColorConstant.whiteA700,
                borderRadius: BorderRadius.circular(
                  getHorizontalSize(
                    10.00,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.gray80019,
                    spreadRadius: getHorizontalSize(
                      2.00,
                    ),
                    blurRadius: getHorizontalSize(
                      2.00,
                    ),
                    offset: Offset(
                      0,
                      5,
                    ),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        14.00,
                      ),
                      top: getVerticalSize(
                        13.00,
                      ),
                      bottom: getVerticalSize(
                        13.00,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        getHorizontalSize(
                          10.00,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/user_avatar.jpg',
                        height: getSize(
                          95.00,
                        ),
                        width: getSize(
                          95.00,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getHorizontalSize(
                        27.00,
                      ),
                      top: getVerticalSize(
                        29.00,
                      ),
                      bottom: getVerticalSize(
                        28.00,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: getHorizontalSize(
                              10.00,
                            ),
                          ),
                          child: Text(
                            bloodRequestModel.requesterName,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.textstylepoppinsmedium16.copyWith(
                              fontSize: getFontSize(
                                20,
                              ),
                              letterSpacing: 0.32,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: getVerticalSize(
                              14.00,
                            ),
                            right: getHorizontalSize(
                              7.00,
                            ),
                            bottom: getVerticalSize(
                              2.00,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: getVerticalSize(
                                    2.00,
                                  ),
                                ),
                                child: Container(
                                  height: getSize(
                                    16.00,
                                  ),
                                  width: getSize(
                                    16.00,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/images/mappin.svg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    9.00,
                                  ),
                                ),
                                child: Text(
                                  bloodRequestModel.cityName,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.textstylepoppinsmedium12
                                      .copyWith(
                                    fontSize: getFontSize(
                                      15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: getVerticalSize(
                              14.00,
                            ),
                            right: getHorizontalSize(
                              7.00,
                            ),
                            bottom: getVerticalSize(
                              2.00,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: getVerticalSize(
                                    2.00,
                                  ),
                                ),
                                child: Container(
                                  height: getSize(
                                    16.00,
                                  ),
                                  width: getSize(
                                    16.00,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/images/mappin.svg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getHorizontalSize(
                                    9.00,
                                  ),
                                ),
                                child: Text(
                                  bloodRequestModel.addedTime,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.textstylepoppinsmedium12
                                      .copyWith(
                                    fontSize: getFontSize(
                                      15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: getVerticalSize(
                      50.00,
                    ),
                    width: getHorizontalSize(
                      35.00,
                    ),
                    margin: EdgeInsets.only(
                      top: getVerticalSize(
                        31.00,
                      ),
                      right: getHorizontalSize(
                        0.00,
                      ),
                      bottom: getVerticalSize(
                        30.00,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: getVerticalSize(
                              50.00,
                            ),
                            width: getHorizontalSize(
                              35.00,
                            ),
                            child: SvgPicture.asset(
                              "assets/images/img_vector.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: getHorizontalSize(
                                5.14,
                              ),
                              top: getVerticalSize(
                                10.00,
                              ),
                              right: getHorizontalSize(
                                4.13,
                              ),
                              bottom: getVerticalSize(
                                8.00,
                              ),
                            ),
                            child: Text(
                              bloodRequestModel.bloodGroup,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style:
                                  AppStyle.textstylepoppinsmedium161.copyWith(
                                fontSize: getFontSize(
                                  16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget noData() {
    return Center(
      child: Container(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
    );
  }
}
