// ignore_for_file: file_names

import 'package:bloodDonate/blocks/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:bloodDonate/blocks/AuthenticationBloc.dart';
import 'package:bloodDonate/blocks/BlocProvider.dart';
import 'package:bloodDonate/states/AuthenticationState.dart';
import 'package:bloodDonate/ui/Animation/FadeAnimation.dart';
import 'package:bloodDonate/ui/pages/LoginPage.dart';
import 'package:bloodDonate/ui/utils/blood_types.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupPage();

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  AuthenticationBloc _signupBloc;
  String _email;
  String _password;
  String _confirmPassword;
  var _bloodType = 'A+';
  AuthenticationState oldAuthenticationState;
  bool _isObscurePass = true;
  bool _isObscureComPass = true;
  String _emailEmpty = "Please enter email";
  String _passwordEmpty = "Please enter password";
  String _confirmPasswordEmpty = "Please enter confirm password";
  String _passwordMissMatch = "Passwords does not match";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _signupBloc = BlocProvider.of<AuthenticationBloc>(context);
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return Stack(children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 400,
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
                              "SignUp",
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
                                              TextStyle(color: Colors.grey)),
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (text) {
                                        _email = text;
                                      },
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: DropdownButtonFormField<String>(
                                        value: _bloodType,
                                        onChanged: (v) {
                                          _bloodType = v;
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Blood Type',
                                        ),
                                        items: BloodTypeUtils.bloodTypes
                                            .map((v) => DropdownMenuItem(
                                                  value: v,
                                                  child: Text(v),
                                                ))
                                            .toList(),
                                      )),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: TextFormField(
                                      obscureText: _isObscureComPass,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Confirm Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          suffixIcon: IconButton(
                                              icon: Icon(_isObscureComPass
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscureComPass =
                                                      !_isObscureComPass;
                                                });
                                              })),
                                      onChanged: (text) {
                                        _confirmPassword = text;
                                      },
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 20,
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
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (_email == null) {
                                  showtoast(_emailEmpty);
                                } else if (_password == null) {
                                  showtoast(_passwordEmpty);
                                } else if (_confirmPassword == null) {
                                  showtoast(_confirmPasswordEmpty);
                                } else if (_passwordEmpty == _confirmPassword) {
                                  showtoast(_passwordMissMatch);
                                } else {
                                  authProvider
                                      .signUpWithEmailAndPassword(
                                          email: _email.trim(),
                                          password: _password.trim(),
                                          bloodType: _bloodType)
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => LoginPage()),
                                          (route) => false);
                                    } else {
                                      showtoast(status.message);
                                    }
                                  });
                                }
                              }),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                          2,
                          InkWell(
                              child: Center(
                                  child: Text(
                                "Already have an Account?",
                                style: TextStyle(
                                  color: Color.fromRGBO(13, 50, 77, 1),
                                ),
                              )),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
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
          ]);
        }),
      ),
    );
  }
}
