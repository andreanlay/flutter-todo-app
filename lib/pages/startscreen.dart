import 'package:flutter/material.dart';
import 'package:test_project/pages/loginscreen.dart';

class Startscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to To-Dify!',
                style: TextStyle(color: Colors.black, fontSize: 28),
              ),
              Text(
                'Your trusted To Do app',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondAnimation) => Loginscreen(),
                      transitionsBuilder: (context, animation, secondAnimation, child) {
                        var begin = Offset(1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child
                        );
                      }
                    )
                  );
                },
                child: Icon(Icons.arrow_forward_ios)
              ),
            ],
          ),
        )
      )
    );
  }
}