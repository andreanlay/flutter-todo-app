import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_project/pages/homescreen.dart';
import 'package:test_project/pages/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MaterialApp(home: Splashscreen()));
}

class TodoApp extends StatelessWidget {
  final email;
  final username;

  TodoApp(this.email, this.username);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: Homescreen(email: email, username: username),
    );
  }
}