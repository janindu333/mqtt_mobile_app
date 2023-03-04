import 'package:bloodDonate/blocks/splash_provider.dart';
import 'package:bloodDonate/ui/Animation/FadeAnimation.dart';
import 'package:bloodDonate/ui/pages/LoginPage.dart';
import 'package:bloodDonate/ui/pages/MainPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:bloodDonate/ui/routes/RoutePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocks/blood_request_block_provider.dart';
import '../../common/assets.dart';
import '../../common/hive_boxes.dart';
import '../../common/styles.dart';
import 'tutorial_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(_resolveDestination);
    initPrefs();
  }

  initPrefs() async {
    Provider.of<SplashProvider>(context, listen: false)
        .getToken(context)
        .then((value) {
      Future.delayed(const Duration(seconds: 3), () => _route(value));
    });
  }

  void _route(value) async {
    final isFirstLaunch = Hive.box(ConfigBox.key)
        .get(ConfigBox.isFirstLaunch, defaultValue: true) as bool;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    BloodRequestProvider bloodRequestProvider =
        Provider.of<BloodRequestProvider>(context, listen: false);

    bool isactivated = prefs.getBool('_isActivated') ?? false;

    print(isactivated);

    if (!isactivated) {
      _destination = RoutePage.tutorial;
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutePage.tutorial, (route) => false,
          arguments: TutorialScreen());
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutePage.main, (route) => false,
          arguments: MainPage());
    }
  }

  String _destination = '';

  Future<void> _resolveDestination() async {
    debugPrint('Firebase init complete');

    // Allows the splash screen to remain for a bit longer
    await Future.delayed(const Duration(seconds: 2));

    final isFirstLaunch = Hive.box(ConfigBox.key)
        .get(ConfigBox.isFirstLaunch, defaultValue: true) as bool;

    _destination = RoutePage.main;
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutePage.main, (route) => false,
        arguments: MainPage());
    _updateCachedData();
  }

  void _redirectToNamedPage(BuildContext context, String routeName) {
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(context, routeName);
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(AssetImage('assets/images/feturedEvent.jpg'), context);
    super.didChangeDependencies();
  }

  Future<void> _updateCachedData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      final configBox = Hive.box(ConfigBox.key);
      configBox.put(
        ConfigBox.bloodType,
        value.data()['bloodType'] as String,
      );
      configBox.put(
        ConfigBox.isAdmin,
        value.data()['isAdmin'] as bool ?? false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: AssetImage('assets/images/cover.png'),
              fit: BoxFit.cover,
            ),
          ),
        )),
      ),
    );
  }
}
