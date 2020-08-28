import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore database = FirebaseFirestore.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
var currentLoggedIn;

Future<bool> checkUser(String id) async {
  try {
    var colReference = database.collection('users');
    var doc = await colReference.doc(id).get();
    return doc.exists;
  }catch(e) {
    throw e;
  }
}

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  final SharedPreferences pref = await SharedPreferences.getInstance();

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  var authResult = await _auth.signInWithCredential(credential);
  var user = authResult.user;
  currentLoggedIn = _auth.currentUser;

  pref.setString('email', currentLoggedIn.email);
  pref.setString('username', currentLoggedIn.displayName);
  print('----${pref.getString('email')}}');
  print('----${pref.getString('username')}}');

  final userExists = await database.collection('users').doc(currentLoggedIn.email).get();
  if(userExists == null || !userExists.exists){
    database.collection('users').doc(currentLoggedIn.email).set({
      'email': currentLoggedIn.email,
      'username': currentLoggedIn.displayName,
      'todo_count': 1
    });

    database.collection('users').doc(currentLoggedIn.email)
            .collection('todo').doc('todo0').set({
              'title': 'Welcome to To-Dify!',
              'description': 'Swipe left or right to dismiss todo, long press to add item and press to edit To Do',
              'items': 1,
              'items_done': 0,
            });
    database.collection('users').doc(currentLoggedIn.email)
            .collection('todo').doc('todo0')
            .collection('item').doc('item0').set({
              'item_name': 'This is an item in a To Do.',
              'done': false
            });
  }
  return 'signInWithGoogle succeeded: $user';
}

void googleSignOut() async {
  await googleSignIn.signOut();
}

String getEmail() {
  return currentLoggedIn.email;
}

String getUsername() {
  return currentLoggedIn.displayName;
}