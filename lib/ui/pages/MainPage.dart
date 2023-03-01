// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, sized_box_for_whitespace

import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:bloodDonate/blocks/blood_request_block_provider.dart';
import 'package:bloodDonate/blocks/slide_bar_menu_povider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloodDonate/blocks/BloodRequestBloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
 
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GPRS BASED STARTER BY', style: TextStyle(fontSize: 20)),
                Text('thingsworld.cloud', style: TextStyle(fontSize: 16)),
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
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // center the buttons within the row
                      children: [
                        Container(
                          width: 120, // set the width of the button
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            child: Text('Reset'),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Container(
                          width: 120, // set the width of the button
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllBloodRequestsPage()),
                              );
                            },
                            child: Text('Settings'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Card(
                        elevation:
                            4.0, // add some elevation to give the card some depth
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), // set the radius of the corners
                        ),
                        child: SizedBox(
                          width: 400, // set the width of the card
                          height: 400, // set the height of the card
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            child: Text(
                              bloodRequestProvider.mqttMessage == null
                                  ? "Messages Not Recieved yet"
                                  : bloodRequestProvider.mqttMessage,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: ElevatedButton(
                              onPressed: bloodRequestProvider.mqttOnButton1
                                  ? () {
                                      bloodRequestProvider
                                          .publishMsg1(
                                              topic: bloodRequestProvider
                                                  .mqttPublishTopic,
                                              msg: bloodRequestProvider.pubMsg1)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          showSuccesstoast(status.message);
                                        } else {
                                          showFailedtoast(status.message);
                                        }
                                      });
                                    }
                                  : null,
                              child: Text('ON Button 1'),
                            ),
                          ),
                          SizedBox(width: 2.0),
                          Container(
                            width: 100,
                            height: 100,
                            child: ElevatedButton(
                              onPressed: bloodRequestProvider.mqttOnButton2
                                  ? () {
                                      bloodRequestProvider
                                          .publishMsg2(
                                              topic: bloodRequestProvider
                                                  .mqttPublishTopic,
                                              msg: bloodRequestProvider.pubMsg2)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          showSuccesstoast(status.message);
                                        } else {
                                          showFailedtoast(status.message);
                                        }
                                      });
                                    }
                                  : null,
                              child: Text('Off Button 2'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: bloodRequestProvider.mqttOnButton3
                                ? () {
                                    bloodRequestProvider
                                        .publishMsg3(
                                            topic: bloodRequestProvider
                                                .mqttPublishTopic,
                                            msg: bloodRequestProvider.pubMsg3)
                                        .then((status) async {
                                      if (status.isSuccess) {
                                        showSuccesstoast(status.message);
                                      } else {
                                        showFailedtoast(status.message);
                                      }
                                    });
                                  }
                                : null,
                            child: Text('STATUS button 3'),
                          ),
                        ),
                        SizedBox(width: 2.0),
                        Container(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: bloodRequestProvider.mqttOnButton4
                                ? () {
                                    bloodRequestProvider
                                        .publishMsg4(
                                            topic: bloodRequestProvider
                                                .mqttPublishTopic,
                                            msg: bloodRequestProvider.pubMsg4)
                                        .then((status) async {
                                      if (status.isSuccess) {
                                        showSuccesstoast(status.message);
                                      } else {
                                        showFailedtoast(status.message);
                                      }
                                    });
                                  }
                                : null,
                            child: Text('Config button 4'),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
        ));
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
