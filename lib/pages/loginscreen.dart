import 'package:flutter/material.dart';
import 'package:test_project/firebase/sign_in.dart';
import 'package:test_project/pages/homescreen.dart';

class Loginscreen extends StatelessWidget {
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
              SizedBox(height: 18.0),
              OutlineButton(
                onPressed: () {
                  signInWithGoogle().whenComplete(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondAnimation) => Homescreen(email: currentLoggedIn.email, username: currentLoggedIn.displayName),
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
                  });
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                borderSide: BorderSide(color: Colors.grey),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(image: AssetImage('assets/google_logo.png'), height: 30.0,),
                      SizedBox(width: 8.0),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey
                        )
                      )
                    ],
                  ),
                )
              )
            ],
          ),
        )
      )
    );
  }
}