import 'package:bloodDonate/ui/pages/MainPage.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:bloodDonate/ui/pages/RootPage.dart';
import 'package:provider/provider.dart';

import '../../blocks/blood_request_block_provider.dart';
import '../../common/assets.dart';
import '../../common/colors.dart';
import '../../common/hive_boxes.dart';
import 'LoginPage.dart';

class TutorialScreen extends StatefulWidget {
  static const String routeName = '/tutorial';
  static const route = 'tutorial';
  const TutorialScreen({Key key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  final _controller = PageController();
  int _currentIndex = 0;
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.page.round() != _currentIndex) {
        setState(() => _currentIndex = _controller.page.round());
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Activation Code', style: TextStyle(fontSize: 20))],
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<BloodRequestProvider>(
              builder: (context, bloodRequestProvider, child) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    "Enter activation code",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Container(
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
                          keyboardType: TextInputType.number,
                          controller: _codeController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: bloodRequestProvider.mqttHost?.isNotEmpty
                                ? bloodRequestProvider.mqttHost
                                : '',
                          ),
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: InkWell(
                      onTap: () {
                        bloodRequestProvider
                            .activateCode(code: _codeController.text.trim())
                            .then((status) async {
                          if (status.isSuccess) {
                            // _resetFields();
                            showSuccesstoast(status.message);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(),
                              ),
                            ).then((status) async {
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
                        'assets/images/active.png',
                        width: 150,
                        height: 50,
                      ),
                    ))
              ],
            ));
          })),
    );
  }
}
