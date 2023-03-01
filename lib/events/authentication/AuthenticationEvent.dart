// ignore_for_file: file_names

import 'package:bloodDonate/blocks/BlocEventStateBase.dart';

abstract class AuthenticationEvent extends BlocEvent {
  String username;
  String password;
  String bloodType;
  String token;
  AuthenticationEvent(
      {this.username, this.password, this.token, this.bloodType});
}

class AuthenticationEventLogin extends AuthenticationEvent {
  AuthenticationEventLogin({String name, String password, String token})
      : super(username: name, password: password, token: token);
}

class AuthenticationEventSignUp extends AuthenticationEvent {
  AuthenticationEventSignUp({String name, String password, String bloodType})
      : super(username: name, password: password, bloodType: bloodType);
}

class AuthenticationEventLogout extends AuthenticationEvent {}
