// ignore_for_file: file_names
import 'package:bloodDonate/ui/pages/HomePage.dart';
import 'package:bloodDonate/ui/pages/LoginPage.dart';
import 'package:bloodDonate/ui/pages/MainPage.dart';
import 'package:bloodDonate/ui/pages/PostAEvent.dart';
import 'package:bloodDonate/ui/pages/RequestBlood.dart';
import 'package:bloodDonate/ui/pages/SignupPage.dart';
import 'package:bloodDonate/ui/pages/allBloodRequestsPage.dart';
import 'package:bloodDonate/ui/pages/splash_screen.dart';
import 'package:bloodDonate/ui/pages/tutorial_screen.dart';

class RoutePage {
  static const String login = LoginPage.routeName;
  static const String signUp = SignupPage.routeName;
  static const String tutorial = TutorialScreen.routeName;
  static const String main = MainPage.routeName;
  static const String splash = SplashScreen.routeName;
  static const String requestBlood = RequestBlood.routeName;
  static const String homePage = HomePage.routeName;
  static const String postAEvent = PostAEvent.routeName;
  static const String alBoodrequests = AllBloodRequestsPage.routeName;
}
