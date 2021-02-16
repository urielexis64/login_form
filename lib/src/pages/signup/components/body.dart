import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_form/src/shared/animation/infinite_animation.dart';
import 'package:login_form/src/shared/components/already_have_an_account.dart';
import 'package:login_form/src/shared/components/rounded_button.dart';
import 'package:login_form/src/shared/components/rounded_input_field.dart';
import 'package:login_form/src/shared/components/rounded_password_field.dart';

import 'background.dart';
import 'or_divider.dart';
import 'social_icon.dart';

class Body extends StatefulWidget {
  final Widget child;

  const Body({Key key, @required this.child}) : super(key: key);

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
            'SIGN UP',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          AnimatedBuilder(
            animation: infiniteAnimation.view,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, infiniteAnimation.value),
                child: child,
              );
            },
            child: SvgPicture.asset(
              'assets/icons/signup.svg',
              height: size.height * .3,
            ),
          ),
          RoundedInputField(
              hintText: 'Email', icon: Icons.person, onChanged: (value) {}),
          RoundedPasswordField(
            onChanged: (value) {},
          ),
          RoundedButton(
            text: 'SIGN UP',
            press: () {},
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
          OrDivider(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SocialIcon(iconSrc: 'assets/icons/facebook.svg', press: () {}),
            SocialIcon(iconSrc: 'assets/icons/twitter.svg', press: () {}),
            SocialIcon(iconSrc: 'assets/icons/google-plus.svg', press: () {})
          ])
        ],
      ),
    ));
  }
}
