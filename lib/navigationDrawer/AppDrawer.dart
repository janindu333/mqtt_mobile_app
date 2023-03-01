// ignore_for_file: prefer_const_constructors

import 'package:bloodDonate/blocks/AuthProvider.dart';
import 'package:bloodDonate/ui/pages/LoginPage.dart';
import 'package:bloodDonate/ui/pages/PostAEvent.dart';
import 'package:flutter/material.dart';
import 'package:bloodDonate/ui/pages/MainPage.dart';
import 'package:bloodDonate/ui/pages/RequestBlood.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/avatar.png'))),
            child: Column(
              children: [
                Container(
                  child: Text(
                    'Username',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  alignment: Alignment.bottomLeft,
                ),
                Row(
                  children: [
                    Image.asset('assets/images/ic_star.png'),
                    Container(
                      child: Text(
                        '4.2',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      padding: EdgeInsets.only(left: 5),
                    ),
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30),
            title: Text(
              "Home",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, MainPage.routeName);
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.white,
            indent: 50,
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30),
            title: Text(
              "Request Blood",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, RequestBlood.routeName);
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.white,
            indent: 50,
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30),
            title: Text(
              "Post a Event",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, PostAEvent.routeName);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30),
            title: Text(
              "Log out",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false)
                  .logout()
                  .then((status) async {
                if (status.isSuccess) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false);
                }
              });
            },
          ),
          Center(
            child: Image.asset('assets/images/ic_aigrow.png'),
          ),
        ],
      ),
      decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
    ));
  }
}
