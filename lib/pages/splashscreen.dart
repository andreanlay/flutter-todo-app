import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:test_project/pages/startscreen.dart';
import 'package:test_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with AfterLayoutMixin<Splashscreen> {
  Future checkSeen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool _seen = (pref.getBool('seen') ?? false);
    String email = (pref.getString('email') ?? null);
    String username = (pref.getString('username') ?? null);

    print('------------ Im in splash!');

    if(_seen && email != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TodoApp(email, username),
        ));
    } else {
      pref.setBool('seen', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Startscreen()
        ));
      }
    }
    
  @override
  void afterFirstLayout(BuildContext context) => checkSeen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TO-DIFY',
                style: TextStyle(color: Colors.black, fontSize: 28),
              ),
            ],
          ),
        )
      )
    );
  }
}