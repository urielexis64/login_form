import 'package:flutter/material.dart';
import 'package:login_form/constants.dart';
import 'package:login_form/src/bloc/provider.dart';
import 'package:login_form/src/pages/home/home_page.dart';
import 'package:login_form/src/pages/login/login_page.dart';
import 'package:login_form/src/pages/product/product_page.dart';
import 'package:login_form/src/pages/signup/signup_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Forms',
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryLightColor,
      ),
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'signup': (BuildContext context) => SignupPage(),
        'product': (BuildContext context) => ProductPage(),
      },
    ));
  }
}
