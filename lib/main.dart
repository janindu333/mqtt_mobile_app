// ignore_for_file: unused_local_variable

import 'package:bloodDonate/ui/pages/HomePage.dart';
import 'package:bloodDonate/ui/pages/PostAEvent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bloodDonate/blocks/BlocProvider.dart';
import 'package:bloodDonate/ui/pages/MainPage.dart';
import 'package:bloodDonate/ui/pages/RequestBlood.dart';
import 'package:bloodDonate/ui/pages/SignupPage.dart';
import 'package:bloodDonate/ui/pages/tutorial_screen.dart';
import 'package:bloodDonate/ui/routes/RoutePage.dart';
import 'package:provider/provider.dart';

import 'blocks/AuthProvider.dart';
import 'blocks/BloodRequestBloc.dart';
import 'blocks/blood_request_block_provider.dart';
import 'blocks/slide_bar_menu_povider.dart';
import 'blocks/splash_provider.dart';
import 'common/hive_boxes.dart';
import 'ui/pages/LoginPage.dart';
import 'firebase_options.dart';
import 'ui/pages/splash_screen.dart';
import 'di_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox(ConfigBox.key);
  await di.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => di.sl<BloodRequestProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<MenuProvider>()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    BloodRequestBloc _bloodrequestBloc = BloodRequestBloc();
    return MaterialApp(
      title: 'Things  World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green, primaryColor: Color(0xFF348565)),
      // home: RootPage(),
      home: SplashScreen(),
      builder: EasyLoading.init(),
      routes: {
        RoutePage.splash: (context) => SplashScreen(),
        RoutePage.login: (context) => const LoginPage(),
        RoutePage.tutorial: (context) => const TutorialScreen(),
        RoutePage.homePage: (context) => const HomePage(),
        RoutePage.main: (context) => const MainPage(),
        RoutePage.signUp: (context) => const SignupPage(),
        RoutePage.requestBlood: (context) => const RequestBlood(),
        RoutePage.postAEvent: (context) => const PostAEvent(),
      },
    );
  }
}
