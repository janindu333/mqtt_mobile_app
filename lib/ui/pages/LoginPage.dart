// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, sized_box_for_whitespace

import 'dart:convert';

import 'package:bloodDonate/blocks/AuthProvider.dart';
import 'package:bloodDonate/common/colors.dart';
import 'package:bloodDonate/ui/pages/MainPage.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bloodDonate/blocks/AuthenticationBloc.dart';
import 'package:bloodDonate/blocks/BlocEventStateBuilder.dart';
import 'package:bloodDonate/blocks/BlocProvider.dart';
import 'package:bloodDonate/events/authentication/AuthenticationEvent.dart';
import 'package:bloodDonate/states/AuthenticationState.dart';
import 'package:bloodDonate/ui/Animation/FadeAnimation.dart';
import 'package:provider/provider.dart';

import 'SignupPage.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationBloc _loginBloc;
  String _password;
  String _email;
  AuthenticationState oldAuthenticationState;
  bool _isObscurePass = true;
  String _emailEmpty = "Please enter email";
  String _passwordEmpty = "Please enter password";

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _loginBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 380,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          height: 480,
                          width: width + 20,
                          child: FadeAnimation(
                              1.3,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/images/svg.png'),
                                        fit: BoxFit.fill)),
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            1.5,
                            Text(
                              "Login",
                              style: TextStyle(
                                  color: Color.fromRGBO(49, 39, 79, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                            1.7,
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(228, 54, 75, .1),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    )
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      onChanged: (text) {
                                        _email = text;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: TextFormField(
                                      obscureText: _isObscurePass,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          suffixIcon: IconButton(
                                              icon: Icon(_isObscurePass
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscurePass =
                                                      !_isObscurePass;
                                                });
                                              })),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      onChanged: (text) {
                                        _password = text;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.7,
                            Center(
                                child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color.fromRGBO(13, 50, 77, 1),
                              ),
                            ))),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                          1.9,
                          InkWell(
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 60),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(13, 50, 77, 1),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (_email == null) {
                                showtoast(_emailEmpty);
                              } else if (_password == null) {
                                showtoast(_passwordEmpty);
                              } else {
                                var bytes = utf8.encode(
                                    _email + _password); // data being hashed
                                var token = sha1
                                    .convert(bytes)
                                    .toString()
                                    .toUpperCase();

                                authProvider
                                    .loginWithEmailAndPassword(
                                        email: _email.trim(),
                                        password: _password.trim())
                                    .then((status) async {
                                  if (status.isSuccess) {
                                    authProvider.saveUserEmailAndPassword(
                                        _email.trim(), _password.trim());
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MainPage()),
                                        (route) => false);
                                  } else {
                                    showtoast(status.message);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                          2,
                          InkWell(
                              child: Center(
                                  child: Text(
                                "Create Account",
                                style: TextStyle(
                                    color: Color.fromRGBO(49, 39, 79, .6)),
                              )),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: (MediaQuery.of(context).size.height / 2) - 5,
                left: (MediaQuery.of(context).size.width / 2) - 50,
                child: authProvider.isLoading
                    ? Container(
                        height: 80,
                        width: 80,
                        child: SpinKitFadingCube(
                          color: Colors.deepPurple,
                          size: 70.0,
                        ))
                    : Container(),
              )
            ],
          );
        }),
      ),
    );
  }
}
