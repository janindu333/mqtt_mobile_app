// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, sized_box_for_whitespace

import 'dart:async';

import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:bloodDonate/blocks/blood_request_block_provider.dart';
import 'package:bloodDonate/blocks/slide_bar_menu_povider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloodDonate/blocks/BloodRequestBloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AllBloodRequestsPage.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/main';

  // ignore: use_key_in_widget_constructors
  const MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BloodRequestBloc _bloodRequestBloc;
  double avatarDiameter = 60.0 * 2;
  double curveHeight = 60.0 * 2.5;
  final _drawerController = AwesomeDrawerBarController();
  int _currentPage = 0;
  SharedPreferences prefs;

  @override
  void initState() {
    _loadInitialMqttData();
  }

  Future<void> _loadInitialMqttData() async {
    prefs = await SharedPreferences.getInstance();
    bool _isMqttConnected = prefs.getBool('_isMqttConnected') ?? false;

    print("_isMqttConnected  ,  $_isMqttConnected");

    if (_isMqttConnected) {
      BloodRequestProvider bloodRequestProvider =
          Provider.of<BloodRequestProvider>(context, listen: false);
      bloodRequestProvider
          .connectToBroker(
              ip: prefs.getString('_mqttHost'),
              port: prefs.getString('_mqttPort'))
          .then((status) async {
        if (status.isSuccess) {
          // _resetFields();
          showSuccesstoast(status.message);

          BloodRequestProvider myData =
              Provider.of<BloodRequestProvider>(context, listen: false);
          myData.getData();

          myData
              .subscribeToTopic(
                  topic: prefs.getString('_mqttSUbscribeTopic').trim())
              .then((status) async {
            if (status.isSuccess) {
              // _resetFields();
              showSuccesstoast(status.message);
            } else {
              showFailedtoast(status.message);
            }
          });
        } else {
          showFailedtoast(status.message + " ");
        }
      });
    } else {
      BloodRequestProvider myData =
          Provider.of<BloodRequestProvider>(context, listen: false);
      myData.getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'GPRS BASED STRATER BY thingsworld.cloud',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
      ),
    );
  }
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            margin: EdgeInsets.only(top: 25), // Add a top margin of 100 pixels
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cover.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Add any other properties you want to your AppBar
        ),
        body: Container(
            color: Colors.white, // Add your desired background color here
            child: Consumer<BloodRequestProvider>(
                builder: (context, bloodRequestProvider, child) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Visibility(
                              visible: bloodRequestProvider
                                  .mqttConnectivityBtnVisible,
                              child: InkWell(
                                onTap: () {
                                  bloodRequestProvider
                                      .connectToBroker(
                                          ip: bloodRequestProvider.mqttHost
                                              .trim(),
                                          port: bloodRequestProvider.mqttPort
                                              .trim())
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      // _resetFields();
                                      showSuccesstoast(status.message);

                                      bloodRequestProvider
                                          .subscribeToTopic(
                                        topic: bloodRequestProvider
                                            .mqttSUbscribeTopic
                                            .trim(),
                                      )
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          // _resetFields();
                                          showSuccesstoast(status.message);
                                        } else {
                                          showFailedtoast(status.message);
                                        }
                                      });
                                    } else {
                                      showFailedtoast(status.message);
                                    }
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/connect.png',
                                  width: 150,
                                  height: 50,
                                ),
                              )),
                          Visibility(
                            visible: bloodRequestProvider
                                .mqttDisconnectivityBtnVisible,
                            child: InkWell(
                              onTap: () {
                                bloodRequestProvider
                                    .disConnectFromBroker()
                                    .then((status) async {
                                  if (status.isSuccess) {
                                    showSuccesstoast(status.message);
                                  } else {
                                    showFailedtoast(status.message);
                                  }
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF44859F),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Connected',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              String password = '';

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Enter Password'),
                                    content: TextField(
                                      obscureText: true,
                                      onChanged: (value) {
                                        password = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text('Submit'),
                                        onPressed: () {
                                          checkPassword(
                                              password.trim(), context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Image.asset(
                              'assets/images/setting.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Consumer<BloodRequestProvider>(
                            builder: (context, bloodRequestProvider, _) {
                              if (bloodRequestProvider.listOfPairRequests !=
                                  null) {
                                if (bloodRequestProvider
                                        .listOfPairRequests.length >
                                    0) {
                                  return Table(
                                    border: TableBorder.all(
                                        width: 1.0, color: Colors.black),
                                    children: List.generate(
                                      bloodRequestProvider
                                          .listOfPairRequests.length,
                                      (index) {
                                        final item = bloodRequestProvider
                                            .listOfPairRequests[index];
                                        return TableRow(
                                          children: <Widget>[
                                            TableCell(
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(item[0]),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(item[1]),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        top: 50.0), // set top margin
                                    child: Text(
                                      'No device data received.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                              } else {
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 50.0), // set top margin
                                  child: Text(
                                    'No device data received.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            onPressed: bloodRequestProvider.mqttOnButton1
                                ? () {
                                    bloodRequestProvider
                                        .publishMsg1(
                                      topic:
                                          bloodRequestProvider.mqttPublishTopic,
                                      msg: bloodRequestProvider.pubMsg1,
                                    )
                                        .then((status) async {
                                      if (status.isSuccess) {
                                        showSuccesstoast(status.message);
                                      } else {
                                        showFailedtoast(status.message);
                                      }
                                    });
                                  }
                                : null,
                            child: Text(bloodRequestProvider.topMsg1 ?? 'ON'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(
                                  0xFF44859F), // or any other color you prefer
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(120, 50), // adjust as needed
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: bloodRequestProvider.mqttOnButton2
                              ? () {
                                  bloodRequestProvider
                                      .publishMsg2(
                                    topic:
                                        bloodRequestProvider.mqttPublishTopic,
                                    msg: bloodRequestProvider.pubMsg2,
                                  )
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      showSuccesstoast(status.message);
                                    } else {
                                      showFailedtoast(status.message);
                                    }
                                  });
                                }
                              : null,
                          child: Text(bloodRequestProvider.topMsg2 ?? 'OFF'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(
                                0xFF44859F), // or any other color you prefer
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(120, 50), // adjust as needed
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: bloodRequestProvider.mqttOnButton3
                              ? () {
                                  bloodRequestProvider
                                      .publishMsg3(
                                    topic:
                                        bloodRequestProvider.mqttPublishTopic,
                                    msg: bloodRequestProvider.pubMsg3,
                                  )
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      showSuccesstoast(status.message);
                                    } else {
                                      showFailedtoast(status.message);
                                    }
                                  });
                                }
                              : null,
                          child: Text(bloodRequestProvider.topMsg3 ?? 'GET'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(
                                0xFF44859F), // or any other color you prefer
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(120, 50), // adjust as needed
                          ),
                        ),
                        ElevatedButton(
                          onPressed: bloodRequestProvider.mqttOnButton4
                              ? () {
                                  bloodRequestProvider
                                      .publishMsg4(
                                    topic:
                                        bloodRequestProvider.mqttPublishTopic,
                                    msg: bloodRequestProvider.pubMsg4,
                                  )
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      showSuccesstoast(status.message);
                                    } else {
                                      showFailedtoast(status.message);
                                    }
                                  });
                                }
                              : null,
                          child: Text(bloodRequestProvider.topMsg4 ?? 'GSC'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(
                                0xFF44859F), // or any other color you prefer
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(120, 50), // adjust as needed
                          ),
                        ),
                      ],
                    ),
                  ]);
            })));
  }

  void checkPassword(String password, BuildContext context) {
// defaullt pass 8866188126
    BloodRequestProvider bloodRequestProvider =
        Provider.of<BloodRequestProvider>(context, listen: false);
    final String defaultPass = bloodRequestProvider.activationCode;
    if (password == "8866188126") {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllBloodRequestsPage(),
        ),
      );
      showSuccesstoast("Password is correct");
    } else {
      Navigator.of(context).pop();
      showFailedtoast("You entered wrong password");
    }
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
}
