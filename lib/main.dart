import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoapp/home_screen.dart';
import 'package:todoapp/login_screen.dart';
import 'package:todoapp/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ToDo",
      theme: ThemeData(
          primarySwatch: Colors.indigo, primaryColor: Colors.indigo[200]),
      home: _auth.currentUser != null ? HomeScreen() : LoginScreen(),
    );
  }
}
