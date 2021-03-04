import 'package:flutter/material.dart';
import 'package:login_form/constants.dart';
import 'package:login_form/src/bloc/provider.dart';
import 'package:login_form/src/pages/home/home_page.dart';
import 'package:login_form/src/pages/login/login_page.dart';
import 'package:login_form/src/pages/product/product_page.dart';
import 'package:login_form/src/pages/signup/signup_page.dart';
import 'package:login_form/src/preferences/user_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPrefs();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = UserPrefs();
    print(prefs.token);

    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Forms',
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Constants.kPrimaryColor,
        accentColor: Constants.kPrimaryLightColor,
      ),
      //initialRoute: prefs.token != '' ? 'home' : 'login',
      initialRoute: prefs.token == '' ? 'login' : 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'signup': (BuildContext context) => SignupPage(),
        'product': (BuildContext context) => ProductPage(),
      },
    ));
  }
}
