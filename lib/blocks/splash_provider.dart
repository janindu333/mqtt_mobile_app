import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  SharedPreferences prefs;
  SplashProvider({@required this.prefs});

  Future<String> getToken(BuildContext context) async {
    return prefs.getString('user_email') ?? null;
  }

  Future<void> saveToken(String token) async {
    await prefs.setString('user_email', token);
  }
}
