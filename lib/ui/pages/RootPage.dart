// ignore_for_file: file_names

import 'package:bloodDonate/blocks/AuthenticationBloc.dart';
import 'package:flutter/material.dart';
import 'package:bloodDonate/blocks/BlocEventStateBuilder.dart';
import 'package:bloodDonate/blocks/BlocProvider.dart';
import 'package:bloodDonate/events/authentication/AuthenticationEvent.dart';
import 'package:bloodDonate/states/AuthenticationState.dart';
import 'package:bloodDonate/ui/routes/RoutePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthenticationState _oldAuthenticationState;
  AuthenticationBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<AuthenticationBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocEventStateBuilder<AuthenticationEvent, AuthenticationState>(
        bloc: _bloc,
        builder: (BuildContext context, AuthenticationState state) {
          if (state != _oldAuthenticationState) {
            _oldAuthenticationState = state;
            if (state.isAuthenticated) {
              saveUserData(
                  state.token, state.userID, state.email, state.loginID);
              _redirectToNamedPage(context, RoutePage.main);
            } else if (state.isAuthenticating || state.hasFailed) {
              //do nothing

            } else {
              getToken(context).then((value) {
                if (value != null) {
                  _redirectToNamedPage(context, RoutePage.main);
                } else {
                  _redirectToNamedPage(context, RoutePage.login);
                }
              });
            }
          }
          return Container();
        });
  }

  Future<String> getToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unnecessary_null_in_if_null_operators
    return prefs.getString('accessToken') ?? null;
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  Future<void> saveUserData(
      String token, String userID, String email, String loginId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    await prefs.setString('userId', userID);
    // await prefs.setString('email', email);
    await prefs.setString('loginId', loginId);
  }

  void _redirectToNamedPage(BuildContext context, String routeName) {
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(context, routeName);
    });
  }
}
