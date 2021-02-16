import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_form/src/shared/animation/infinite_animation.dart';
import 'package:login_form/src/shared/components/already_have_an_account.dart';
import 'package:login_form/src/shared/components/rounded_button.dart';
import 'package:login_form/src/shared/components/rounded_input_field.dart';
import 'package:login_form/src/shared/components/rounded_password_field.dart';

import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  InfiniteAnimation infiniteAnimation;

  @override
  void initState() {
    infiniteAnimation = InfiniteAnimation(
        provider: this,
        beginValue: -5,
        endValue: 5,
        reverse: true,
        curve: Curves.ease,
        duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    infiniteAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'LOGIN',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AnimatedBuilder(
            animation: infiniteAnimation.view,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, infiniteAnimation.value),
              child: child,
            ),
            child: SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * .25,
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          RoundedInputField(
            hintText: 'Email',
            icon: Icons.email,
            onChanged: (value) {},
          ),
          RoundedPasswordField(
            onChanged: (value) {},
          ),
          RoundedButton(
            text: 'LOGIN',
            press: () {},
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHaveAnAccountCheck(
            login: true,
            press: () => Navigator.pushReplacementNamed(context, 'signup'),
          )
        ],
      ),
    ));
  }
}
