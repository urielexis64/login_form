import 'package:flutter/material.dart';
import 'package:login_form/src/pages/home/home_page.dart';
import 'package:login_form/src/pages/login/login_page.dart';
import 'package:login_form/src/pages/signup/signup_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Forms',
      initialRoute: 'login',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'signup': (BuildContext context) => SignupPage(),
      },
    );
  }
}
